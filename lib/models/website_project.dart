import 'package:uuid/uuid.dart';
import 'page_element.dart';

class SitePage {
  final String id;
  String name;
  List<PageElement> elements;
  String backgroundColor;

  SitePage({
    String? id,
    required this.name,
    List<PageElement>? elements,
    this.backgroundColor = '#0A0A1A',
  })  : id = id ?? const Uuid().v4(),
        elements = elements ?? [];

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'elements': elements.map((e) => e.toJson()).toList(),
        'backgroundColor': backgroundColor,
      };

  factory SitePage.fromJson(Map<String, dynamic> json) => SitePage(
        id: json['id'],
        name: json['name'],
        backgroundColor: json['backgroundColor'] ?? '#0A0A1A',
        elements: (json['elements'] as List<dynamic>? ?? [])
            .map((e) => PageElement.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}

class WebsiteProject {
  final String id;
  String name;
  String category;
  DateTime createdAt;
  DateTime updatedAt;
  List<SitePage> pages;
  String? thumbnailPath;
  Map<String, dynamic> globalSettings;

  WebsiteProject({
    String? id,
    required this.name,
    required this.category,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<SitePage>? pages,
    this.thumbnailPath,
    Map<String, dynamic>? globalSettings,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now(),
        pages = pages ?? [],
        globalSettings = globalSettings ?? {} {
    if (this.globalSettings.isEmpty) {
      this.globalSettings = {
        'primaryColor': '#7C3AED',
        'fontFamily': 'Inter',
        'siteName': this.name,
        'favicon': '',
      };
    }
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'category': category,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
        'pages': pages.map((p) => p.toJson()).toList(),
        'thumbnailPath': thumbnailPath,
        'globalSettings': globalSettings,
      };

  factory WebsiteProject.fromJson(Map<String, dynamic> json) =>
      WebsiteProject(
        id: json['id'],
        name: json['name'],
        category: json['category'],
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']),
        thumbnailPath: json['thumbnailPath'],
        globalSettings: Map<String, dynamic>.from(json['globalSettings'] ?? {}),
        pages: (json['pages'] as List<dynamic>? ?? [])
            .map((p) => SitePage.fromJson(p as Map<String, dynamic>))
            .toList(),
      );

  WebsiteProject copyWith({
    String? name,
    String? category,
    List<SitePage>? pages,
    String? thumbnailPath,
    Map<String, dynamic>? globalSettings,
  }) {
    return WebsiteProject(
      id: id,
      name: name ?? this.name,
      category: category ?? this.category,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
      pages: pages ?? this.pages,
      thumbnailPath: thumbnailPath ?? this.thumbnailPath,
      globalSettings: globalSettings ?? this.globalSettings,
    );
  }
}
