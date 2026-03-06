import 'package:flutter/foundation.dart';
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
    WebsiteProject project;
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
        break;
    }
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
