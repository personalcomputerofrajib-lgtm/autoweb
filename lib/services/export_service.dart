import 'dart:io';
import 'dart:typed_data';
import 'package:archive/archive.dart';
import 'package:path_provider/path_provider.dart';
import '../models/website_project.dart';
import '../models/page_element.dart';
import '../models/element_type.dart';

class ExportService {
  Future<File> exportProject(WebsiteProject project) async {
    final dir = await getTemporaryDirectory();
    final archive = Archive();

    // Generate each page as HTML
    for (int i = 0; i < project.pages.length; i++) {
      final page = project.pages[i];
      final fileName = i == 0 ? 'index.html' : '${page.name.toLowerCase().replaceAll(' ', '_')}.html';
      final html = _generatePageHtml(page, project);
      archive.addFile(ArchiveFile(fileName, html.length, Uint8List.fromList(html.codeUnits)));
    }

    // Global CSS
    final css = _generateGlobalCss(project);
    archive.addFile(ArchiveFile('style.css', css.length, Uint8List.fromList(css.codeUnits)));

    // Global JS
    final js = _generateGlobalJs(project);
    archive.addFile(ArchiveFile('app.js', js.length, Uint8List.fromList(js.codeUnits)));

    // Encode and write zip
    final zipData = ZipEncoder().encode(archive)!;
    final zipFile = File('${dir.path}/${project.name.replaceAll(' ', '_')}_site.zip');
    await zipFile.writeAsBytes(zipData);
    return zipFile;
  }

  String _generatePageHtml(SitePage page, WebsiteProject project) {
    final siteName = project.globalSettings['siteName'] ?? project.name;
    final primaryColor = project.globalSettings['primaryColor'] ?? '#7C3AED';
    final elements = page.elements.map((el) => _renderElement(el, project)).join('\n');

    return '''<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>${_escHtml(siteName)} - ${_escHtml(page.name)}</title>
  <meta name="description" content="$siteName - Built with SiteBuilder">
  <link rel="stylesheet" href="style.css">
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
  <style>
    :root {
      --primary: $primaryColor;
      --bg: ${page.backgroundColor};
    }
    body { background: var(--bg); }
  </style>
</head>
<body>
$elements
<script src="app.js"></script>
</body>
</html>''';
  }

