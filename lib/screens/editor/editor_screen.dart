import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
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
  Timer? _autoSaveTimer;

  @override
  void initState() {
    super.initState();
    _panelController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    // Auto-save every 30 seconds
    _autoSaveTimer = Timer.periodic(const Duration(seconds: 30), (_) => _saveProject(context));
  }

  @override
  void dispose() {
    _panelController.dispose();
    _autoSaveTimer?.cancel();
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
              _buildPageTabs(context, editor, project),
              Expanded(child: CanvasWidget()),
            ],
          ),
          if (_showPalette)
            Positioned(
              bottom: 0, left: 0, right: 0,
              child: ElementPalette(onClose: () => setState(() => _showPalette = false)),
            ),
          if (editor.showPropertyPanel && !_showPalette && editor.selectedElement != null)
            Positioned(
              bottom: 0, left: 0, right: 0,
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
      title: Text(editor.project?.name ?? 'Editor', style: const TextStyle(fontSize: 16)),
      leading: BackButton(onPressed: () {
        _saveProject(context);
        Navigator.pop(context);
      }),
      actions: [
        IconButton(
          icon: Icon(Icons.undo_outlined, color: editor.canUndo ? null : Colors.white24),
          onPressed: editor.canUndo ? () => editor.undo() : null,
          tooltip: 'Undo',
        ),
        IconButton(
          icon: Icon(Icons.redo_outlined, color: editor.canRedo ? null : Colors.white24),
          onPressed: editor.canRedo ? () => editor.redo() : null,
          tooltip: 'Redo',
        ),
        IconButton(
          icon: const Icon(Icons.settings_outlined, size: 20),
          onPressed: () => _showSettings(context, editor),
          tooltip: 'Site Settings',
        ),
        IconButton(
          icon: const Icon(Icons.preview_outlined),
          onPressed: () {
            _saveProject(context);
            Navigator.pushNamed(context, '/preview');
          },
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
              onLongPress: () => _showPageOptions(context, editor, i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.fromLTRB(8, 6, 0, 6),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: selected ? const Color(0xFF7C3AED) : const Color(0xFF1A1A2E),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: selected ? const Color(0xFF7C3AED) : Colors.white.withOpacity(0.1)),
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

  void _showPageOptions(BuildContext context, EditorProvider editor, int pageIndex) {
    final page = editor.project!.pages[pageIndex];
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF12122A),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text('Page: ${page.name}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16)),
          const SizedBox(height: 16),
          ListTile(
            leading: const Icon(Icons.edit_outlined, color: Colors.white70),
            title: const Text('Rename', style: TextStyle(color: Colors.white)),
            onTap: () { Navigator.pop(ctx); _renamePage(context, editor, pageIndex); },
          ),
          ListTile(
            leading: const Icon(Icons.copy_outlined, color: Colors.white70),
            title: const Text('Duplicate Page', style: TextStyle(color: Colors.white)),
            onTap: () { Navigator.pop(ctx); editor.duplicatePage(pageIndex); },
          ),
          if (editor.project!.pages.length > 1)
            ListTile(
              leading: const Icon(Icons.delete_outline, color: Colors.redAccent),
              title: const Text('Delete Page', style: TextStyle(color: Colors.redAccent)),
              onTap: () { Navigator.pop(ctx); editor.deletePage(pageIndex); },
            ),
        ]),
      ),
    );
  }

  void _renamePage(BuildContext context, EditorProvider editor, int pageIndex) {
    final controller = TextEditingController(text: editor.project!.pages[pageIndex].name);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF12122A),
        title: const Text('Rename Page'),
        content: TextField(controller: controller, autofocus: true, decoration: const InputDecoration(hintText: 'Page name')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) editor.renamePage(pageIndex, controller.text.trim());
              Navigator.pop(ctx);
            },
            child: const Text('Rename'),
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
        content: TextField(controller: controller, autofocus: true, decoration: const InputDecoration(hintText: 'Page name (e.g. About)')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) editor.addPage(controller.text.trim());
              Navigator.pop(ctx);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showSettings(BuildContext context, EditorProvider editor) {
    final settings = editor.project!.globalSettings;
    final colors = ['#7C3AED', '#3B82F6', '#06B6D4', '#10B981', '#F59E0B', '#EF4444', '#D97706', '#EC4899', '#8B5CF6', '#14B8A6'];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF12122A),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) => Padding(
          padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(ctx).viewInsets.bottom + 20),
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Site Settings', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 18)),
            const SizedBox(height: 20),
            const Text('Brand Color', style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Wrap(spacing: 8, runSpacing: 8, children: colors.map((c) {
              final selected = settings['primaryColor'] == c;
              return GestureDetector(
                onTap: () { setSheetState(() => settings['primaryColor'] = c); editor.updateGlobalSetting('primaryColor', c); },
                child: Container(
                  width: 36, height: 36,
                  decoration: BoxDecoration(
                    color: Color(int.parse(c.replaceAll('#', '0xFF'))),
                    borderRadius: BorderRadius.circular(10),
                    border: selected ? Border.all(color: Colors.white, width: 2.5) : null,
                  ),
                  child: selected ? const Icon(Icons.check, color: Colors.white, size: 16) : null,
                ),
              );
            }).toList()),
            const SizedBox(height: 20),
            const Text('Font Family', style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Wrap(spacing: 8, runSpacing: 8, children: ['Inter', 'Roboto', 'Poppins', 'Outfit', 'Montserrat'].map((f) {
              final selected = settings['fontFamily'] == f;
              return GestureDetector(
                onTap: () { setSheetState(() => settings['fontFamily'] = f); editor.updateGlobalSetting('fontFamily', f); },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: selected ? const Color(0xFF7C3AED).withOpacity(0.2) : Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: selected ? const Color(0xFF7C3AED) : Colors.white.withOpacity(0.1)),
                  ),
                  child: Text(f, style: TextStyle(color: selected ? Colors.white : Colors.white54, fontSize: 13, fontWeight: FontWeight.w500)),
                ),
              );
            }).toList()),
            const SizedBox(height: 20),
            const Text('Page Background', style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Wrap(spacing: 8, runSpacing: 8, children: ['#0A0A1A', '#050510', '#0D0808', '#050F0A', '#0D0D0D', '#1A1A2E', '#000000'].map((c) {
              final currentBg = editor.currentPage?.backgroundColor ?? '#0A0A1A';
              final selected = currentBg == c;
              return GestureDetector(
                onTap: () { setSheetState(() {}); editor.updatePageBackground(c); },
                child: Container(
                  width: 36, height: 36,
                  decoration: BoxDecoration(
                    color: Color(int.parse(c.replaceAll('#', '0xFF'))),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: selected ? Colors.white : Colors.white.withOpacity(0.15), width: selected ? 2.5 : 1),
                  ),
                  child: selected ? const Icon(Icons.check, color: Colors.white, size: 16) : null,
                ),
              );
            }).toList()),
            const SizedBox(height: 12),
          ]),
        ),
      ),
    );
  }

  void _saveProject(BuildContext context) {
    final project = context.read<EditorProvider>().project;
    if (project != null) context.read<ProjectProvider>().updateProject(project);
  }

  Future<void> _exportProject(BuildContext context) async {
    final project = context.read<EditorProvider>().project;
    if (project == null) return;
    setState(() => _exporting = true);
    try {
      final file = await ExportService().exportProject(project);
      if (!mounted) return;
      await Share.shareXFiles([XFile(file.path)], text: 'My website: ${project.name}');
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Export failed: $e')));
    } finally {
      if (mounted) setState(() => _exporting = false);
    }
  }
}
