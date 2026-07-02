import 'package:flutter/material.dart';
import 'package:fondia/api/search.dart';
import 'package:fondia/models/recipe_models.dart';
import 'package:fondia/pages/CategoryDetail/DishDetail.dart';
import 'package:fondia/utils/recipe_image.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  static const _historyKey = 'search_history_keywords';

  final TextEditingController _searchController = TextEditingController();

  List<String> _historyKeywords = [];
  List<RecipeListItem> _searchResults = [];
  bool _isSearched = false;
  bool _loading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _historyKeywords = prefs.getStringList(_historyKey) ?? [];
    });
  }

  Future<void> _saveHistory(String keyword) async {
    final prefs = await SharedPreferences.getInstance();
    _historyKeywords.remove(keyword);
    _historyKeywords.insert(0, keyword);
    if (_historyKeywords.length > 10) {
      _historyKeywords = _historyKeywords.sublist(0, 10);
    }
    await prefs.setStringList(_historyKey, _historyKeywords);
  }

  Future<void> _handleSearch(String keyword) async {
    final text = keyword.trim();
    if (text.isEmpty || _loading) return;

    setState(() {
      _searchController.text = text;
      _loading = true;
      _error = null;
      _isSearched = true;
    });

    try {
      final page = await SearchApi.searchRecipes(keyword: text);
      await _saveHistory(text);
      if (!mounted) return;
      setState(() {
        _searchResults = page.records;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = e.toString().replaceFirst('Exception: ', '');
        _searchResults = [];
      });
    }
  }

  void _clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_historyKey);
    setState(() => _historyKeywords.clear());
  }

  void _openRecipe(String recipeId) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => DishDetail(recipeId: recipeId)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfffcfafc),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black87, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Container(
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0xfff3f3f5),
            borderRadius: BorderRadius.circular(20),
          ),
          child: TextField(
            controller: _searchController,
            textInputAction: TextInputAction.search,
            onSubmitted: _handleSearch,
            style: const TextStyle(fontSize: 14),
            decoration: InputDecoration(
              hintText: '搜索菜谱、食材、菜系',
              hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
              prefixIcon: const Icon(Icons.search, color: Colors.grey, size: 20),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.cancel, color: Colors.grey, size: 18),
                      onPressed: () {
                        setState(() {
                          _searchController.clear();
                          _isSearched = false;
                          _searchResults = [];
                          _error = null;
                        });
                      },
                    )
                  : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 9),
            ),
            onChanged: (value) {
              setState(() {});
              if (value.isEmpty) {
                setState(() {
                  _isSearched = false;
                  _searchResults = [];
                  _error = null;
                });
              }
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: _loading ? null : () => _handleSearch(_searchController.text),
            child: Text(
              '搜索',
              style: TextStyle(color: _loading ? Colors.grey : Colors.orange, fontSize: 16),
            ),
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: _isSearched ? _buildSearchResults() : _buildHistorySection(),
      ),
    );
  }

  Widget _buildHistorySection() {
    if (_historyKeywords.isEmpty) {
      return const Center(
        child: Text('没有搜索历史', style: TextStyle(color: Colors.grey)),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '搜索历史',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.grey, size: 20),
                onPressed: _clearHistory,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: _historyKeywords.map((keyword) {
              return InkWell(
                onTap: () => _handleSearch(keyword),
                borderRadius: BorderRadius.circular(15),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xfff3f3f5),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text(keyword, style: const TextStyle(color: Colors.black87, fontSize: 13)),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator(color: Colors.orange));
    }
    if (_error != null) {
      return Center(
        child: Text(_error!, style: const TextStyle(color: Colors.grey, fontSize: 14)),
      );
    }
    if (_searchResults.isEmpty) {
      return const Center(
        child: Text('未找到相关菜谱', style: TextStyle(color: Colors.grey, fontSize: 15)),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _searchResults.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final item = _searchResults[index];
        return ListTile(
          contentPadding: EdgeInsets.zero,
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              width: 48,
              height: 48,
              child: RecipeImage(url: item.coverImage, fit: BoxFit.cover),
            ),
          ),
          title: Text(item.title, style: const TextStyle(fontSize: 15, color: Colors.black87)),
          subtitle: Text(
            [item.cuisineName, item.subtitle].where((e) => e != null && e.isNotEmpty).join(' · '),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
          trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
          onTap: () => _openRecipe(item.id),
        );
      },
    );
  }
}
