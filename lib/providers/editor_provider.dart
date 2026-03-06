import 'package:flutter/foundation.dart';
import '../models/page_element.dart';
import '../models/website_project.dart';
import '../models/element_type.dart';

class EditorProvider extends ChangeNotifier {
  WebsiteProject? _project;
  String? _selectedElementId;
  int _currentPageIndex = 0;
  final List<List<PageElement>> _undoStack = [];
  final List<List<PageElement>> _redoStack = [];
  bool _showPropertyPanel = false;

  WebsiteProject? get project => _project;
  String? get selectedElementId => _selectedElementId;
  int get currentPageIndex => _currentPageIndex;
  bool get showPropertyPanel => _showPropertyPanel;

  SitePage? get currentPage =>
      (_project != null && _currentPageIndex < _project!.pages.length)
          ? _project!.pages[_currentPageIndex]
          : null;

  List<PageElement> get currentElements => currentPage?.elements ?? [];

  PageElement? get selectedElement => _selectedElementId == null
      ? null
      : currentElements
          .cast<PageElement?>()
          .firstWhere((e) => e?.id == _selectedElementId, orElse: () => null);

  void loadProject(WebsiteProject project) {
    _project = project;
    _currentPageIndex = 0;
    _selectedElementId = null;
    _showPropertyPanel = false;
    _undoStack.clear();
    _redoStack.clear();
    notifyListeners();
  }

  void selectElement(String? id) {
    _selectedElementId = id;
    _showPropertyPanel = id != null;
    notifyListeners();
  }

  void deselectAll() {
    _selectedElementId = null;
    _showPropertyPanel = false;
    notifyListeners();
  }

  void switchPage(int index) {
    _currentPageIndex = index;
    _selectedElementId = null;
    _showPropertyPanel = false;
    notifyListeners();
  }

  void _snapshot() {
    _undoStack.add(currentElements.map((e) => e.copyWith()).toList());
    if (_undoStack.length > 30) _undoStack.removeAt(0);
    _redoStack.clear();
  }

  void undo() {
    if (_undoStack.isEmpty) return;
    _redoStack.add(currentElements.map((e) => e.copyWith()).toList());
    currentPage?.elements = _undoStack.removeLast();
    _selectedElementId = null;
    notifyListeners();
  }

  void redo() {
    if (_redoStack.isEmpty) return;
    _undoStack.add(currentElements.map((e) => e.copyWith()).toList());
    currentPage?.elements = _redoStack.removeLast();
    notifyListeners();
  }

  void addElement(ElementType type) {
    _snapshot();
    final el = PageElement(
      elementType: type,
      x: 20,
      y: 80.0 + (currentElements.length * 10.0),
      width: _defaultWidth(type),
      height: _defaultHeight(type),
    );
    currentPage?.elements.add(el);
    _selectedElementId = el.id;
    _showPropertyPanel = true;
    notifyListeners();
  }

  double _defaultWidth(ElementType type) {
    switch (type) {
      case ElementType.navbar:
      case ElementType.hero:
      case ElementType.footer:
        return 390;
      case ElementType.divider:
        return 350;
      case ElementType.cartButton:
      case ElementType.spacer:
        return 56;
      case ElementType.button:
      case ElementType.contactForm:
      case ElementType.featureCard:
      case ElementType.teamCard:
      case ElementType.testimonial:
      case ElementType.blogPostCard:
      case ElementType.faqItem:
        return 370;
      case ElementType.productCard:
      case ElementType.pricingCard:
      case ElementType.statsCounter:
        return 175;
      default:
        return 350;
    }
  }

  double _defaultHeight(ElementType type) {
    switch (type) {
      case ElementType.navbar: return 60;
      case ElementType.hero: return 300;
      case ElementType.footer: return 110;
      case ElementType.productCard: return 260;
      case ElementType.pricingCard: return 280;
      case ElementType.contactForm: return 380;
      case ElementType.testimonial: return 140;
      case ElementType.blogPostCard: return 180;
      case ElementType.featureCard: return 100;
      case ElementType.teamCard: return 140;
      case ElementType.faqItem: return 100;
      case ElementType.heading: return 50;
      case ElementType.text: return 80;
      case ElementType.image: return 200;
      case ElementType.button: return 54;
      case ElementType.divider: return 1;
      case ElementType.spacer: return 40;
      case ElementType.cartButton: return 56;
      case ElementType.socialLinks: return 50;
      case ElementType.section: return 200;
      case ElementType.video: return 220;
      case ElementType.map: return 200;
      case ElementType.countdown: return 180;
      case ElementType.gallery: return 300;
      case ElementType.accordion: return 260;
      case ElementType.statsCounter: return 130;
    }
  }

  void moveElement(String id, double dx, double dy) {
    final idx = currentElements.indexWhere((e) => e.id == id);
    if (idx == -1) return;
    currentElements[idx].x += dx;
    currentElements[idx].y += dy;
    if (currentElements[idx].x < 0) currentElements[idx].x = 0;
    if (currentElements[idx].y < 0) currentElements[idx].y = 0;
    notifyListeners();
  }

  void resizeElement(String id, double dw, double dh) {
    final idx = currentElements.indexWhere((e) => e.id == id);
    if (idx == -1) return;
    currentElements[idx].width = (currentElements[idx].width + dw).clamp(60, 800);
    currentElements[idx].height = (currentElements[idx].height + dh).clamp(20, 2000);
    notifyListeners();
  }

  void updateProperty(String elementId, String key, dynamic value) {
    final idx = currentElements.indexWhere((e) => e.id == elementId);
    if (idx == -1) return;
    if (currentElements[idx].properties[key] != value) {
      currentElements[idx].properties[key] = value;
      notifyListeners();
    }
  }

  void deleteElement(String id) {
    _snapshot();
    currentPage?.elements.removeWhere((e) => e.id == id);
    _selectedElementId = null;
    _showPropertyPanel = false;
    notifyListeners();
  }

  void duplicateElement(String id) {
    _snapshot();
    final orig = currentElements.firstWhere(
      (e) => e.id == id,
      orElse: () => throw StateError('element not found'),
    );
    final copy = PageElement(
      elementType: orig.elementType,
      x: orig.x + 20,
      y: orig.y + 20,
      width: orig.width,
      height: orig.height,
      properties: Map.from(orig.properties),
    );
    currentPage?.elements.add(copy);
    _selectedElementId = copy.id;
    notifyListeners();
  }

  void bringToFront(String id) {
    _snapshot();
    final idx = currentElements.indexWhere((e) => e.id == id);
    if (idx != -1) {
      final el = currentElements.removeAt(idx);
      currentPage?.elements.add(el);
      notifyListeners();
    }
  }

  void sendToBack(String id) {
    _snapshot();
    final idx = currentElements.indexWhere((e) => e.id == id);
    if (idx != -1) {
      final el = currentElements.removeAt(idx);
      currentPage?.elements.insert(0, el);
      notifyListeners();
    }
  }

  void addPage(String name) {
    _project?.pages.add(SitePage(name: name));
    notifyListeners();
  }

  bool get canUndo => _undoStack.isNotEmpty;
  bool get canRedo => _redoStack.isNotEmpty;
}
