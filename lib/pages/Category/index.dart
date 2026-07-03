import 'package:flutter/material.dart';
import 'package:fondia/api/cuisine.dart';
import 'package:fondia/l10n/app_localizations.dart';
import 'package:fondia/models/recipe_models.dart';
import 'package:fondia/pages/CategoryDetail/DishDetail.dart';
import 'package:fondia/pages/CategoryDetail/index.dart';
import 'package:fondia/utils/recipe_image.dart';

class CategoryView extends StatefulWidget {
  const CategoryView({super.key});

  @override
  State<CategoryView> createState() => _CategoryViewState();
}

class _CategoryViewState extends State<CategoryView> {
  List<CategoryBrief> _cuisines = [];
  CategoryTree? _tree;
  int _selectedIndex = 0;
  bool _loadingCuisines = true;
  bool _loadingTree = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadCuisines();
  }

  Future<void> _loadCuisines() async {
    setState(() {
      _loadingCuisines = true;
      _error = null;
    });
    try {
      final list = await CuisineApi.listAllCuisines();
      if (!mounted) return;
      setState(() {
        _cuisines = list;
        _loadingCuisines = false;
      });
      if (list.isNotEmpty) {
        _loadTree(list.first.id);
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loadingCuisines = false;
        _error = e.toString();
      });
    }
  }

  Future<void> _loadTree(String cuisineId) async {
    setState(() {
      _loadingTree = true;
      _error = null;
    });
    try {
      final tree = await CuisineApi.getCategoryTree(cuisineId);
      if (!mounted) return;
      setState(() {
        _tree = tree;
        _loadingTree = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loadingTree = false;
        _error = e.toString();
      });
    }
  }

  void _onSelectCuisine(int index) {
    if (index == _selectedIndex) return;
    setState(() => _selectedIndex = index);
    _loadTree(_cuisines[index].id);
  }

  void _openRecipeDetail(String recipeId) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => DishDetail(recipeId: recipeId)),
    );
  }

  void _openCuisineDetail(String cuisineId, {int? subType}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            CategoryDetailView(cuisineId: cuisineId, initialSubType: subType),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    if (_loadingCuisines) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: Colors.orange)),
      );
    }

    if (_cuisines.isEmpty) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(_error ?? l10n.noCuisineData),
              const SizedBox(height: 12),
              TextButton(onPressed: _loadCuisines, child: Text(l10n.retry)),
            ],
          ),
        ),
      );
    }

    final sections = _tree?.sections ?? [];

    return Scaffold(
      backgroundColor: Colors.white,
      body: Row(
        children: [
          Container(
            width: 100,
            color: Colors.grey[50],
            child: ListView.builder(
              itemCount: _cuisines.length,
              itemBuilder: (context, index) {
                final cuisine = _cuisines[index];
                final isSelected = index == _selectedIndex;
                return GestureDetector(
                  onTap: () => _onSelectCuisine(index),
                  onLongPress: () => _openCuisineDetail(cuisine.id),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 12,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.white : Colors.transparent,
                      border: isSelected
                          ? const Border(
                              left: BorderSide(color: Colors.orange, width: 4),
                            )
                          : null,
                    ),
                    child: Text(
                      cuisine.name,
                      style: TextStyle(
                        color: isSelected ? Colors.black : Colors.grey[600],
                        fontSize: 15,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: _loadingTree
                ? const Center(
                    child: CircularProgressIndicator(color: Colors.orange),
                  )
                : _error != null && sections.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(_error!),
                        TextButton(
                          onPressed: () =>
                              _loadTree(_cuisines[_selectedIndex].id),
                          child: Text(l10n.retry),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: sections.length,
                    itemBuilder: (context, index) {
                      final section = sections[index];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                section.title,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              GestureDetector(
                                onTap: () => _openCuisineDetail(
                                  _cuisines[_selectedIndex].id,
                                  subType: section.subType,
                                ),
                                child: Text(
                                  l10n.more,
                                  style: TextStyle(
                                    color: Colors.grey[500],
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 4,
                                  mainAxisExtent: 100,
                                  crossAxisSpacing: 12,
                                  mainAxisSpacing: 12,
                                ),
                            itemCount: section.recipes.length,
                            itemBuilder: (context, itemIndex) {
                              final item = section.recipes[itemIndex];
                              return GestureDetector(
                                onTap: () => _openRecipeDetail(item.id),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      width: 60,
                                      height: 60,
                                      child: RecipeImage(
                                        url: item.coverImage,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      item.title,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 24),
                        ],
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
