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
    // Run template creation on a background isolate to avoid freezing the UI
    final project = await compute(_buildTemplate, {'name': name, 'category': category});
    await _service.saveProject(project);
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

/// Top-level function required by compute() — runs in a background isolate.
WebsiteProject _buildTemplate(Map<String, String> args) {
  final name = args['name']!;
  final category = args['category']!;
  switch (category) {
    case 'E-Commerce':
      return EcommerceTemplate.create(name);
    case 'Portfolio':
      return PortfolioTemplate.create(name);
    case 'Blog':
      return BlogTemplate.create(name);
    case 'Landing Page':
      return LandingPageTemplate.create(name);
    case 'Business':
      return BusinessTemplate.create(name);
    case 'Restaurant':
      return RestaurantTemplate.create(name);
    default:
      return BusinessTemplate.create(name);
  }
}
