import 'package:flutter/material.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final TextEditingController _searchController = TextEditingController();

  // 模拟的搜索历史记录数据
  List<String> _historyKeywords = ['红烧肉', '东北菜', '锅包肉', '川菜', '宫保鸡丁'];

  // 模拟的所有菜谱数据库
  final List<String> _allRecipes = [
    '红烧肉', '东坡肉', '东北大拉皮', '锅包肉', '台湾卤肉饭',
    '赤峰对夹', '北京烤鸭', '麻婆豆腐', '水煮肉片', '四川火锅'
  ];

  // 当前搜索结果
  List<String> _searchResults = [];

  // 是否已经触发了搜索
  bool _isSearched = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // 执行搜索逻辑
  void _handleSearch(String keyword) {
    if (keyword.trim().isEmpty) return;

    setState(() {
      _searchController.text = keyword;
      // 1. 更新搜索结果（模糊匹配）
      _searchResults = _allRecipes
          .where((recipe) => recipe.contains(keyword.trim()))
          .toList();

      // 2. 更新历史记录：去重并将最新搜索词放到最前面
      _historyKeywords.remove(keyword);
      _historyKeywords.insert(0, keyword);

      _isSearched = true;
    });
  }

  // 清除历史记录
  void _clearHistory() {
    setState(() {
      _historyKeywords.clear();
    });
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
        // 顶部搜索输入框
        title: Container(
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0xfff3f3f5),
            borderRadius: BorderRadius.circular(20),
          ),
          child: TextField(
            controller: _searchController,
            textInputAction: TextInputAction.search,
            onSubmitted: _handleSearch, // 键盘点击搜索/回车时触发
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
                  });
                },
              )
                  : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 9),
            ),
            onChanged: (value) {
              if (value.isEmpty) {
                setState(() => _isSearched = false);
              }
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => _handleSearch(_searchController.text),
            child: const Text('搜索', style: TextStyle(color: Colors.orange, fontSize: 16)),
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(), // 点击空白处收起键盘
        child: _isSearched ? _buildSearchResults() : _buildHistorySection(),
      ),
    );
  }

  // 布局 1：搜索历史区域
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
          // 历史记录头部
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
          // 历史流式标签布局
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
                  child: Text(
                    keyword,
                    style: const TextStyle(color: Colors.black87, fontSize: 13),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // 布局 2：搜索结果列表区域
  Widget _buildSearchResults() {
    if (_searchResults.isEmpty) {
      return const Center(
        child: Text('未找到相关菜谱', style: TextStyle(color: Colors.grey, fontSize: 15)),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _searchResults.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final result = _searchResults[index];
        return ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(Icons.restaurant_menu, color: Colors.orangeAccent),
          title: Text(
            result,
            style: const TextStyle(fontSize: 15, color: Colors.black87),
          ),
          trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
          onTap: () {
            // 这里可以处理点击搜索结果，跳转到菜谱详情页
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('点击了菜谱: $result')),
            );
          },
        );
      },
    );
  }
}