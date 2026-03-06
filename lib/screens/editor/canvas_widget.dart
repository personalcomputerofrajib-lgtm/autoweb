import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/editor_provider.dart';
import '../../widgets/elements/element_renderer.dart';

class CanvasWidget extends StatefulWidget {
  const CanvasWidget({super.key});

  @override
  State<CanvasWidget> createState() => _CanvasWidgetState();
}

class _CanvasWidgetState extends State<CanvasWidget> {
  final TransformationController _transformationController = TransformationController();

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final editor = context.watch<EditorProvider>();
    final elements = editor.currentElements;
    final bgColor = _parseColor(editor.currentPage?.backgroundColor ?? '#0A0A1A');

    return GestureDetector(
      onTap: () => editor.deselectAll(),
      child: Container(
        color: bgColor,
        child: InteractiveViewer(
          transformationController: _transformationController,
          minScale: 0.4,
          maxScale: 2.5,
          constrained: false,
          child: Container(
            width: 390,
            color: bgColor,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // Canvas grid hint
                Positioned.fill(
                  child: CustomPaint(painter: _GridPainter()),
                ),
                // Elements
                ...elements.map((element) {
                  final isSelected = element.id == editor.selectedElementId;
                  return Positioned(
                    left: element.x,
                    top: element.y,
                    width: element.width,
                    height: element.height,
                    child: _DraggableElement(
                      elementId: element.id,
                      isSelected: isSelected,
                      child: ElementRenderer(element: element),
                    ),
                  );
                }),
                // Minimum canvas height to allow scrolling
                Positioned(
                  left: 0,
                  top: 0,
                  child: SizedBox(
                    width: 390,
                    height: _calculateTotalHeight(elements) + 200,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  double _calculateTotalHeight(elements) {
    if (elements.isEmpty) return 600;
    double maxY = 0;
    for (final el in elements) {
      final bottom = el.y + el.height;
      if (bottom > maxY) maxY = bottom;
    }
    return maxY;
  }

  Color _parseColor(String hex) {
    try {
      return Color(int.parse(hex.replaceAll('#', '0xFF')));
    } catch (_) {
      return const Color(0xFF0A0A1A);
    }
  }
}

class _DraggableElement extends StatefulWidget {
  final String elementId;
  final bool isSelected;
  final Widget child;

  const _DraggableElement({
    required this.elementId,
    required this.isSelected,
    required this.child,
  });

  @override
  State<_DraggableElement> createState() => _DraggableElementState();
}

class _DraggableElementState extends State<_DraggableElement> {
  Offset _dragStart = Offset.zero;
  bool _dragging = false;

  @override
  Widget build(BuildContext context) {
    final editor = context.read<EditorProvider>();

    return GestureDetector(
      onTap: () => editor.selectElement(widget.elementId),
      onPanStart: (details) {
        editor.selectElement(widget.elementId);
        _dragStart = details.localPosition;
        _dragging = true;
      },
      onPanUpdate: (details) {
        if (!_dragging) return;
        final delta = details.localPosition - _dragStart;
        editor.moveElement(widget.elementId, delta.dx, delta.dy);
        _dragStart = details.localPosition;
      },
      onPanEnd: (_) => _dragging = false,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Element content
          Container(
            decoration: widget.isSelected
                ? BoxDecoration(
                    border: Border.all(color: const Color(0xFF7C3AED), width: 2),
                    borderRadius: BorderRadius.circular(4),
                  )
                : null,
            child: widget.child,
          ),

          // Selection handles
          if (widget.isSelected) ..._buildHandles(context, editor),
        ],
      ),
    );
  }

  List<Widget> _buildHandles(BuildContext context, EditorProvider editor) {
    return [
      // Context menu bar above element
      Positioned(
        top: -38,
        left: 0,
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF7C3AED),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _iconBtn(Icons.delete_outline, () => editor.deleteElement(widget.elementId)),
              _iconBtn(Icons.copy_outlined, () => editor.duplicateElement(widget.elementId)),
              _iconBtn(Icons.arrow_upward, () => editor.bringToFront(widget.elementId)),
              _iconBtn(Icons.arrow_downward, () => editor.sendToBack(widget.elementId)),
            ],
          ),
        ),
      ),
      // Resize handle - bottom right
      Positioned(
        right: -10,
        bottom: -10,
        child: _ResizeHandle(elementId: widget.elementId),
      ),
    ];
  }

  Widget _iconBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Icon(icon, color: Colors.white, size: 16),
      ),
    );
  }
}

class _ResizeHandle extends StatefulWidget {
  final String elementId;
  const _ResizeHandle({required this.elementId});

  @override
  State<_ResizeHandle> createState() => _ResizeHandleState();
}

class _ResizeHandleState extends State<_ResizeHandle> {
  Offset _last = Offset.zero;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: (d) => _last = d.globalPosition,
      onPanUpdate: (d) {
        final delta = d.globalPosition - _last;
        context.read<EditorProvider>().resizeElement(widget.elementId, delta.dx, delta.dy);
        _last = d.globalPosition;
      },
      child: Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          color: const Color(0xFF7C3AED),
          border: Border.all(color: Colors.white, width: 2),
          borderRadius: BorderRadius.circular(4),
        ),
        child: const Icon(Icons.open_with, color: Colors.white, size: 10),
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.03)
      ..strokeWidth = 1;
    const step = 20.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(_) => false;
}
