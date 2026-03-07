import 'dart:convert';
import 'package:flutter/foundation.dart' show ChangeNotifier, compute;
import '../models/website_project.dart';
import '../services/project_service.dart';
import '../templates/ecommerce_template.dart';
import '../templates/portfolio_template.dart';
import '../templates/blog_template.dart';
import '../templates/landing_page_template.dart';
import '../templates/business_template.dart';
import '../templates/restaurant_template.dart';

class ProjectProvider extends ChangeNotifier {
  final ProjectService _service = ProjectService();
  List<WebsiteProject> _projects = [];
  bool _loading = true;

  List<WebsiteProject> get projects => _projects;
  bool get loading => _loading;

  ProjectProvider() {
    _loadProjects();
  }

  Future<void> _loadProjects() async {
    _loading = true;
    notifyListeners();
    _projects = await _service.listProjects();
    _loading = false;
    notifyListeners();
  }

  Future<WebsiteProject> createProject(String name, String category) async {
    // Run ALL heavy work in a background isolate:
    // - Template object creation (many UUIDs)
    // - JSON serialisation (can be 50-200KB for large templates)
    final result = await compute(_buildAndSerialise, {'name': name, 'category': category});
    final project = WebsiteProject.fromJson(
      jsonDecode(result['json']!) as Map<String, dynamic>,
    );
    // Save using the pre-encoded JSON — no encoding on the main thread
    await _service.saveProjectJson(
      project: project,
      encodedJson: result['json']!,
    );
    _projects.insert(0, project);
    notifyListeners();
    return project;
  }

  Future<void> updateProject(WebsiteProject project) async {
    final idx = _projects.indexWhere((p) => p.id == project.id);
    if (idx != -1) {
      _projects[idx] = project;
      await _service.saveProject(project);
      notifyListeners();
    }
  }

  Future<void> deleteProject(String projectId) async {
    _projects.removeWhere((p) => p.id == projectId);
    await _service.deleteProject(projectId);
    notifyListeners();
  }

  Future<void> renameProject(String projectId, String newName) async {
    final idx = _projects.indexWhere((p) => p.id == projectId);
    if (idx != -1) {
      _projects[idx] = _projects[idx].copyWith(name: newName);
      await _service.saveProject(_projects[idx]);
      notifyListeners();
    }
  }

  Future<void> refresh() => _loadProjects();
}

/// Top-level function — runs in a background isolate via compute().
/// Builds the template AND serialises it to JSON so the main thread
/// never has to do any heavy CPU work.
Map<String, String> _buildAndSerialise(Map<String, String> args) {
  final name = args['name']!;
  final category = args['category']!;
  final WebsiteProject project;
  switch (category) {
    case 'E-Commerce':
      project = EcommerceTemplate.create(name);
      break;
    case 'Portfolio':
      project = PortfolioTemplate.create(name);
      break;
    case 'Blog':
      project = BlogTemplate.create(name);
      break;
    case 'Landing Page':
      project = LandingPageTemplate.create(name);
      break;
    case 'Business':
      project = BusinessTemplate.create(name);
      break;
    case 'Restaurant':
      project = RestaurantTemplate.create(name);
      break;
    default:
      project = BusinessTemplate.create(name);
  }
  // Serialise here in the background — never on the main thread
  return {'json': jsonEncode(project.toJson())};
}
