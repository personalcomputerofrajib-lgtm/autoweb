import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/website_project.dart';

class ProjectService {
  static final ProjectService _instance = ProjectService._internal();
  factory ProjectService() => _instance;
  ProjectService._internal();

  Database? _db;

  Future<void> initialize() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'site_builder.db');
    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE projects (
            id TEXT PRIMARY KEY,
            name TEXT NOT NULL,
            category TEXT NOT NULL,
            createdAt TEXT NOT NULL,
            updatedAt TEXT NOT NULL,
            thumbnailPath TEXT,
            data TEXT NOT NULL
          )
        ''');
      },
    );
  }

  Database get _database {
    if (_db == null) throw StateError('ProjectService not initialized');
    return _db!;
  }

  Future<void> saveProject(WebsiteProject project) async {
    final json = project.toJson();
    await _database.insert(
      'projects',
      {
        'id': project.id,
        'name': project.name,
        'category': project.category,
        'createdAt': project.createdAt.toIso8601String(),
        'updatedAt': project.updatedAt.toIso8601String(),
        'thumbnailPath': project.thumbnailPath,
        'data': jsonEncode(json),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<WebsiteProject?> loadProject(String id) async {
    final rows = await _database.query(
      'projects',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    final data = jsonDecode(rows.first['data'] as String) as Map<String, dynamic>;
    return WebsiteProject.fromJson(data);
  }

  Future<List<WebsiteProject>> listProjects() async {
    final rows = await _database.query(
      'projects',
      orderBy: 'updatedAt DESC',
    );
    return rows.map((row) {
      final data = jsonDecode(row['data'] as String) as Map<String, dynamic>;
      return WebsiteProject.fromJson(data);
    }).toList();
  }

  Future<void> deleteProject(String id) async {
    await _database.delete('projects', where: 'id = ?', whereArgs: [id]);
  }
}
