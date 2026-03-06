import 'dart:io';
import 'package:flutter/material.dart';
import '../../models/page_element.dart';
import '../../models/element_type.dart';

/// Renders a PageElement as a Flutter widget preview on the canvas.
class ElementRenderer extends StatelessWidget {
  final PageElement element;
  const ElementRenderer({super.key, required this.element});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: _render(context),
    );
  }

  Widget _render(BuildContext context) {
    switch (element.elementType) {
      case ElementType.text:
      case ElementType.heading:
        return _renderText();
      case ElementType.image:
        return _renderImage();
      case ElementType.button:
      case ElementType.cartButton:
        return _renderButton();
      case ElementType.navbar:
        return _renderNavbar();
      case ElementType.hero:
        return _renderHero();
      case ElementType.productCard:
        return _renderProductCard();
      case ElementType.featureCard:
        return _renderFeatureCard();
      case ElementType.testimonial:
        return _renderTestimonial();
      case ElementType.contactForm:
        return _renderContactForm();
      case ElementType.footer:
        return _renderFooter();
      case ElementType.pricingCard:
        return _renderPricingCard();
      case ElementType.blogPostCard:
        return _renderBlogPostCard();
      case ElementType.teamCard:
        return _renderTeamCard();
      case ElementType.faqItem:
        return _renderFaqItem();
      case ElementType.divider:
        return _renderDivider();
      case ElementType.spacer:
        return Container(color: Colors.white.withOpacity(0.03));
      case ElementType.section:
        return Container(color: _c(_s('backgroundColor', '#0A0A1A')));
      case ElementType.socialLinks:
        return _renderSocialLinks();
      case ElementType.video:
        return _renderVideo();
      case ElementType.map:
        return _renderMap();
      case ElementType.countdown:
        return _renderCountdown();
      case ElementType.gallery:
        return _renderGallery();
      case ElementType.accordion:
        return _renderAccordion();
      case ElementType.statsCounter:
        return _renderStatsCounter();
    }
  }

  Color _c(String? hex, [Color fallback = Colors.white]) {
    if (hex == null || hex.isEmpty) return fallback;
    try { return Color(int.parse(hex.replaceAll('#', '0xFF'))); } catch (_) { return fallback; }
  }

  double _d(String key, [double def = 0]) => ((element.properties[key] as num?)?.toDouble()) ?? def;
  String _s(String key, [String def = '']) => element.properties[key]?.toString() ?? def;
  bool _b(String key, [bool def = false]) => element.properties[key] == true;

  Widget _renderText() {
    final align = _s('textAlign', 'left');
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      child: Text(
        _s('content', 'Text'),
        style: TextStyle(
          color: _c(_s('color', '#FFFFFF')),
          fontSize: _d('fontSize', 16).clamp(8, 72),
          fontWeight: _fw(_s('fontWeight', 'normal')),
        ),
        textAlign: align == 'center' ? TextAlign.center : align == 'right' ? TextAlign.right : TextAlign.left,
        overflow: TextOverflow.fade,
      ),
    );
  }

  Widget _renderImage() {
    final url = _s('imageUrl');
    final br = _d('borderRadius', 12);
    if (url.isEmpty) {
      return Container(
        decoration: BoxDecoration(color: _c(_s('placeholderColor', '#1E1E3A')), borderRadius: BorderRadius.circular(br)),
        child: const Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
          Icon(Icons.add_photo_alternate_outlined, color: Colors.white30, size: 32),
          SizedBox(height: 4),
          Text('Tap to add image', style: TextStyle(color: Colors.white30, fontSize: 11)),
        ])),
      );
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(br),
      child: url.startsWith('/')
          ? Image.file(File(url), width: double.infinity, height: double.infinity, fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(color: const Color(0xFF1E1E3A)))
          : Image.network(url, width: double.infinity, height: double.infinity, fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(color: const Color(0xFF1E1E3A))),
    );
  }

  Widget _renderButton() {
    return Container(
      decoration: BoxDecoration(
        color: _c(_s('backgroundColor', '#7C3AED')),
        borderRadius: BorderRadius.circular(_d('borderRadius', 14)),
      ),
      alignment: Alignment.center,
      child: Text(_s('label', 'Button'), style: TextStyle(
        color: _c(_s('textColor', '#FFFFFF')),
        fontSize: _d('fontSize', 15).clamp(10, 24),
        fontWeight: _fw(_s('fontWeight', 'semibold')),
      )),
    );
  }

  Widget _renderNavbar() {
    final menuItems = (element.properties['menuItems'] as List?)?.cast<String>() ?? ['Home', 'About'];
    return Container(
      color: _c(_s('backgroundColor', '#0A0A1A')),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(children: [
        Text(_s('brandName', 'Brand'), style: TextStyle(color: _c(_s('textColor', '#FFFFFF')), fontWeight: FontWeight.w700, fontSize: 14)),
        const Spacer(),
        ...menuItems.take(3).map((item) => Padding(
          padding: const EdgeInsets.only(left: 12),
          child: Text(item, style: TextStyle(color: _c(_s('textColor', '#FFFFFF')).withOpacity(0.7), fontSize: 11)),
        )),
        if (_b('showCart'))
          const Padding(padding: EdgeInsets.only(left: 10), child: Icon(Icons.shopping_cart_outlined, color: Colors.white70, size: 16)),
      ]),
    );
  }

  Widget _renderHero() {
    final bg = _s('backgroundImageUrl');
    return Container(
      decoration: BoxDecoration(
        color: _c(_s('backgroundColor', '#1A0A3A')),
        image: bg.isNotEmpty ? DecorationImage(image: NetworkImage(bg), fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(Colors.black.withOpacity(_d('overlayOpacity', 0.4)), BlendMode.darken)) : null,
      ),
      padding: const EdgeInsets.all(20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(_s('title', 'Hero Title'), style: TextStyle(color: _c(_s('textColor', '#FFFFFF')), fontSize: 20, fontWeight: FontWeight.w800), overflow: TextOverflow.ellipsis, maxLines: 2),
        const SizedBox(height: 6),
        Text(_s('subtitle', 'Subtitle'), style: TextStyle(color: _c(_s('textColor', '#FFFFFF')).withOpacity(0.8), fontSize: 12), overflow: TextOverflow.ellipsis, maxLines: 2),
        const SizedBox(height: 12),
        if (_s('buttonLabel').isNotEmpty)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(color: const Color(0xFF7C3AED), borderRadius: BorderRadius.circular(10)),
            child: Text(_s('buttonLabel'), style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
          ),
      ]),
    );
  }

  Widget _renderProductCard() {
    final imageUrl = _s('imageUrl');
    final br = _d('borderRadius', 16);
    return Container(
      decoration: BoxDecoration(color: _c(_s('backgroundColor', '#12122A')), borderRadius: BorderRadius.circular(br)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Expanded(flex: 6, child: Stack(children: [
          Container(
            decoration: BoxDecoration(color: const Color(0xFF1E1E3A), borderRadius: BorderRadius.vertical(top: Radius.circular(br)),
              image: imageUrl.isNotEmpty ? DecorationImage(image: NetworkImage(imageUrl), fit: BoxFit.cover) : null),
            child: imageUrl.isEmpty ? const Center(child: Icon(Icons.shopping_bag_outlined, color: Colors.white24, size: 32)) : null,
          ),
          if (_s('badge').isNotEmpty) Positioned(top: 8, right: 8, child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(color: const Color(0xFF7C3AED), borderRadius: BorderRadius.circular(4)),
            child: Text(_s('badge'), style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w700)),
          )),
        ])),
        Expanded(flex: 5, child: Padding(padding: const EdgeInsets.all(10), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(_s('productName', 'Product'), style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600), overflow: TextOverflow.ellipsis),
          const SizedBox(height: 4),
          Row(children: [
            Text(_s('price'), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 12)),
            const SizedBox(width: 6),
            Text(_s('originalPrice'), style: const TextStyle(color: Colors.white38, decoration: TextDecoration.lineThrough, fontSize: 10)),
          ]),
          const Spacer(),
          Container(height: 26, decoration: BoxDecoration(color: const Color(0xFF7C3AED), borderRadius: BorderRadius.circular(8)),
            alignment: Alignment.center, child: const Text('Add to Cart', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w600))),
        ]))),
      ]),
    );
  }

  Widget _renderFeatureCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: _c(_s('backgroundColor', '#12122A')), borderRadius: BorderRadius.circular(_d('borderRadius', 16))),
      child: Row(children: [
        Container(width: 36, height: 36,
          decoration: BoxDecoration(color: _c(_s('iconColor', '#7C3AED')).withOpacity(0.15), borderRadius: BorderRadius.circular(10)),
          child: Center(child: Icon(Icons.star_outline, color: _c(_s('iconColor', '#7C3AED')), size: 18))),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(_s('title', 'Feature'), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13), overflow: TextOverflow.ellipsis),
          const SizedBox(height: 3),
          Text(_s('description'), style: const TextStyle(color: Colors.white54, fontSize: 11), overflow: TextOverflow.ellipsis, maxLines: 2),
        ])),
      ]),
    );
  }

  Widget _renderTestimonial() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: _c(_s('backgroundColor', '#12122A')), borderRadius: BorderRadius.circular(12),
        border: Border(left: BorderSide(color: _c(_s('accentColor', '#7C3AED')), width: 3))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(_s('quote', '"Great product!"'), style: const TextStyle(color: Colors.white70, fontSize: 12, fontStyle: FontStyle.italic), overflow: TextOverflow.fade, maxLines: 3),
        const Spacer(),
        Row(children: [
          const Icon(Icons.star, color: Color(0xFFF59E0B), size: 12),
          const Icon(Icons.star, color: Color(0xFFF59E0B), size: 12),
          const Icon(Icons.star, color: Color(0xFFF59E0B), size: 12),
          const SizedBox(width: 8),
          Expanded(child: Text(_s('authorName', 'Author'), style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600))),
        ]),
      ]),
    );
  }

  Widget _renderContactForm() {
    final fields = (element.properties['fields'] as List?)?.cast<String>() ?? ['name', 'email', 'message'];
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: _c(_s('backgroundColor', '#12122A')), borderRadius: BorderRadius.circular(12)),
      child: Column(children: [
        if (_s('title').isNotEmpty)
          Padding(padding: const EdgeInsets.only(bottom: 10),
            child: Text(_s('title'), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14))),
        ...fields.take(3).map((f) => Container(
          height: 36, margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.white.withOpacity(0.1))),
          alignment: Alignment.centerLeft,
          child: Text(f[0].toUpperCase() + f.substring(1), style: const TextStyle(color: Colors.white38, fontSize: 12)),
        )),
        const Spacer(),
        Container(height: 36, decoration: BoxDecoration(color: _c(_s('accentColor', '#7C3AED')), borderRadius: BorderRadius.circular(10)),
          alignment: Alignment.center,
          child: Text(_s('submitLabel', 'Submit'), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13))),
      ]),
    );
  }

  Widget _renderFooter() {
    return Container(color: _c(_s('backgroundColor', '#06060F')), alignment: Alignment.center, padding: const EdgeInsets.all(16),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(_s('brandName', 'Brand'), style: TextStyle(color: _c(_s('textColor', '#888899')), fontWeight: FontWeight.w700, fontSize: 14)),
        const SizedBox(height: 4),
        Text(_s('tagline'), style: TextStyle(color: _c(_s('textColor', '#888899')), fontSize: 11)),
        const SizedBox(height: 8),
        Text('© 2025 · Built with SiteBuilder', style: TextStyle(color: _c(_s('textColor', '#888899')).withOpacity(0.5), fontSize: 10)),
      ]),
    );
  }

  Widget _renderPricingCard() {
    final features = (element.properties['features'] as List?)?.cast<String>() ?? [];
    final highlighted = _b('isHighlighted');
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: _c(_s('backgroundColor', '#12122A')), borderRadius: BorderRadius.circular(16),
        border: highlighted ? Border.all(color: _c(_s('accentColor', '#7C3AED')), width: 2) : null),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(_s('planName', 'Plan'), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14)),
        const SizedBox(height: 4),
        Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Text(_s('price'), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 22)),
          const SizedBox(width: 4),
          Text(_s('period'), style: const TextStyle(color: Colors.white54, fontSize: 11)),
        ]),
        const SizedBox(height: 8),
        ...features.take(4).map((f) => Padding(padding: const EdgeInsets.only(bottom: 4),
          child: Row(children: [
            Icon(Icons.check, color: _c(_s('accentColor', '#7C3AED')), size: 12),
            const SizedBox(width: 6),
            Expanded(child: Text(f, style: const TextStyle(color: Colors.white70, fontSize: 11), overflow: TextOverflow.ellipsis)),
          ]))),
      ]),
    );
  }

  Widget _renderBlogPostCard() {
    return Container(
      decoration: BoxDecoration(color: _c(_s('backgroundColor', '#1A1A1A')), borderRadius: BorderRadius.circular(12)),
      padding: const EdgeInsets.all(14),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(color: const Color(0xFF7C3AED).withOpacity(0.2), borderRadius: BorderRadius.circular(6)),
            child: Text(_s('category', 'Category'), style: const TextStyle(color: Color(0xFF7C3AED), fontSize: 10, fontWeight: FontWeight.w600))),
          const Spacer(),
          Text(_s('readTime', '5 min'), style: const TextStyle(color: Colors.white38, fontSize: 10)),
        ]),
        const SizedBox(height: 8),
        Text(_s('title', 'Blog Post Title'), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13), overflow: TextOverflow.ellipsis, maxLines: 2),
        const SizedBox(height: 4),
        Text(_s('excerpt'), style: const TextStyle(color: Colors.white54, fontSize: 11), overflow: TextOverflow.ellipsis, maxLines: 2),
        const Spacer(),
        Text(_s('author'), style: const TextStyle(color: Colors.white38, fontSize: 10)),
      ]),
    );
  }

  Widget _renderTeamCard() {
    return Container(
      decoration: BoxDecoration(color: _c(_s('backgroundColor', '#12122A')), borderRadius: BorderRadius.circular(12)),
      padding: const EdgeInsets.all(14),
      child: Row(children: [
        const CircleAvatar(radius: 26, backgroundColor: Color(0xFF1E1E3A), child: Icon(Icons.person_outline, color: Colors.white54, size: 24)),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(_s('name', 'Name'), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13), overflow: TextOverflow.ellipsis),
          const SizedBox(height: 3),
          Text(_s('role'), style: const TextStyle(color: Color(0xFF7C3AED), fontSize: 11, fontWeight: FontWeight.w500)),
          const SizedBox(height: 4),
          Text(_s('bio'), style: const TextStyle(color: Colors.white54, fontSize: 11), overflow: TextOverflow.ellipsis, maxLines: 2),
        ])),
      ]),
    );
  }

  Widget _renderFaqItem() {
    return Container(
      decoration: BoxDecoration(color: _c(_s('backgroundColor', '#12122A')), borderRadius: BorderRadius.circular(10)),
      padding: const EdgeInsets.all(14),
      child: Row(children: [
        Expanded(child: Text(_s('question', 'Question?'), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13), overflow: TextOverflow.ellipsis)),
        Icon(Icons.keyboard_arrow_down, color: _c(_s('accentColor', '#7C3AED')), size: 18),
      ]),
    );
  }

  Widget _renderDivider() => Container(height: 1, color: _c(_s('color', '#2A2A4A')), margin: const EdgeInsets.symmetric(horizontal: 16));

  Widget _renderSocialLinks() {
    final platforms = (element.properties['platforms'] as List?)?.cast<String>() ?? ['instagram'];
    final icons = {'instagram': Icons.photo_camera_outlined, 'twitter': Icons.alternate_email, 'facebook': Icons.facebook, 'linkedin': Icons.work_outline, 'youtube': Icons.play_circle_outline};
    return Container(
      alignment: Alignment.center,
      child: Row(mainAxisAlignment: MainAxisAlignment.center,
        children: platforms.take(4).map((p) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: Icon(icons[p] ?? Icons.link, color: _c(_s('color', '#7C3AED')), size: 22),
        )).toList()),
    );
  }

  // ====== NEW ELEMENT RENDERERS ======

  Widget _renderVideo() {
    return Container(
      decoration: BoxDecoration(color: _c(_s('backgroundColor', '#12122A')), borderRadius: BorderRadius.circular(_d('borderRadius', 16))),
      child: Column(children: [
        Expanded(child: Container(
          decoration: BoxDecoration(color: const Color(0xFF1E1E3A), borderRadius: BorderRadius.vertical(top: Radius.circular(_d('borderRadius', 16)))),
          child: const Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
            Icon(Icons.play_circle_fill, color: Colors.white38, size: 48),
            SizedBox(height: 4),
            Text('Video Player', style: TextStyle(color: Colors.white30, fontSize: 11)),
          ])),
        )),
        if (_s('caption').isNotEmpty) Padding(padding: const EdgeInsets.all(10),
          child: Text(_s('caption'), style: const TextStyle(color: Colors.white54, fontSize: 11), overflow: TextOverflow.ellipsis)),
      ]),
    );
  }

  Widget _renderMap() {
    return Container(
      decoration: BoxDecoration(color: const Color(0xFF1A2A2A), borderRadius: BorderRadius.circular(_d('borderRadius', 16))),
      child: Stack(children: [
        Positioned.fill(child: CustomPaint(painter: _MapGridPainter())),
        Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Icon(Icons.location_on, color: Color(0xFFFF4D6D), size: 36),
          const SizedBox(height: 4),
          Text(_s('address', 'Location'), style: const TextStyle(color: Colors.white54, fontSize: 11),
            textAlign: TextAlign.center, overflow: TextOverflow.ellipsis),
        ])),
      ]),
    );
  }

  Widget _renderCountdown() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: _c(_s('backgroundColor', '#12122A')), borderRadius: BorderRadius.circular(16)),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(_s('title', 'Coming Soon'), style: TextStyle(color: _c(_s('textColor', '#FFFFFF')), fontWeight: FontWeight.w800, fontSize: 16)),
        const SizedBox(height: 6),
        Text(_s('subtitle', ''), style: TextStyle(color: _c(_s('textColor', '#FFFFFF')).withOpacity(0.6), fontSize: 11)),
        const SizedBox(height: 14),
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          _countUnit('00', 'Days'), _countUnit('00', 'Hours'), _countUnit('00', 'Min'), _countUnit('00', 'Sec'),
        ]),
      ]),
    );
  }

  Widget _countUnit(String value, String label) {
    return Column(children: [
      Container(width: 44, height: 44,
        decoration: BoxDecoration(color: _c(_s('accentColor', '#7C3AED')).withOpacity(0.15), borderRadius: BorderRadius.circular(10)),
        alignment: Alignment.center,
        child: Text(value, style: TextStyle(color: _c(_s('accentColor', '#7C3AED')), fontWeight: FontWeight.w800, fontSize: 18))),
      const SizedBox(height: 4),
      Text(label, style: const TextStyle(color: Colors.white38, fontSize: 9)),
    ]);
  }

  Widget _renderGallery() {
    final cols = (element.properties['columns'] as num?)?.toInt() ?? 2;
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(color: _c(_s('backgroundColor', '#0A0A1A')), borderRadius: BorderRadius.circular(_d('borderRadius', 12))),
      child: GridView.count(
        shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: cols, crossAxisSpacing: 6, mainAxisSpacing: 6,
        children: List.generate(cols * 2, (i) => Container(
          decoration: BoxDecoration(color: const Color(0xFF1E1E3A), borderRadius: BorderRadius.circular(8)),
          child: Icon(Icons.image_outlined, color: Colors.white.withOpacity(0.15), size: 24),
        )),
      ),
    );
  }

  Widget _renderAccordion() {
    final items = (element.properties['items'] as List?) ?? [];
    return Container(
      decoration: BoxDecoration(color: _c(_s('backgroundColor', '#12122A')), borderRadius: BorderRadius.circular(_d('borderRadius', 12))),
      child: Column(children: items.take(3).map((item) {
        final map = item as Map<String, dynamic>? ?? {};
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.06)))),
          child: Row(children: [
            Expanded(child: Text(map['title'] ?? 'Section', style: TextStyle(color: _c(_s('textColor', '#FFFFFF')), fontWeight: FontWeight.w600, fontSize: 13))),
            Icon(Icons.keyboard_arrow_down, color: _c(_s('accentColor', '#7C3AED')), size: 18),
          ]),
        );
      }).toList()),
    );
  }

  Widget _renderStatsCounter() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: _c(_s('backgroundColor', '#12122A')), borderRadius: BorderRadius.circular(_d('borderRadius', 16))),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(_s('value', '1000+'), style: TextStyle(color: _c(_s('valueColor', '#7C3AED')), fontWeight: FontWeight.w900, fontSize: 28)),
        const SizedBox(height: 4),
        Text(_s('label', 'Happy Customers'), style: TextStyle(color: _c(_s('labelColor', '#AAAACC')), fontSize: 12)),
      ]),
    );
  }

  FontWeight _fw(String fw) {
    switch (fw) {
      case 'bold': return FontWeight.w700;
      case 'semibold': return FontWeight.w600;
      case 'medium': return FontWeight.w500;
      default: return FontWeight.w400;
    }
  }
}

class _MapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withOpacity(0.04)..strokeWidth = 0.5;
    for (double x = 0; x < size.width; x += 30) canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    for (double y = 0; y < size.height; y += 30) canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
  }
  @override
  bool shouldRepaint(_) => false;
}
