import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:image_picker/image_picker.dart' as img_picker;
import '../../providers/editor_provider.dart';
import '../../models/page_element.dart';
import '../../models/element_type.dart';

class PropertyPanel extends StatelessWidget {
  const PropertyPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final editor = context.watch<EditorProvider>();
    final element = editor.selectedElement;
    if (element == null) return const SizedBox.shrink();

    return DraggableScrollableSheet(
      initialChildSize: 0.42,
      minChildSize: 0.15,
      maxChildSize: 0.85,
      snap: true,
      snapSizes: const [0.25, 0.42, 0.7, 0.85],
      builder: (context, scrollController) {
        return Container(
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
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 16, 12),
                child: Row(
                  children: [
                    Icon(Icons.tune, color: const Color(0xFF7C3AED), size: 18),
                    const SizedBox(width: 8),
                    Text(
                      element.elementType.displayName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Spacer(),
                    TextButton.icon(
                      onPressed: () => editor.deselectAll(),
                      icon: const Icon(Icons.check, size: 16),
                      label: const Text('Done'),
                      style: TextButton.styleFrom(
                        foregroundColor: const Color(0xFF7C3AED),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
                  children: _buildFields(context, editor, element),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  List<Widget> _buildFields(BuildContext context, EditorProvider editor, PageElement element) {
    final fields = <Widget>[];
    final p = element.properties;

    // Common text content field
    if (p.containsKey('content')) {
      fields.add(_TextField(
        label: 'Content',
        value: p['content']?.toString() ?? '',
        multiline: true,
        onChanged: (v) => editor.updateProperty(element.id, 'content', v),
      ));
    }

    if (p.containsKey('title')) {
      fields.add(_TextField(
        label: 'Title',
        value: p['title']?.toString() ?? '',
        onChanged: (v) => editor.updateProperty(element.id, 'title', v),
      ));
    }

    if (p.containsKey('subtitle')) {
      fields.add(_TextField(
        label: 'Subtitle',
        value: p['subtitle']?.toString() ?? '',
        onChanged: (v) => editor.updateProperty(element.id, 'subtitle', v),
      ));
    }

    if (p.containsKey('label')) {
      fields.add(_TextField(
        label: 'Button Label',
        value: p['label']?.toString() ?? '',
        onChanged: (v) => editor.updateProperty(element.id, 'label', v),
      ));
    }

    if (p.containsKey('brandName')) {
      fields.add(_TextField(
        label: 'Brand Name',
        value: p['brandName']?.toString() ?? '',
        onChanged: (v) => editor.updateProperty(element.id, 'brandName', v),
      ));
    }

    if (p.containsKey('productName')) {
      fields.add(_TextField(
        label: 'Product Name',
        value: p['productName']?.toString() ?? '',
        onChanged: (v) => editor.updateProperty(element.id, 'productName', v),
      ));
    }

    if (p.containsKey('price')) {
      fields.add(_TextField(
        label: 'Price',
        value: p['price']?.toString() ?? '',
        onChanged: (v) => editor.updateProperty(element.id, 'price', v),
      ));
    }

    if (p.containsKey('originalPrice')) {
      fields.add(_TextField(
        label: 'Original Price',
        value: p['originalPrice']?.toString() ?? '',
        onChanged: (v) => editor.updateProperty(element.id, 'originalPrice', v),
      ));
    }

    if (p.containsKey('description')) {
      fields.add(_TextField(
        label: 'Description',
        value: p['description']?.toString() ?? '',
        multiline: true,
        onChanged: (v) => editor.updateProperty(element.id, 'description', v),
      ));
    }

    if (p.containsKey('authorName')) {
      fields.add(_TextField(
        label: 'Author Name',
        value: p['authorName']?.toString() ?? '',
        onChanged: (v) => editor.updateProperty(element.id, 'authorName', v),
      ));
    }

    if (p.containsKey('quote')) {
      fields.add(_TextField(
        label: 'Quote',
        value: p['quote']?.toString() ?? '',
        multiline: true,
        onChanged: (v) => editor.updateProperty(element.id, 'quote', v),
      ));
    }

    if (p.containsKey('question')) {
      fields.add(_TextField(
        label: 'Question',
        value: p['question']?.toString() ?? '',
        onChanged: (v) => editor.updateProperty(element.id, 'question', v),
      ));
    }

    if (p.containsKey('answer')) {
      fields.add(_TextField(
        label: 'Answer',
        value: p['answer']?.toString() ?? '',
        multiline: true,
        onChanged: (v) => editor.updateProperty(element.id, 'answer', v),
      ));
    }

    // Image picker
    if (p.containsKey('imageUrl')) {
      fields.add(_ImagePicker(
        currentUrl: p['imageUrl']?.toString() ?? '',
        onPicked: (path) => editor.updateProperty(element.id, 'imageUrl', path),
      ));
    }

    // Font size
    if (p.containsKey('fontSize')) {
      fields.add(_SliderField(
        label: 'Font Size',
        value: (p['fontSize'] as num?)?.toDouble() ?? 16.0,
        min: 10,
        max: 72,
        onChanged: (v) => editor.updateProperty(element.id, 'fontSize', v),
      ));
    }

    // Font weight
    if (p.containsKey('fontWeight')) {
      fields.add(_DropdownField(
        label: 'Font Weight',
        value: p['fontWeight']?.toString() ?? 'normal',
        options: const ['normal', 'medium', 'semibold', 'bold'],
        onChanged: (v) => editor.updateProperty(element.id, 'fontWeight', v),
      ));
    }

    // Text align
    if (p.containsKey('textAlign')) {
      fields.add(_DropdownField(
        label: 'Text Align',
        value: p['textAlign']?.toString() ?? 'left',
        options: const ['left', 'center', 'right'],
        onChanged: (v) => editor.updateProperty(element.id, 'textAlign', v),
      ));
    }

    // Colors
    for (final colorKey in ['color', 'backgroundColor', 'textColor', 'accentColor', 'iconColor']) {
      if (p.containsKey(colorKey)) {
        fields.add(_ColorField(
          label: _colorLabel(colorKey),
          value: p[colorKey]?.toString() ?? '#FFFFFF',
          onChanged: (v) => editor.updateProperty(element.id, colorKey, v),
        ));
      }
    }

    // Border radius
    if (p.containsKey('borderRadius')) {
      fields.add(_SliderField(
        label: 'Border Radius',
        value: (p['borderRadius'] as num?)?.toDouble() ?? 12.0,
        min: 0,
        max: 60,
        onChanged: (v) => editor.updateProperty(element.id, 'borderRadius', v),
      ));
    }

    // Button action
    if (p.containsKey('action')) {
      fields.add(_DropdownField(
        label: 'Button Action',
        value: p['action']?.toString() ?? 'none',
        options: const ['none', 'page', 'url', 'scroll', 'add-to-cart'],
        onChanged: (v) => editor.updateProperty(element.id, 'action', v),
      ));
      if (p['action'] == 'page' || p['action'] == 'url') {
        fields.add(_TextField(
          label: p['action'] == 'page' ? 'Page Name' : 'URL',
          value: p['actionTarget']?.toString() ?? '',
          onChanged: (v) => editor.updateProperty(element.id, 'actionTarget', v),
        ));
      }
    }

    // Size info
    fields.add(_SizeInfo(element: element, editor: editor));

    return fields;
  }

  String _colorLabel(String key) {
    switch (key) {
      case 'color': return 'Text Color';
      case 'backgroundColor': return 'Background Color';
      case 'textColor': return 'Text Color';
      case 'accentColor': return 'Accent Color';
      case 'iconColor': return 'Icon Color';
      default: return 'Color';
    }
  }
}

class _TextField extends StatefulWidget {
  final String label;
  final String value;
  final bool multiline;
  final ValueChanged<String> onChanged;

  const _TextField({
    required this.label,
    required this.value,
    required this.onChanged,
    this.multiline = false,
  });

  @override
  State<_TextField> createState() => _TextFieldState();
}

class _TextFieldState extends State<_TextField> {
  late TextEditingController _c;

  @override
  void initState() {
    super.initState();
    _c = TextEditingController(text: widget.value);
  }

  @override
  void didUpdateWidget(_TextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value && _c.text != widget.value) {
      _c.text = widget.value;
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextField(
        controller: _c,
        maxLines: widget.multiline ? 3 : 1,
        decoration: InputDecoration(labelText: widget.label),
        style: const TextStyle(color: Colors.white, fontSize: 14),
        onChanged: widget.onChanged,
      ),
    );
  }
}

class _SliderField extends StatelessWidget {
  final String label;
  final double value;
  final double min;
  final double max;
  final ValueChanged<double> onChanged;

  const _SliderField({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(label, style: const TextStyle(color: Colors.white60, fontSize: 12)),
              const Spacer(),
              Text(value.toStringAsFixed(0), style: const TextStyle(color: Colors.white, fontSize: 12)),
            ],
          ),
          Slider(
            value: value.clamp(min, max),
            min: min,
            max: max,
            activeColor: const Color(0xFF7C3AED),
            inactiveColor: Colors.white12,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

class _DropdownField extends StatelessWidget {
  final String label;
  final String value;
  final List<String> options;
  final ValueChanged<String?> onChanged;

  const _DropdownField({
    required this.label,
    required this.value,
    required this.options,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final safeValue = options.contains(value) ? value : options.first;
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.white60, fontSize: 12)),
          const SizedBox(height: 6),
          DropdownButtonFormField<String>(
            value: safeValue,
            items: options.map((o) => DropdownMenuItem(value: o, child: Text(o))).toList(),
            onChanged: onChanged,
            dropdownColor: const Color(0xFF1A1A2E),
            style: const TextStyle(color: Colors.white, fontSize: 14),
            decoration: const InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8)),
          ),
        ],
      ),
    );
  }
}

class _ColorField extends StatelessWidget {
  final String label;
  final String value;
  final ValueChanged<String> onChanged;

  const _ColorField({required this.label, required this.value, required this.onChanged});

  Color get _color {
    try { return Color(int.parse(value.replaceAll('#', '0xFF'))); } catch (_) { return Colors.white; }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => _showPicker(context),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _color,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.white.withOpacity(0.2)),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(color: Colors.white60, fontSize: 12)),
                Text(value, style: const TextStyle(color: Colors.white, fontSize: 13)),
              ],
            ),
          ),
          TextButton(
            onPressed: () => _showPicker(context),
            child: const Text('Change'),
          ),
        ],
      ),
    );
  }

  void _showPicker(BuildContext context) {
    Color picked = _color;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF12122A),
        title: Text(label),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: _color,
            onColorChanged: (c) => picked = c,
            enableAlpha: false,
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final hex = '#${picked.value.toRadixString(16).substring(2).toUpperCase()}';
              onChanged(hex);
              Navigator.pop(ctx);
            },
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }
}