  String _renderElement(PageElement el, WebsiteProject project) {
    final p = el.properties;
    switch (el.elementType) {
      case ElementType.navbar:
        return _renderNavbar(el, project);
      case ElementType.hero:
        return _renderHero(el);
      case ElementType.text:
        return _renderText(el, tag: 'p');
      case ElementType.heading:
        return _renderText(el, tag: 'h2');
      case ElementType.button:
        return _renderButton(el);
      case ElementType.image:
        return _renderImage(el);
      case ElementType.productCard:
        return _renderProductCard(el);
      case ElementType.featureCard:
        return _renderFeatureCard(el);
      case ElementType.testimonial:
        return _renderTestimonial(el);
      case ElementType.contactForm:
        return _renderContactForm(el);
      case ElementType.footer:
        return _renderFooter(el);
      case ElementType.pricingCard:
        return _renderPricingCard(el);
      case ElementType.blogPostCard:
        return _renderBlogPostCard(el);
      case ElementType.teamCard:
        return _renderTeamCard(el);
      case ElementType.faqItem:
        return _renderFaqItem(el);
      case ElementType.divider:
        return '<hr style="border-color:${p['color'] ?? '#2A2A4A'};margin:8px 20px;">';
      case ElementType.spacer:
        return '<div style="height:${p['height'] ?? 40}px;"></div>';
      case ElementType.section:
        return '<section style="background:${p['backgroundColor'] ?? '#0A0A1A'};padding:${p['paddingVertical'] ?? 40}px ${p['paddingHorizontal'] ?? 20}px;"></section>';
      case ElementType.cartButton:
        return '<button class="cart-btn" onclick="toggleCart()">🛒 <span class="cart-count">0</span></button>';
      case ElementType.socialLinks:
        return _renderSocialLinks(el);
      case ElementType.video:
        final vp = el.properties;
        final videoUrl = vp['videoUrl'] ?? '';
        final caption = vp['caption'] ?? '';
        if (videoUrl.toString().isNotEmpty) {
          return '<div style="background:${vp['backgroundColor'] ?? '#12122A'};border-radius:${vp['borderRadius'] ?? 16}px;overflow:hidden;margin:8px 16px;"><iframe src="$videoUrl" style="width:100%;height:300px;border:none;" allowfullscreen></iframe>${caption.toString().isNotEmpty ? '<p style="color:#aaa;padding:10px;font-size:14px;">$caption</p>' : ''}</div>';
        }
        return '<div style="background:${vp['backgroundColor'] ?? '#12122A'};border-radius:${vp['borderRadius'] ?? 16}px;height:200px;display:flex;align-items:center;justify-content:center;margin:8px 16px;"><span style="font-size:48px;">▶️</span></div>';
      case ElementType.map:
        final mp = el.properties;
        final address = _escHtml(mp['address']?.toString() ?? '');
        return '<div style="background:${mp['backgroundColor'] ?? '#12122A'};border-radius:${mp['borderRadius'] ?? 16}px;overflow:hidden;margin:8px 16px;"><iframe src="https://maps.google.com/maps?q=${Uri.encodeComponent(address)}&output=embed" style="width:100%;height:${mp['height'] ?? 200}px;border:none;" loading="lazy"></iframe></div>';
      case ElementType.countdown:
        final cp = el.properties;
        final cid = el.id.replaceAll('-', '');
        return '<div id="cd_$cid" style="background:${cp['backgroundColor'] ?? '#12122A'};border-radius:16px;padding:24px;text-align:center;margin:8px 16px;"><h3 style="color:${cp['textColor'] ?? '#fff'};margin:0 0 6px;">${_escHtml(cp['title']?.toString() ?? 'Coming Soon')}</h3><p style="color:${cp['textColor'] ?? '#fff'};opacity:.6;font-size:14px;">${_escHtml(cp['subtitle']?.toString() ?? '')}</p><div class="countdown" data-target="${cp['targetDate'] ?? ''}" style="display:flex;justify-content:center;gap:16px;margin-top:16px;"></div></div>';
      case ElementType.gallery:
        final gp = el.properties;
        final images = (gp['images'] as List?)?.cast<String>() ?? [];
        final cols = gp['columns'] ?? 2;
        final gap = gp['gap'] ?? 8;
        final br = gp['borderRadius'] ?? 12;
        if (images.isEmpty) {
          return '<div style="display:grid;grid-template-columns:repeat($cols,1fr);gap:${gap}px;margin:8px 16px;">${List.generate(4, (_) => '<div style="background:#1E1E3A;height:150px;border-radius:${br}px;display:flex;align-items:center;justify-content:center;font-size:24px;">🖼️</div>').join('')}</div>';
        }
        final imgHtml = images.map((i) => '<img src="$i" style="width:100%;height:150px;object-fit:cover;border-radius:${br}px;">').join('');
        return '<div style="display:grid;grid-template-columns:repeat($cols,1fr);gap:${gap}px;margin:8px 16px;">$imgHtml</div>';
      case ElementType.accordion:
        final ap = el.properties;
        final items = (ap['items'] as List?) ?? [];
        final accHtml = items.map((item) {
          final m = item as Map<String, dynamic>? ?? {};
          final aid = el.id.replaceAll('-', '') + items.indexOf(item).toString();
          return '<div style="border-bottom:1px solid rgba(255,255,255,0.06);"><button onclick="toggleFaq(\'$aid\')" style="width:100%;text-align:left;background:none;border:none;padding:14px;color:${ap['textColor'] ?? '#fff'};font-size:15px;font-weight:600;cursor:pointer;display:flex;justify-content:space-between;">${_escHtml(m['title']?.toString() ?? '')} <span id="icon_$aid">▶</span></button><div id="faq_$aid" style="display:none;padding:0 14px 14px;color:#aaa;font-size:14px;">${_escHtml(m['content']?.toString() ?? '')}</div></div>';
        }).join('');
        return '<div style="background:${ap['backgroundColor'] ?? '#12122A'};border-radius:${ap['borderRadius'] ?? 12}px;overflow:hidden;margin:8px 16px;">$accHtml</div>';
      case ElementType.statsCounter:
        final sp = el.properties;
        return '<div style="background:${sp['backgroundColor'] ?? '#12122A'};border-radius:${sp['borderRadius'] ?? 16}px;padding:24px;text-align:center;margin:8px;"><div style="color:${sp['valueColor'] ?? 'var(--primary)'};font-size:36px;font-weight:900;">${_escHtml(sp['value']?.toString() ?? '0')}</div><div style="color:${sp['labelColor'] ?? '#aaa'};font-size:14px;margin-top:6px;">${_escHtml(sp['label']?.toString() ?? '')}</div></div>';
    }
  }

