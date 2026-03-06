import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/editor_provider.dart';
import '../../providers/project_provider.dart';
import '../../services/export_service.dart';
import 'canvas_widget.dart';
import 'element_palette.dart';
import 'property_panel.dart';

class EditorScreen extends StatefulWidget {
  const EditorScreen({super.key});

  @override
  State<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> with TickerProviderStateMixin {
  late AnimationController _panelController;
  bool _showPalette = false;
  bool _exporting = false;

  @override
  void initState() {
    super.initState();
    _panelController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _panelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final editor = context.watch<EditorProvider>();
    final project = editor.project;

    if (project == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Editor')),
        body: const Center(child: Text('No project loaded')),
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: _buildAppBar(context, editor),
      body: Stack(
        children: [
          Column(
            children: [
              if (project.pages.length > 1) _buildPageTabs(context, editor, project),
              Expanded(child: CanvasWidget()),
            ],
          ),
          if (_showPalette)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: ElementPalette(onClose: () => setState(() => _showPalette = false)),
            ),
          if (editor.showPropertyPanel && !_showPalette && editor.selectedElement != null)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: PropertyPanel(),
            ),
        ],
      ),
      floatingActionButton: _showPalette
          ? null
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FloatingActionButton(
                  heroTag: 'add',
                  mini: true,
                  onPressed: () {
                    editor.deselectAll();
                    setState(() => _showPalette = true);
                  },
                  child: const Icon(Icons.add),
                ),
                const SizedBox(height: 12),
              ],
            ),
    );
  }

  AppBar _buildAppBar(BuildContext context, EditorProvider editor) {
    return AppBar(
      title: Text(
        editor.project?.name ?? 'Editor',
        style: const TextStyle(fontSize: 16),
      ),
      leading: BackButton(onPressed: () {
        _saveProject(context);
        Navigator.pop(context);
      }),
      actions: [
        IconButton(
          icon: Icon(
            Icons.undo_outlined,
            color: editor.canUndo ? null : Colors.white24,
          ),
          onPressed: editor.canUndo ? () { editor.undo(); } : null,
          tooltip: 'Undo',
        ),
        IconButton(
          icon: Icon(
            Icons.redo_outlined,
            color: editor.canRedo ? null : Colors.white24,
          ),
          onPressed: editor.canRedo ? () { editor.redo(); } : null,
          tooltip: 'Redo',
        ),
        IconButton(
          icon: const Icon(Icons.preview_outlined),
          onPressed: () => Navigator.pushNamed(context, '/preview'),
          tooltip: 'Preview',
        ),
        IconButton(
          icon: _exporting
              ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
              : const Icon(Icons.download_outlined),
          onPressed: _exporting ? null : () => _exportProject(context),
          tooltip: 'Export',
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildPageTabs(BuildContext context, EditorProvider editor, project) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          ...List.generate(project.pages.length, (i) {
            final selected = i == editor.currentPageIndex;
            return GestureDetector(
              onTap: () => editor.switchPage(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.fromLTRB(8, 6, 0, 6),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: selected ? const Color(0xFF7C3AED) : const Color(0xFF1A1A2E),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: selected ? const Color(0xFF7C3AED) : Colors.white.withOpacity(0.1),
                  ),
                ),
                child: Text(
                  project.pages[i].name,
                  style: TextStyle(
                    color: selected ? Colors.white : Colors.white54,
                    fontSize: 12,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ),
            );
          }),
          GestureDetector(
            onTap: () => _addPage(context, editor),
            child: Container(
              margin: const EdgeInsets.fromLTRB(8, 6, 8, 6),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withOpacity(0.1)),
              ),
              child: const Icon(Icons.add, size: 16, color: Colors.white54),
            ),
          ),
        ],
      ),
    );
  }

  void _addPage(BuildContext context, EditorProvider editor) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF12122A),
        title: const Text('Add Page'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'Page name (e.g. About)'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                editor.addPage(controller.text.trim());
              }
              Navigator.pop(ctx);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _saveProject(BuildContext context) {
    final project = context.read<EditorProvider>().project;
    if (project != null) {
      context.read<ProjectProvider>().updateProject(project);
    }
  }

  Future<void> _exportProject(BuildContext context) async {
    final project = context.read<EditorProvider>().project;
    if (project == null) return;
    setState(() => _exporting = true);
    try {
      final file = await ExportService().exportProject(project);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Exported: ${file.path.split('/').last}'),
          action: SnackBarAction(
            label: 'Share',
            onPressed: () async {
              // share_plus integration
            },
          ),
          backgroundColor: const Color(0xFF1A1A2E),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Export failed: $e')),
      );
    } finally {
      if (mounted) setState(() => _exporting = false);
    }
  }
}
