import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/project_provider.dart';
import '../../providers/editor_provider.dart';

class CategoryPickerScreen extends StatefulWidget {
  const CategoryPickerScreen({super.key});

  @override
  State<CategoryPickerScreen> createState() => _CategoryPickerScreenState();
}

class _CategoryPickerScreenState extends State<CategoryPickerScreen> {
  String? _selectedCategory;
  final _nameController = TextEditingController();
  bool _creating = false;

  final List<_CategoryInfo> _categories = const [
    _CategoryInfo(
      name: 'E-Commerce',
      icon: Icons.shopping_bag_outlined,
      description: 'Sell products online with cart, checkout & payment flows',
      emoji: '🛍️',
      color: Color(0xFF7C3AED),
      features: ['Product listings', 'Shopping cart', 'Checkout flow', 'Login system'],
    ),
    _CategoryInfo(
      name: 'Portfolio',
      icon: Icons.person_outline,
      description: 'Showcase your work, skills and attract clients',
      emoji: '🎨',
      color: Color(0xFF06B6D4),
      features: ['Hero section', 'Project gallery', 'Skills section', 'Contact form'],
    ),
    _CategoryInfo(
      name: 'Blog',
      icon: Icons.article_outlined,
      description: 'Share your stories, ideas and build your audience',
      emoji: '✍️',
      color: Color(0xFFF59E0B),
      features: ['Post listings', 'Article pages', 'Author profile', 'Categories'],
    ),
    _CategoryInfo(
      name: 'Landing Page',
      icon: Icons.rocket_launch_outlined,
      description: 'Convert visitors with a focused single-page site',
      emoji: '🚀',
      color: Color(0xFF10B981),
      features: ['Hero section', 'Feature grid', 'Pricing cards', 'Testimonials'],
    ),
    _CategoryInfo(
      name: 'Business',
      icon: Icons.business_outlined,
      description: 'Professional site for your company or agency',
      emoji: '🏢',
      color: Color(0xFF3B82F6),
      features: ['Services page', 'Team profiles', 'FAQ section', 'Contact form'],
    ),
    _CategoryInfo(
      name: 'Restaurant',
      icon: Icons.restaurant_outlined,
      description: 'Menu, reservations and location for your restaurant',
      emoji: '🍽️',
      color: Color(0xFFD97706),
      features: ['Menu accordion', 'Dish gallery', 'Table reservations', 'Map location'],
    ),
  ];

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Website'),
        leading: const BackButton(),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Choose a category',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'We\'ll load the right structure and pre-built components for you',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final cat = _categories[index];
                  final selected = _selectedCategory == cat.name;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedCategory = cat.name),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: selected
                            ? cat.color.withOpacity(0.12)
                            : const Color(0xFF12122A),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: selected ? cat.color : Colors.white.withOpacity(0.06),
                          width: selected ? 2 : 1,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Container(
                              width: 52,
                              height: 52,
                              decoration: BoxDecoration(
                                color: cat.color.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Center(
                                child: Text(cat.emoji, style: const TextStyle(fontSize: 24)),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    cat.name,
                                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: selected ? cat.color : Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    cat.description,
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Theme.of(context).colorScheme.onSurface,
                                    ),
                                  ),
                                  if (selected) ...[
                                    const SizedBox(height: 8),
                                    Wrap(
                                      spacing: 6,
                                      runSpacing: 4,
                                      children: cat.features.map((f) => Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                        decoration: BoxDecoration(
                                          color: cat.color.withOpacity(0.15),
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Text(f, style: TextStyle(fontSize: 11, color: cat.color, fontWeight: FontWeight.w500)),
                                      )).toList(),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            if (selected)
                              Icon(Icons.check_circle, color: cat.color, size: 22),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            if (_selectedCategory != null) _buildBottomBar(context),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    final cat = _categories.firstWhere((c) => c.name == _selectedCategory);
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
      decoration: BoxDecoration(
        color: const Color(0xFF12122A),
        border: Border(top: BorderSide(color: Colors.white.withOpacity(0.08))),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: 'Site Name',
              hintText: 'e.g. My Awesome Store',
              prefixIcon: const Icon(Icons.edit_outlined, size: 18),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _creating ? null : () => _createProject(context),
              style: ElevatedButton.styleFrom(backgroundColor: cat.color),
              child: _creating
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                  : Text('Create ${_selectedCategory} Site →'),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _createProject(BuildContext context) async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a site name')),
      );
      return;
    }
    setState(() => _creating = true);
    try {
      final project = await context.read<ProjectProvider>().createProject(name, _selectedCategory!);
      if (!mounted) return;
      context.read<EditorProvider>().loadProject(project);
      Navigator.pushReplacementNamed(context, '/editor');
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to create site: $e')),
      );
    } finally {
      if (mounted) setState(() => _creating = false);
    }
  }
}

class _CategoryInfo {
  final String name;
  final IconData icon;
  final String description;
  final String emoji;
  final Color color;
  final List<String> features;

  const _CategoryInfo({
    required this.name,
    required this.icon,
    required this.description,
    required this.emoji,
    required this.color,
    required this.features,
  });
}
