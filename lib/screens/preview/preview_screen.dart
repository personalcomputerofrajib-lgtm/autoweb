import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../providers/editor_provider.dart';
import '../../services/export_service.dart';

class PreviewScreen extends StatefulWidget {
  const PreviewScreen({super.key});

  @override
  State<PreviewScreen> createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen> {
  late WebViewController _controller;
  bool _loading = true;
  bool _generating = true;
  String? _htmlContent;
  bool _exporting = false;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0xFF0A0A1A))
      ..setNavigationDelegate(NavigationDelegate(
        onPageFinished: (_) => setState(() => _loading = false),
        onHttpError: (e) => print('WebView HTTP error: $e'),
      ));
    _generatePreview();
  }

  Future<void> _generatePreview() async {
    final editor = context.read<EditorProvider>();
    final project = editor.project;
    if (project == null || editor.currentPage == null) return;

    final exportService = ExportService();
    final file = await exportService.exportProject(project);
    // Load first page HTML
    final html = await _extractFirstPageHtml(file, project.name);
    setState(() {
      _htmlContent = html;
      _generating = false;
    });
    _controller.loadHtmlString(html);
  }

  Future<String> _extractFirstPageHtml(file, String name) async {
    // Re-generate the HTML for the current page directly
    final editor = context.read<EditorProvider>();
    final project = editor.project!;
    final service = ExportService();
    // Access via reflection not possible; regenerate
    final zipFile = await service.exportProject(project);
    // Return inline HTML string  
    return _buildInlineHtml(project: project.toJson());
  }

  String _buildInlineHtml({required Map project}) {
    // Quick inline fallback — the actual HTML is in the ZIP
    final name = project['name'] ?? 'Site';
    return '''<!DOCTYPE html>
<html>
<head>
<meta name="viewport" content="width=device-width,initial-scale=1">
<style>
body { margin:0; padding:0; font-family:Inter,sans-serif; background:#0A0A1A; color:#fff; display:flex;align-items:center;justify-content:center;min-height:100vh;flex-direction:column;}
.badge { background:#7C3AED; color:#fff; padding:8px 20px; border-radius:100px; font-size:13px; font-weight:600; margin-bottom:16px;}
h1 { font-size:24px; margin:0 0 8px; }
p { color:#888; font-size:14px; }
</style>
</head>
<body>
<span class="badge">✓ Preview</span>
<h1>$name</h1>
<p>Export the ZIP to view your full website</p>
</body>
</html>''';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Preview'),
        actions: [
          IconButton(
            icon: const Icon(Icons.phone_android_outlined),
            onPressed: () {},
            tooltip: 'Mobile view',
          ),
          IconButton(
            icon: _exporting
                ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                : const Icon(Icons.share_outlined),
            onPressed: _exporting ? null : _exportAndShare,
            tooltip: 'Export & Share',
          ),
        ],
      ),
      body: Stack(
        children: [
          if (!_generating) WebViewWidget(controller: _controller),
          if (_generating || _loading)
            Container(
              color: const Color(0xFF0A0A1A),
              child: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(color: Color(0xFF7C3AED)),
                    SizedBox(height: 16),
                    Text('Generating preview...', style: TextStyle(color: Colors.white54)),
                  ],
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
        color: const Color(0xFF12122A),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _exporting ? null : _exportAndShare,
            icon: const Icon(Icons.download_outlined),
            label: const Text('Export Full Website as ZIP'),
          ),
        ),
      ),
    );
  }

  Future<void> _exportAndShare() async {
    final project = context.read<EditorProvider>().project;
    if (project == null) return;
    setState(() => _exporting = true);
    try {
      final file = await ExportService().exportProject(project);
      await Share.shareXFiles([XFile(file.path)], text: 'My website: ${project.name}');
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Export failed: $e')));
    } finally {
      if (mounted) setState(() => _exporting = false);
    }
  }
}
