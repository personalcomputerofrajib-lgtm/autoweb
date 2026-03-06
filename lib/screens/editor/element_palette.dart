import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/editor_provider.dart';
import '../../models/element_type.dart';

class ElementPalette extends StatefulWidget {
  final VoidCallback onClose;
  const ElementPalette({super.key, required this.onClose});

  @override
  State<ElementPalette> createState() => _ElementPaletteState();
}

class _ElementPaletteState extends State<ElementPalette> {
  String _activeCategory = 'Content';

  final List<String> _categories = ['Content', 'Media', 'Actions', 'Store', 'Navigation', 'Forms', 'Sections'];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.55,
      decoration: const BoxDecoration(
        color: Color(0xFF12122A),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        border: Border(
          top: BorderSide(color: Color(0xFF7C3AED), width: 2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle bar
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 8, 12),
            child: Row(
              children: [
                const Text(
                  'Add Element',
                  style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w700),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close, size: 20),
                  onPressed: widget.onClose,
                  color: Colors.white54,
                ),
              ],
            ),
          ),
          // Category tabs
          SizedBox(
            height: 36,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _categories.length,
              itemBuilder: (context, i) {
                final cat = _categories[i];
                final selected = cat == _activeCategory;
                return GestureDetector(
                  onTap: () => setState(() => _activeCategory = cat),
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: selected ? const Color(0xFF7C3AED) : const Color(0xFF1A1A2E),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      cat,
                      style: TextStyle(
                        color: selected ? Colors.white : Colors.white54,
                        fontSize: 12,
                        fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          // Elements grid
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1.2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: _filteredElements.length,
              itemBuilder: (context, i) {
                return _ElementTile(type: _filteredElements[i], onTap: () {
                  context.read<EditorProvider>().addElement(_filteredElements[i]);
                  widget.onClose();
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  List<ElementType> get _filteredElements {
    return ElementType.values.where((e) => e.category == _activeCategory).toList();
  }
}

class _ElementTile extends StatelessWidget {
  final ElementType type;
  final VoidCallback onTap;
  const _ElementTile({required this.type, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final icons = {
      'text_fields': Icons.text_fields,
      'title': Icons.title,
      'image': Icons.image_outlined,
      'smart_button': Icons.smart_button_outlined,
      'shopping_bag': Icons.shopping_bag_outlined,
      'menu': Icons.menu,
      'view_carousel': Icons.view_carousel_outlined,
      'contact_mail': Icons.contact_mail_outlined,
      'view_agenda': Icons.view_agenda_outlined,
      'horizontal_rule': Icons.horizontal_rule,
      'format_quote': Icons.format_quote,
      'star': Icons.star_outline,
      'person': Icons.person_outline,
      'payments': Icons.payments_outlined,
      'article': Icons.article_outlined,
      'help': Icons.help_outline,
      'space_bar': Icons.space_bar,
      'web': Icons.web_outlined,
      'shopping_cart': Icons.shopping_cart_outlined,
      'share': Icons.share_outlined,
    };

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A2E),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withOpacity(0.06)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icons[type.iconName] ?? Icons.widgets_outlined,
              color: const Color(0xFF7C3AED),
              size: 24,
            ),
            const SizedBox(height: 6),
            Text(
              type.displayName,
              style: const TextStyle(color: Colors.white70, fontSize: 10),
              textAlign: TextAlign.center,
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }
}
