import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:share_plus/share_plus.dart';
import '../../providers/editor_provider.dart';
import '../../services/export_service.dart';
import '../../models/page_element.dart';
import '../../models/element_type.dart';

class PreviewScreen extends StatefulWidget {
  const PreviewScreen({super.key});

  @override
  State<PreviewScreen> createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen> {
  late WebViewController _controller;
  bool _loading = true;
  bool _exporting = false;
  int _viewMode = 0; // 0=mobile, 1=tablet, 2=desktop

  final _viewModes = [
    {'label': 'Mobile', 'icon': Icons.phone_android, 'width': 390},
    {'label': 'Tablet', 'icon': Icons.tablet_mac, 'width': 768},
    {'label': 'Desktop', 'icon': Icons.laptop_mac, 'width': 1280},
  ];

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0xFF0A0A1A))
      ..setNavigationDelegate(NavigationDelegate(
        onPageFinished: (_) => setState(() => _loading = false),
      ));
    _generatePreview();
  }

  Future<void> _generatePreview() async {
    final editor = context.read<EditorProvider>();
    final project = editor.project;
    if (project == null) return;

    final html = _buildFullHtml(project, editor);
    _controller.loadHtmlString(html);
  }

  String _buildFullHtml(project, EditorProvider editor) {
    final siteName = project.globalSettings['siteName'] ?? project.name;
    final primaryColor = project.globalSettings['primaryColor'] ?? '#7C3AED';
    final currentPage = editor.currentPage;
    if (currentPage == null) return '<html><body style="background:#0A0A1A;color:#fff;display:flex;align-items:center;justify-content:center;height:100vh;"><h2>No page to preview</h2></body></html>';

    final elementsHtml = currentPage.elements.map((el) => _renderElementHtml(el, primaryColor)).join('\n');

    return '''<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>$siteName - Preview</title>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
  <style>
    :root { --primary: $primaryColor; }
    *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
    body { font-family: 'Inter', sans-serif; background: ${currentPage.backgroundColor}; min-height: 100vh; }
    img { max-width: 100%; }
    a { text-decoration: none; }
    .navbar { display:flex; align-items:center; padding:0 20px; height:60px; position:sticky; top:0; z-index:1000; justify-content:space-between; }
    .nav-brand { font-size:18px; font-weight:700; }
    .nav-links { display:flex; gap:20px; }
    .nav-links a { font-size:14px; font-weight:500; opacity:0.85; }
    .hero { min-height:300px; display:flex; align-items:center; padding:40px 20px; }
    .hero-inner { max-width:600px; }
    .hero h1 { font-size:clamp(24px,5vw,44px); font-weight:800; line-height:1.25; margin-bottom:16px; }
    .hero p { font-size:16px; line-height:1.7; margin-bottom:24px; }
    .hero-btn { display:inline-block; color:#fff; padding:14px 32px; border-radius:14px; font-weight:600; }
    .product-card, .feature-card, .testimonial, .pricing-card, .post-card, .team-card, .faq-item { transition:transform .2s; }
    .product-card:hover, .pricing-card:hover { transform:translateY(-4px); }
    .countdown-unit { display:flex; flex-direction:column; align-items:center; }
    .countdown-unit .value { width:48px; height:48px; display:flex; align-items:center; justify-content:center; border-radius:10px; font-weight:800; font-size:20px; }
    .countdown-unit .lbl { font-size:10px; color:#888; margin-top:4px; }
    html { scroll-behavior:smooth; }
  </style>
</head>
<body>
$elementsHtml
<script>
function toggleFaq(id) {
  const c = document.getElementById('faq_' + id);
  const i = document.getElementById('icon_' + id);
  if(c){const o=c.style.display==='block';c.style.display=o?'none':'block';if(i)i.textContent=o?'▶':'▼';}
}
function handleFormSubmit(e){e.preventDefault();alert('Form submitted successfully!');e.target.reset();}
</script>
</body>
</html>''';
  }

  String _esc(String? t) => (t ?? '').replaceAll('&', '&amp;').replaceAll('<', '&lt;').replaceAll('>', '&gt;').replaceAll('"', '&quot;');

  String _renderElementHtml(PageElement el, String primaryColor) {
    final p = el.properties;
    switch (el.elementType) {
      case ElementType.navbar:
        final items = (p['menuItems'] as List?)?.cast<String>() ?? [];
        final links = items.map((i) => '<a href="#" style="color:${p['textColor'] ?? '#fff'};font-size:14px;">${_esc(i)}</a>').join('');
        return '<nav class="navbar" style="background:${p['backgroundColor'] ?? '#0A0A1A'};"><div class="nav-brand" style="color:${p['textColor'] ?? '#fff'};">${_esc(p['brandName'] ?? '')}</div><div class="nav-links">$links</div></nav>';
      case ElementType.hero:
        final bg = (p['backgroundImageUrl'] as String?)?.isNotEmpty == true
            ? 'background-image:url(${p['backgroundImageUrl']});background-size:cover;' : 'background:${p['backgroundColor'] ?? '#1A0A3A'};';
        final btn = p['buttonLabel'] != null ? '<a href="#" class="hero-btn" style="background:$primaryColor;">${_esc(p['buttonLabel'])}</a>' : '';
        return '<section class="hero" style="$bg"><div class="hero-inner"><h1 style="color:${p['textColor'] ?? '#fff'};">${_esc(p['title'] ?? '')}</h1><p style="color:${p['textColor'] ?? '#fff'};opacity:0.85;">${_esc(p['subtitle'] ?? '')}</p>$btn</div></section>';
      case ElementType.heading:
        return '<h2 style="color:${p['color'] ?? '#fff'};font-size:${p['fontSize'] ?? 22}px;font-weight:${p['fontWeight'] == 'bold' ? '700' : '400'};padding:8px 20px;text-align:${p['textAlign'] ?? 'left'};">${_esc(p['content'] ?? '')}</h2>';
      case ElementType.text:
        return '<p style="color:${p['color'] ?? '#fff'};font-size:${p['fontSize'] ?? 16}px;padding:4px 20px;text-align:${p['textAlign'] ?? 'left'};">${_esc(p['content'] ?? '')}</p>';
      case ElementType.button:
        return '<a href="#" style="display:block;margin:12px auto;background:${p['backgroundColor'] ?? primaryColor};color:${p['textColor'] ?? '#fff'};border-radius:${p['borderRadius'] ?? 14}px;padding:14px 28px;text-align:center;font-weight:600;font-size:${p['fontSize'] ?? 15}px;">${_esc(p['label'] ?? 'Button')}</a>';
      case ElementType.image:
        final src = (p['imageUrl'] as String?)?.isNotEmpty == true ? p['imageUrl'] : null;
        if (src != null) return '<img src="$src" alt="${_esc(p['altText'] ?? '')}" style="border-radius:${p['borderRadius'] ?? 12}px;width:100%;object-fit:cover;display:block;margin:8px 0;">';
        return '<div style="background:#1E1E3A;height:200px;border-radius:${p['borderRadius'] ?? 12}px;display:flex;align-items:center;justify-content:center;color:#444;margin:8px 16px;">Image placeholder</div>';
      case ElementType.productCard:
        return '<div style="background:${p['backgroundColor'] ?? '#12122A'};border-radius:${p['borderRadius'] ?? 16}px;margin:8px;overflow:hidden;"><div style="height:160px;background:#1E1E3A;display:flex;align-items:center;justify-content:center;font-size:32px;">🛍️</div><div style="padding:12px;"><h3 style="color:#fff;font-size:15px;margin:0 0 4px;">${_esc(p['productName'] ?? '')}</h3><div style="display:flex;gap:8px;"><span style="color:#fff;font-weight:700;">${_esc(p['price'] ?? '')}</span><span style="color:#666;text-decoration:line-through;font-size:12px;">${_esc(p['originalPrice'] ?? '')}</span></div><button style="background:$primaryColor;color:#fff;border:none;border-radius:10px;padding:10px;width:100%;margin-top:10px;cursor:pointer;font-weight:600;">Add to Cart</button></div></div>';
      case ElementType.featureCard:
        return '<div style="background:${p['backgroundColor'] ?? '#12122A'};border-radius:${p['borderRadius'] ?? 16}px;padding:20px;margin:8px 16px;"><div style="font-size:28px;margin-bottom:8px;">⭐</div><h3 style="color:#fff;margin:0 0 6px;">${_esc(p['title'] ?? '')}</h3><p style="color:#aaa;font-size:14px;margin:0;">${_esc(p['description'] ?? '')}</p></div>';
      case ElementType.testimonial:
        return '<div style="background:${p['backgroundColor'] ?? '#12122A'};border-radius:16px;padding:20px;margin:8px 16px;border-left:3px solid ${p['accentColor'] ?? primaryColor};"><p style="color:#ddd;font-style:italic;margin:0 0 12px;">${_esc(p['quote'] ?? '')}</p><strong style="color:#fff;">${_esc(p['authorName'] ?? '')}</strong> <span style="color:#888;font-size:12px;">${_esc(p['authorRole'] ?? '')}</span></div>';
      case ElementType.contactForm:
        final fields = (p['fields'] as List?)?.cast<String>() ?? ['name', 'email', 'message'];
        final inputs = fields.map((f) => f == 'message'
            ? '<textarea placeholder="${f[0].toUpperCase()}${f.substring(1)}" style="width:100%;padding:12px;border-radius:10px;border:1px solid #333;background:#1A1A2E;color:#fff;resize:vertical;min-height:100px;box-sizing:border-box;font-family:Inter,sans-serif;"></textarea>'
            : '<input type="${f == 'email' ? 'email' : 'text'}" placeholder="${f[0].toUpperCase()}${f.substring(1)}" style="width:100%;padding:12px;border-radius:10px;border:1px solid #333;background:#1A1A2E;color:#fff;box-sizing:border-box;font-family:Inter,sans-serif;">').join('<br><br>');
        return '<div style="background:${p['backgroundColor'] ?? '#12122A'};border-radius:16px;padding:24px;margin:8px 16px;"><form onsubmit="handleFormSubmit(event)">$inputs<br><br><button type="submit" style="background:${p['accentColor'] ?? primaryColor};color:#fff;border:none;border-radius:12px;padding:14px;width:100%;font-weight:600;cursor:pointer;font-size:15px;">${_esc(p['submitLabel'] ?? 'Submit')}</button></form></div>';
      case ElementType.footer:
        return '<footer style="background:${p['backgroundColor'] ?? '#06060F'};padding:30px 20px;text-align:center;"><div style="color:${p['textColor'] ?? '#888'};font-weight:700;font-size:16px;margin-bottom:6px;">${_esc(p['brandName'] ?? '')}</div><div style="color:${p['textColor'] ?? '#888'};font-size:13px;">${_esc(p['tagline'] ?? '')}</div><p style="color:${p['textColor'] ?? '#888'};font-size:11px;margin-top:16px;">© 2025 ${_esc(p['brandName'] ?? '')}. Built with AUTOWEB.</p></footer>';
      case ElementType.pricingCard:
        final features = (p['features'] as List?)?.cast<String>() ?? [];
        final fl = features.map((f) => '<li>✓ ${_esc(f)}</li>').join('');
        return '<div style="background:${p['backgroundColor'] ?? '#12122A'};border-radius:20px;padding:24px;margin:8px;"><h3 style="color:#fff;margin:0 0 8px;">${_esc(p['planName'] ?? '')}</h3><div style="font-size:32px;font-weight:700;color:$primaryColor;">${_esc(p['price'] ?? '')} <span style="font-size:14px;opacity:.7;">${_esc(p['period'] ?? '')}</span></div><ul style="color:#ccc;list-style:none;padding:0;margin:16px 0;">$fl</ul></div>';
      case ElementType.blogPostCard:
        return '<article style="background:${p['backgroundColor'] ?? '#1A1A1A'};border-radius:16px;padding:16px;margin:8px 16px;"><span style="color:$primaryColor;font-size:12px;font-weight:600;">${_esc(p['category'] ?? '')} · ${_esc(p['readTime'] ?? '')}</span><h2 style="color:#fff;font-size:17px;margin:8px 0;">${_esc(p['title'] ?? '')}</h2><p style="color:#aaa;font-size:13px;">${_esc(p['excerpt'] ?? '')}</p></article>';
      case ElementType.teamCard:
        return '<div style="background:${p['backgroundColor'] ?? '#12122A'};border-radius:16px;padding:20px;display:flex;align-items:center;gap:16px;margin:8px 16px;"><div style="width:60px;height:60px;border-radius:50%;background:#1E1E3A;display:flex;align-items:center;justify-content:center;font-size:24px;">👤</div><div><h3 style="color:#fff;margin:0;font-size:16px;">${_esc(p['name'] ?? '')}</h3><div style="color:$primaryColor;font-size:12px;font-weight:600;">${_esc(p['role'] ?? '')}</div><p style="color:#aaa;font-size:13px;margin:6px 0 0;">${_esc(p['bio'] ?? '')}</p></div></div>';
      case ElementType.faqItem:
        final fid = el.id.replaceAll('-', '');
        return '<div style="background:${p['backgroundColor'] ?? '#12122A'};border-radius:12px;margin:8px 16px;overflow:hidden;"><button onclick="toggleFaq(\'$fid\')" style="width:100%;text-align:left;background:none;border:none;padding:16px;color:#fff;font-size:15px;font-weight:600;cursor:pointer;display:flex;justify-content:space-between;">${_esc(p['question'] ?? '')} <span id="icon_$fid">▶</span></button><div id="faq_$fid" style="display:none;padding:0 16px 16px;color:#aaa;font-size:14px;">${_esc(p['answer'] ?? '')}</div></div>';
      case ElementType.divider:
        return '<hr style="border-color:${p['color'] ?? '#2A2A4A'};margin:8px 20px;">';
      case ElementType.spacer:
        return '<div style="height:${p['height'] ?? 40}px;"></div>';
      case ElementType.section:
        return '<section style="background:${p['backgroundColor'] ?? '#0A0A1A'};padding:40px 20px;"></section>';
      case ElementType.cartButton:
        return '<button style="background:transparent;border:1px solid rgba(255,255,255,0.2);border-radius:10px;color:#fff;padding:8px 12px;cursor:pointer;">🛒 <span>0</span></button>';
      case ElementType.socialLinks:
        final platforms = (p['platforms'] as List?)?.cast<String>() ?? [];
        final icons = {'instagram': '📸', 'twitter': '🐦', 'facebook': '📘', 'linkedin': '💼', 'youtube': '▶️'};
        final links = platforms.map((pl) => '<a href="#" style="color:${p['color'] ?? primaryColor};font-size:24px;">${icons[pl] ?? '🔗'}</a>').join('  ');
        return '<div style="padding:12px 20px;display:flex;gap:16px;justify-content:center;">$links</div>';
      case ElementType.video:
        final videoUrl = p['videoUrl'] ?? '';
        if (videoUrl.toString().isNotEmpty) return '<div style="margin:8px 16px;border-radius:16px;overflow:hidden;"><iframe src="$videoUrl" style="width:100%;height:300px;border:none;" allowfullscreen></iframe></div>';
        return '<div style="background:#12122A;height:200px;border-radius:16px;display:flex;align-items:center;justify-content:center;margin:8px 16px;font-size:48px;">▶️</div>';
      case ElementType.map:
        final address = _esc(p['address']?.toString() ?? '');
        return '<div style="border-radius:16px;overflow:hidden;margin:8px 16px;"><iframe src="https://maps.google.com/maps?q=${Uri.encodeComponent(address)}&output=embed" style="width:100%;height:${p['height'] ?? 200}px;border:none;" loading="lazy"></iframe></div>';
      case ElementType.countdown:
        return '<div style="background:${p['backgroundColor'] ?? '#12122A'};border-radius:16px;padding:24px;text-align:center;margin:8px 16px;"><h3 style="color:${p['textColor'] ?? '#fff'};margin:0 0 6px;">${_esc(p['title']?.toString() ?? 'Coming Soon')}</h3><p style="color:${p['textColor'] ?? '#fff'};opacity:.6;font-size:14px;">${_esc(p['subtitle']?.toString() ?? '')}</p><div style="display:flex;justify-content:center;gap:16px;margin-top:16px;">${['Days', 'Hours', 'Min', 'Sec'].map((u) => '<div class="countdown-unit"><div class="value" style="background:${p['accentColor'] ?? primaryColor}22;color:${p['accentColor'] ?? primaryColor};">00</div><div class="lbl">$u</div></div>').join('')}</div></div>';
      case ElementType.gallery:
        final cols = p['columns'] ?? 2;
        return '<div style="display:grid;grid-template-columns:repeat($cols,1fr);gap:${p['gap'] ?? 8}px;margin:8px 16px;">${List.generate(4, (_) => '<div style="background:#1E1E3A;height:150px;border-radius:${p['borderRadius'] ?? 12}px;display:flex;align-items:center;justify-content:center;font-size:24px;">🖼️</div>').join('')}</div>';
      case ElementType.accordion:
        final items = (p['items'] as List?) ?? [];
        final acc = items.map((item) {
          final m = item as Map<String, dynamic>? ?? {};
          final aid = el.id.replaceAll('-', '') + items.indexOf(item).toString();
          return '<div style="border-bottom:1px solid rgba(255,255,255,0.06);"><button onclick="toggleFaq(\'$aid\')" style="width:100%;text-align:left;background:none;border:none;padding:14px;color:${p['textColor'] ?? '#fff'};font-size:15px;font-weight:600;cursor:pointer;display:flex;justify-content:space-between;">${_esc(m['title']?.toString() ?? '')} <span id="icon_$aid">▶</span></button><div id="faq_$aid" style="display:none;padding:0 14px 14px;color:#aaa;font-size:14px;">${_esc(m['content']?.toString() ?? '')}</div></div>';
        }).join('');
        return '<div style="background:${p['backgroundColor'] ?? '#12122A'};border-radius:${p['borderRadius'] ?? 12}px;overflow:hidden;margin:8px 16px;">$acc</div>';
      case ElementType.statsCounter:
        return '<div style="background:${p['backgroundColor'] ?? '#12122A'};border-radius:${p['borderRadius'] ?? 16}px;padding:24px;text-align:center;margin:8px;"><div style="color:${p['valueColor'] ?? primaryColor};font-size:36px;font-weight:900;">${_esc(p['value']?.toString() ?? '0')}</div><div style="color:${p['labelColor'] ?? '#aaa'};font-size:14px;margin-top:6px;">${_esc(p['label']?.toString() ?? '')}</div></div>';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Preview'),
        actions: [
          // Responsive view toggle
          ...List.generate(_viewModes.length, (i) {
            final mode = _viewModes[i];
            final selected = _viewMode == i;
            return IconButton(
              icon: Icon(mode['icon'] as IconData, size: 20,
                color: selected ? const Color(0xFF7C3AED) : Colors.white38),
              onPressed: () => setState(() { _viewMode = i; _loading = true; _generatePreview(); }),
              tooltip: mode['label'] as String,
            );
          }),
          const SizedBox(width: 4),
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
          WebViewWidget(controller: _controller),
          if (_loading)
            Container(
              color: const Color(0xFF0A0A1A),
              child: const Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
                CircularProgressIndicator(color: Color(0xFF7C3AED)),
                SizedBox(height: 16),
                Text('Generating preview...', style: TextStyle(color: Colors.white54)),
              ])),
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
            label: const Text('Export & Share Website'),
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