  String _renderNavbar(PageElement el, WebsiteProject project) {
    final p = el.properties;
    final brand = _escHtml(p['brandName'] ?? 'Brand');
    final bg = p['backgroundColor'] ?? '#0A0A1A';
    final textColor = p['textColor'] ?? '#FFFFFF';
    final showCart = p['showCart'] == true;
    final items = (p['menuItems'] as List?)?.cast<String>() ?? [];
    final links = items.map((item) {
      final href = item == 'Home' ? 'index.html' : '${item.toLowerCase().replaceAll(' ', '_')}.html';
      return '<a href="$href" style="color:$textColor;">${_escHtml(item)}</a>';
    }).join('');
    final cartBtn = showCart ? '<button class="cart-btn" onclick="toggleCart()">🛒 <span class="cart-count">0</span></button>' : '';

    return '''<nav class="navbar" style="background:$bg;">
  <div class="nav-brand" style="color:$textColor;">$brand</div>
  <div class="nav-links">$links</div>
  <div class="nav-actions">$cartBtn</div>
  <button class="hamburger" onclick="toggleMenu()">☰</button>
</nav>''';
  }

  String _renderHero(PageElement el) {
    final p = el.properties;
    final bg = p['backgroundImageUrl'] != null && (p['backgroundImageUrl'] as String).isNotEmpty
        ? 'background-image:url(${p['backgroundImageUrl']});background-size:cover;background-position:center;'
        : 'background:${p['backgroundColor'] ?? '#1A0A3A'};';
    final textColor = p['textColor'] ?? '#FFFFFF';
    final btn = p['buttonLabel'] != null
        ? '<a href="#" class="hero-btn" style="background:var(--primary);">${_escHtml(p['buttonLabel'])}</a>'
        : '';
    return '''<section class="hero" style="$bg">
  <div class="hero-inner">
    <h1 style="color:$textColor;">${_escHtml(p['title'] ?? '')}</h1>
    <p style="color:$textColor;opacity:0.85;">${_escHtml(p['subtitle'] ?? '')}</p>
    $btn
  </div>
</section>''';
  }

  String _renderText(PageElement el, {String tag = 'p'}) {
    final p = el.properties;
    final style = 'color:${p['color'] ?? '#FFFFFF'};font-size:${p['fontSize'] ?? 16}px;font-weight:${_fontWeight(p['fontWeight'])};text-align:${p['textAlign'] ?? 'left'};padding:4px 20px;';
    return '<$tag style="$style">${_escHtml(p['content'] ?? '')}</$tag>';
  }

  String _renderButton(PageElement el) {
    final p = el.properties;
    final style = 'background:${p['backgroundColor'] ?? 'var(--primary)'};color:${p['textColor'] ?? '#fff'};border-radius:${p['borderRadius'] ?? 14}px;padding:14px 28px;font-size:${p['fontSize'] ?? 15}px;font-weight:${_fontWeight(p['fontWeight'])};border:none;cursor:pointer;display:block;margin:12px auto;';
    final href = p['action'] == 'page' ? '${p['actionTarget'].toString().toLowerCase().replaceAll(' ', '_')}.html' : '#';
    return '<a href="$href" style="$style;text-decoration:none;text-align:center;">${_escHtml(p['label'] ?? 'Button')}</a>';
  }

  String _renderImage(PageElement el) {
    final p = el.properties;
    final src = (p['imageUrl'] as String?)?.isNotEmpty == true ? p['imageUrl'] : null;
    if (src != null) {
      return '<img src="$src" alt="${_escHtml(p['altText'] ?? '')}" style="border-radius:${p['borderRadius'] ?? 12}px;width:100%;object-fit:${p['objectFit'] ?? 'cover'};display:block;">';
    }
    return '<div style="background:${p['placeholderColor'] ?? '#1E1E3A'};border-radius:${p['borderRadius'] ?? 12}px;height:200px;display:flex;align-items:center;justify-content:center;color:#444;font-size:14px;margin:8px 16px;">Add Image</div>';
  }