class _ImagePicker extends StatelessWidget {
  final String currentUrl;
  final ValueChanged<String> onPicked;

  const _ImagePicker({required this.currentUrl, required this.onPicked});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Image', style: TextStyle(color: Colors.white60, fontSize: 12)),
          const SizedBox(height: 8),
          Row(
            children: [
              if (currentUrl.isNotEmpty)
                Container(
                  width: 60,
                  height: 60,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white10,
                    image: currentUrl.startsWith('/')
                        ? DecorationImage(image: FileImage(File(currentUrl)), fit: BoxFit.cover, onError: (_, __) {})
                        : null,
                  ),
                  child: currentUrl.isEmpty ? const Icon(Icons.image_outlined, color: Colors.white30) : null,
                ),
              Wrap(
                spacing: 8,
                children: [
                  OutlinedButton.icon(
                    onPressed: () => _pick(context, img_picker.ImageSource.gallery),
                    icon: const Icon(Icons.photo_library_outlined, size: 16),
                    label: const Text('Gallery'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white70,
                      side: const BorderSide(color: Colors.white24),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                  ),
                  OutlinedButton.icon(
                    onPressed: () => _pick(context, img_picker.ImageSource.camera),
                    icon: const Icon(Icons.camera_alt_outlined, size: 16),
                    label: const Text('Camera'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white70,
                      side: const BorderSide(color: Colors.white24),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _pick(BuildContext context, img_picker.ImageSource source) async {
    final picker = img_picker.ImagePicker();
    final picked = await picker.pickImage(source: source, maxWidth: 1200, imageQuality: 80);
    if (picked != null) onPicked(picked.path);
  }
}

class _SizeInfo extends StatelessWidget {
  final PageElement element;
  final EditorProvider editor;

  const _SizeInfo({required this.element, required this.editor});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Position & Size', style: TextStyle(color: Colors.white60, fontSize: 12)),
          const SizedBox(height: 8),
          Row(
            children: [
              _InfoChip('X', element.x.toStringAsFixed(0)),
              const SizedBox(width: 8),
              _InfoChip('Y', element.y.toStringAsFixed(0)),
              const SizedBox(width: 8),
              _InfoChip('W', element.width.toStringAsFixed(0)),
              const SizedBox(width: 8),
              _InfoChip('H', element.height.toStringAsFixed(0)),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final String label;
  final String value;
  const _InfoChip(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFF12122A),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Text(label, style: const TextStyle(color: Colors.white38, fontSize: 10)),
            const SizedBox(height: 2),
            Text(value, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}