  String _renderProductCard(PageElement el) {
    final p = el.properties;
    final bg = p['backgroundColor'] ?? '#12122A';
    final br = p['borderRadius'] ?? 16;
    final badge = (p['badge'] as String?)?.isNotEmpty == true
        ? '<span class="badge">${_escHtml(p['badge'])}</span>' : '';
    final img = (p['imageUrl'] as String?)?.isNotEmpty == true
        ? '<img src="${p['imageUrl']}" alt="${_escHtml(p['productName'] ?? '')}" style="width:100%;height:160px;object-fit:cover;border-radius:${br}px ${br}px 0 0;">'
        : '<div style="height:160px;background:#1E1E3A;border-radius:${br}px ${br}px 0 0;display:flex;align-items:center;justify-content:center;font-size:32px;">🛍️</div>';
    return '''<div class="product-card" style="background:$bg;border-radius:${br}px;margin:8px;">
  <div style="position:relative;">$img$badge</div>
  <div style="padding:12px;">
    <h3 style="margin:0 0 4px;color:#fff;font-size:15px;">${_escHtml(p['productName'] ?? 'Product')}</h3>
    <p style="color:#aaa;font-size:12px;margin:0 0 8px;">${_escHtml(p['description'] ?? '')}</p>
    <div style="display:flex;align-items:center;gap:8px;">
      <span style="color:#fff;font-weight:700;">${_escHtml(p['price'] ?? '')}</span>
      <span style="color:#666;text-decoration:line-through;font-size:12px;">${_escHtml(p['originalPrice'] ?? '')}</span>
    </div>
    <button onclick="addToCart('${_escHtml(p['productName'] ?? '')}', '${_escHtml(p['price'] ?? '')}')" style="background:var(--primary);color:#fff;border:none;border-radius:10px;padding:10px;width:100%;margin-top:10px;cursor:pointer;font-weight:600;">Add to Cart</button>
  </div>
</div>''';
  }

  String _renderFeatureCard(PageElement el) {
    final p = el.properties;
    return '''<div class="feature-card" style="background:${p['backgroundColor'] ?? '#12122A'};border-radius:${p['borderRadius'] ?? 16}px;padding:20px;margin:8px 16px;">
  <div style="font-size:28px;margin-bottom:8px;color:${p['iconColor'] ?? 'var(--primary)'};">⭐</div>
  <h3 style="margin:0 0 6px;color:#fff;">${_escHtml(p['title'] ?? '')}</h3>
  <p style="color:#aaa;margin:0;font-size:14px;">${_escHtml(p['description'] ?? '')}</p>
</div>''';
  }

  String _renderTestimonial(PageElement el) {
    final p = el.properties;
    final stars = '⭐' * ((p['rating'] as int?) ?? 5);
    return '''<div class="testimonial" style="background:${p['backgroundColor'] ?? '#12122A'};border-radius:16px;padding:20px;margin:8px 16px;border-left:3px solid ${p['accentColor'] ?? 'var(--primary)'};">
  <p style="color:#ddd;font-style:italic;margin:0 0 12px;">${_escHtml(p['quote'] ?? '')}</p>
  <div style="font-size:14px;">$stars</div>
  <strong style="color:#fff;">${_escHtml(p['authorName'] ?? '')}</strong>
  <span style="color:#888;font-size:12px;margin-left:6px;">${_escHtml(p['authorRole'] ?? '')}</span>
</div>''';
  }

  String _renderContactForm(PageElement el) {
    final p = el.properties;
    final fields = (p['fields'] as List?)?.cast<String>() ?? ['name', 'email', 'message'];
    final inputs = fields.map((f) {
      if (f == 'message') {
        return '<textarea name="$f" placeholder="${_capitalize(f)}" style="width:100%;padding:12px;border-radius:10px;border:1px solid #333;background:#1A1A2E;color:#fff;font-family:Inter,sans-serif;resize:vertical;min-height:100px;box-sizing:border-box;" required></textarea>';
      }
      final type = f == 'email' ? 'email' : (f == 'phone' ? 'tel' : 'text');
      return '<input type="$type" name="$f" placeholder="${_capitalize(f)}" style="width:100%;padding:12px;border-radius:10px;border:1px solid #333;background:#1A1A2E;color:#fff;font-family:Inter,sans-serif;box-sizing:border-box;" required>';
    }).join('<br><br>');
    final title = (p['title'] as String?)?.isNotEmpty == true
        ? '<h3 style="color:#fff;margin:0 0 16px;">${_escHtml(p['title'])}</h3>' : '';
    return '''<div style="background:${p['backgroundColor'] ?? '#12122A'};border-radius:16px;padding:24px;margin:8px 16px;">
  $title
  <form onsubmit="handleFormSubmit(event)">
    $inputs<br><br>
    <button type="submit" style="background:${p['accentColor'] ?? 'var(--primary)'};color:#fff;border:none;border-radius:12px;padding:14px 28px;font-size:15px;font-weight:600;cursor:pointer;width:100%;">${_escHtml(p['submitLabel'] ?? 'Submit')}</button>
  </form>
</div>''';
  }

  String _renderFooter(PageElement el) {
    final p = el.properties;
    final links = (p['links'] as List?)?.cast<String>() ?? [];
    final linkHtml = links
        .map((l) => '<a href="${l.toLowerCase().replaceAll(' ', '_')}.html" style="color:${p['textColor'] ?? '#888899'};text-decoration:none;">${_escHtml(l)}</a>')
        .join(' · ');
    return '''<footer style="background:${p['backgroundColor'] ?? '#06060F'};padding:30px 20px;text-align:center;">
  <div style="color:${p['textColor'] ?? '#888899'};font-weight:700;font-size:16px;margin-bottom:6px;">${_escHtml(p['brandName'] ?? '')}</div>
  <div style="color:${p['textColor'] ?? '#888899'};font-size:13px;margin-bottom:12px;">${_escHtml(p['tagline'] ?? '')}</div>
  <div style="font-size:13px;">$linkHtml</div>
  <p style="color:${p['textColor'] ?? '#888899'};font-size:11px;margin-top:16px;">© 2025 ${_escHtml(p['brandName'] ?? '')}. Built with SiteBuilder.</p>
</footer>''';
  }

  String _renderPricingCard(PageElement el) {
    final p = el.properties;
    final features = (p['features'] as List?)?.cast<String>() ?? [];
    final featureHtml = features.map((f) => '<li>✓ ${_escHtml(f)}</li>').join('');
    final highlighted = p['isHighlighted'] == true;
    return '''<div class="pricing-card" style="background:${p['backgroundColor'] ?? '#12122A'};border-radius:20px;padding:24px;margin:8px;${highlighted ? 'transform:scale(1.03);box-shadow:0 8px 32px rgba(0,0,0,0.4);' : ''}">
  <h3 style="color:#fff;margin:0 0 8px;">${_escHtml(p['planName'] ?? 'Plan')}</h3>
  <div style="font-size:32px;font-weight:700;color:${highlighted ? '#fff' : 'var(--primary)'};">${_escHtml(p['price'] ?? '')} <span style="font-size:14px;opacity:0.7;">${_escHtml(p['period'] ?? '')}</span></div>
  <ul style="color:#ccc;list-style:none;padding:0;margin:16px 0;"> $featureHtml </ul>
  <button style="background:${highlighted ? 'rgba(255,255,255,0.2)' : 'var(--primary)'};color:#fff;border:none;border-radius:12px;padding:12px;width:100%;font-weight:600;cursor:pointer;">${_escHtml(p['buttonLabel'] ?? 'Get Started')}</button>
</div>''';
  }

  String _renderBlogPostCard(PageElement el) {
    final p = el.properties;
    return '''<article class="post-card" style="background:${p['backgroundColor'] ?? '#1A1A1A'};border-radius:16px;overflow:hidden;margin:8px 16px;">
  <div style="padding:16px;">
    <span style="color:var(--primary);font-size:12px;font-weight:600;">${_escHtml(p['category'] ?? '')} · ${_escHtml(p['readTime'] ?? '')}</span>
    <h2 style="color:#fff;margin:8px 0;font-size:17px;">${_escHtml(p['title'] ?? '')}</h2>
    <p style="color:#aaa;font-size:13px;margin:0 0 12px;">${_escHtml(p['excerpt'] ?? '')}</p>
    <div style="font-size:12px;color:#666;">${_escHtml(p['author'] ?? '')} · ${_escHtml(p['date'] ?? '')}</div>
  </div>
</article>''';
  }

  String _renderTeamCard(PageElement el) {
    final p = el.properties;
    return '''<div class="team-card" style="background:${p['backgroundColor'] ?? '#12122A'};border-radius:16px;padding:20px;display:flex;align-items:center;gap:16px;margin:8px 16px;">
  <div style="width:60px;height:60px;border-radius:50%;background:#1E1E3A;display:flex;align-items:center;justify-content:center;font-size:24px;flex-shrink:0;">👤</div>
  <div>
    <h3 style="color:#fff;margin:0 0 2px;font-size:16px;">${_escHtml(p['name'] ?? '')}</h3>
    <div style="color:var(--primary);font-size:12px;font-weight:600;">${_escHtml(p['role'] ?? '')}</div>
    <p style="color:#aaa;font-size:13px;margin:6px 0 0;">${_escHtml(p['bio'] ?? '')}</p>
  </div>
</div>''';
  }

  String _renderFaqItem(PageElement el) {
    final p = el.properties;
    final id = el.id.replaceAll('-', '');
    return '''<div class="faq-item" style="background:${p['backgroundColor'] ?? '#12122A'};border-radius:12px;margin:8px 16px;overflow:hidden;">
  <button onclick="toggleFaq('$id')" style="width:100%;text-align:left;background:none;border:none;padding:16px;color:#fff;font-size:15px;font-weight:600;cursor:pointer;display:flex;justify-content:space-between;align-items:center;">
    ${_escHtml(p['question'] ?? '')} <span id="icon_$id">▶</span>
  </button>
  <div id="faq_$id" style="display:none;padding:0 16px 16px;color:#aaa;font-size:14px;">${_escHtml(p['answer'] ?? '')}</div>
</div>''';
  }

  String _renderSocialLinks(PageElement el) {
    final p = el.properties;
    final platforms = (p['platforms'] as List?)?.cast<String>() ?? [];
    final icons = {'instagram': '📸', 'twitter': '🐦', 'facebook': '📘', 'linkedin': '💼', 'youtube': '▶️'};
    final links = platforms.map((platform) {
      final url = (p['urls'] as Map?)?[platform] ?? '#';
      return '<a href="${_escHtml(url.toString())}" style="color:${p['color'] ?? 'var(--primary)'};font-size:24px;text-decoration:none;">${icons[platform] ?? '🔗'}</a>';
    }).join('  ');
    return '<div style="padding:12px 20px;display:flex;gap:16px;justify-content:center;">$links</div>';
  }

  String _generateGlobalCss(WebsiteProject project) {
    return '''/* SiteBuilder Generated CSS */
*, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
body { font-family: 'Inter', sans-serif; min-height: 100vh; }
img { max-width: 100%; }
a { text-decoration: none; }

/* Navbar */
.navbar { display: flex; align-items: center; padding: 0 20px; height: 60px; position: sticky; top: 0; z-index: 1000; justify-content: space-between; gap: 16px; }
.nav-brand { font-size: 18px; font-weight: 700; color: #fff; flex-shrink: 0; }
.nav-links { display: flex; gap: 20px; }
.nav-links a { font-size: 14px; font-weight: 500; opacity: 0.85; transition: opacity .2s; }
.nav-links a:hover { opacity: 1; }
.hamburger { display: none; background: none; border: none; color: #fff; font-size: 22px; cursor: pointer; }
@media (max-width: 600px) { .nav-links { display: none; } .hamburger { display: block; } }

/* Hero */
.hero { min-height: 300px; display: flex; align-items: center; padding: 40px 20px; }
.hero-inner { max-width: 600px; }
.hero h1 { font-size: clamp(24px, 5vw, 44px); font-weight: 800; line-height: 1.25; margin-bottom: 16px; }
.hero p { font-size: 16px; line-height: 1.7; margin-bottom: 24px; }
.hero-btn { display: inline-block; color: #fff; padding: 14px 32px; border-radius: 14px; font-weight: 600; font-size: 15px; transition: opacity .2s, transform .2s; }
.hero-btn:hover { opacity: 0.9; transform: translateY(-1px); }

/* Cards */
.product-card, .feature-card, .testimonial, .pricing-card, .post-card, .team-card, .faq-item {
  transition: transform .2s, box-shadow .2s;
}
.product-card:hover, .pricing-card:hover { transform: translateY(-4px); box-shadow: 0 12px 40px rgba(0,0,0,0.4); }

/* Product badge */
.badge { position: absolute; top: 10px; right: 10px; background: var(--primary); color: #fff; font-size: 10px; font-weight: 700; padding: 3px 8px; border-radius: 6px; }

/* Cart */
.cart-btn { background: transparent; border: 1.5px solid rgba(255,255,255,0.2); border-radius: 10px; color: #fff; padding: 8px 12px; cursor: pointer; font-size: 14px; display: flex; align-items: center; gap: 6px; }
.cart-count { background: var(--primary); border-radius: 50%; width: 18px; height: 18px; font-size: 11px; display: inline-flex; align-items: center; justify-content: center; }

/* Smooth */
html { scroll-behavior: smooth; }
''';
  }

  String _generateGlobalJs(WebsiteProject project) {
    return '''/* SiteBuilder Generated JS */

// Cart system
let cart = JSON.parse(localStorage.getItem('cart') || '[]');

function updateCartCount() {
  document.querySelectorAll('.cart-count').forEach(el => el.textContent = cart.length);
}

function addToCart(name, price) {
  cart.push({ name, price, id: Date.now() });
  localStorage.setItem('cart', JSON.stringify(cart));
  updateCartCount();
  showToast('Added to cart: ' + name);
}

function toggleCart() {
  const existing = document.getElementById('cart-drawer');
  if (existing) { existing.remove(); return; }
  const items = cart.map(i => '<div style="padding:10px 0;border-bottom:1px solid #333;color:#fff;">' + i.name + ' — ' + i.price + '</div>').join('');
  const drawer = document.createElement('div');
  drawer.id = 'cart-drawer';
  drawer.style.cssText = 'position:fixed;top:60px;right:0;width:300px;max-height:70vh;overflow-y:auto;background:#12122A;z-index:2000;padding:20px;border-radius:0 0 0 16px;box-shadow:-4px 4px 24px rgba(0,0,0,0.5);';
  drawer.innerHTML = '<h3 style="color:#fff;margin:0 0 16px;">Your Cart (' + cart.length + ')</h3>' + (items || '<p style="color:#888;">Cart is empty.</p>') + (cart.length ? '<button onclick="proceedCheckout()" style="background:var(--primary);color:#fff;border:none;border-radius:10px;padding:12px;width:100%;margin-top:12px;font-weight:600;cursor:pointer;">Checkout</button>' : '');
  document.body.appendChild(drawer);
}

function proceedCheckout() {
  window.location.href = 'checkout.html';
}

// Navbar
function toggleMenu() {
  const links = document.querySelector('.nav-links');
  if (links) {
    const isOpen = links.style.display === 'flex';
    links.style.cssText = isOpen ? '' : 'display:flex;flex-direction:column;position:absolute;top:60px;left:0;right:0;background:inherit;padding:16px 20px;z-index:999;gap:16px;';
  }
}

// Forms
function handleFormSubmit(e) {
  e.preventDefault();
  showToast('Message sent successfully! We will get back to you soon.');
  e.target.reset();
}

// FAQ
function toggleFaq(id) {
  const content = document.getElementById('faq_' + id);
  const icon = document.getElementById('icon_' + id);
  if (content) {
    const open = content.style.display === 'block';
    content.style.display = open ? 'none' : 'block';
    if (icon) icon.textContent = open ? '▶' : '▼';
  }
}

// Toast
function showToast(msg) {
  const toast = document.createElement('div');
  toast.style.cssText = 'position:fixed;bottom:24px;left:50%;transform:translateX(-50%);background:#1A1A2E;color:#fff;padding:12px 24px;border-radius:12px;z-index:9999;font-size:14px;box-shadow:0 4px 24px rgba(0,0,0,0.4);border:1px solid rgba(255,255,255,0.1);';
  toast.textContent = msg;
  document.body.appendChild(toast);
  setTimeout(() => toast.remove(), 3000);
}

// Init
document.addEventListener('DOMContentLoaded', updateCartCount);
''';
  }

  String _escHtml(String? text) => (text ?? '').replaceAll('&', '&amp;').replaceAll('<', '&lt;').replaceAll('>', '&gt;').replaceAll('"', '&quot;');
  String _capitalize(String s) => s.isEmpty ? '' : s[0].toUpperCase() + s.substring(1);
  String _fontWeight(dynamic fw) {
    switch (fw) {
      case 'bold': return '700';
      case 'semibold': return '600';
      case 'medium': return '500';
      default: return '400';
    }
  }
}
