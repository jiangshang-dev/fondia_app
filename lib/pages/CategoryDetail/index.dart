import 'package:flutter/material.dart';
import 'package:fondia/api/cuisine.dart';
import 'package:fondia/models/recipe_models.dart';
import 'package:fondia/pages/CategoryDetail/DishDetail.dart';
import 'package:fondia/utils/recipe_image.dart';

class CategoryDetailView extends StatefulWidget {
  final int cuisineId;
  final int? initialSubType;

  const CategoryDetailView({
    super.key,
    required this.cuisineId,
    this.initialSubType,
  });

  @override
  State<CategoryDetailView> createState() => _CategoryDetailViewState();
}

class _CategoryDetailViewState extends State<CategoryDetailView>
    with TickerProviderStateMixin {
  late TabController _mainTabController;
  TabController? _tagTabController;

  CuisineDetail? _detail;
  List<RecipeListItem> _recipes = [];
  int? _selectedTagId;
  int _subType = 2;
  int _pageNo = 1;
  bool _hasMore = true;
  bool _loading = true;
  bool _loadingMore = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _subType = widget.initialSubType ?? 2;
    _mainTabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: _subType == 1 ? 1 : 0,
    );
    _mainTabController.addListener(_onMainTabChanged);
    _loadDetail();
    _loadRecipes(refresh: true);
  }

  @override
  void dispose() {
    _mainTabController.removeListener(_onMainTabChanged);
    _mainTabController.dispose();
    _tagTabController?.dispose();
    super.dispose();
  }

  void _onMainTabChanged() {
    if (_mainTabController.indexIsChanging) return;
    final subType = _mainTabController.index == 0 ? 2 : 1;
    if (subType != _subType) {
      setState(() => _subType = subType);
      _loadRecipes(refresh: true);
    }
  }

  void _initTagController(int length) {
    _tagTabController?.dispose();
    _tagTabController = TabController(length: length, vsync: this);
    _tagTabController!.addListener(() {
      if (_tagTabController!.indexIsChanging) return;
      final index = _tagTabController!.index;
      final tags = _detail?.filterTags ?? [];
      final tagId = index == 0 ? null : tags[index - 1].id;
      if (tagId != _selectedTagId) {
        setState(() => _selectedTagId = tagId);
        _loadRecipes(refresh: true);
      }
    });
  }

  Future<void> _loadDetail() async {
    try {
      final detail = await CuisineApi.getCuisineDetail(widget.cuisineId);
      if (!mounted) return;
      setState(() {
        _detail = detail;
        _initTagController(detail.filterTags.length + 1);
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = e.toString());
    }
  }

  Future<void> _loadRecipes({bool refresh = false}) async {
    if (refresh) {
      setState(() {
        _loading = true;
        _pageNo = 1;
        _hasMore = true;
        _error = null;
      });
    } else {
      if (!_hasMore || _loadingMore) return;
      setState(() => _loadingMore = true);
    }

    try {
      final page = await CuisineApi.pageRecipes(
        cuisineId: widget.cuisineId,
        subType: _subType,
        tagId: _selectedTagId,
        pageNo: refresh ? 1 : _pageNo,
        pageSize: 10,
      );
      if (!mounted) return;
      setState(() {
        if (refresh) {
          _recipes = page.records;
        } else {
          _recipes = [..._recipes, ...page.records];
        }
        _pageNo = page.current + 1;
        _hasMore = page.current < page.pages;
        _loading = false;
        _loadingMore = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _loadingMore = false;
        _error = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new,
              color: Colors.black54, size: 20),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.ios_share, color: Colors.black54),
            onPressed: () {},
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await _loadDetail();
          await _loadRecipes(refresh: true);
        },
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _buildHeaderCard()),
            SliverPersistentHeader(
              pinned: true,
              delegate: _SliverAppBarDelegate(
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      bottom: BorderSide(color: Color(0xFFF5F5F5), width: 1),
                    ),
                  ),
                  child: TabBar(
                    controller: _mainTabController,
                    tabs: const [Tab(text: '菜品'), Tab(text: '主食')],
                    labelColor: const Color(0xFFFF742D),
                    unselectedLabelColor: Colors.grey,
                    indicatorColor: const Color(0xFFFF742D),
                    indicatorSize: TabBarIndicatorSize.label,
                    labelStyle: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                    unselectedLabelStyle: const TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(child: _buildSectionTitle('菜品目录')),
            if (_tagTabController != null)
              SliverPersistentHeader(
                pinned: true,
                delegate: _SliverAppBarDelegate(
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: _buildCategoryFilter(),
                  ),
                ),
              ),
            if (_loading)
              const SliverFillRemaining(
                child: Center(
                  child: CircularProgressIndicator(color: Color(0xFFFF742D)),
                ),
              )
            else if (_error != null && _recipes.isEmpty)
              SliverFillRemaining(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(_error!),
                      TextButton(
                        onPressed: () => _loadRecipes(refresh: true),
                        child: const Text('重试'),
                      ),
                    ],
                  ),
                ),
              )
            else
              SliverPadding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.72,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => _buildDishItem(_recipes[index]),
                    childCount: _recipes.length,
                  ),
                ),
              ),
            SliverToBoxAdapter(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: _loadingMore
                      ? const CircularProgressIndicator(color: Color(0xFFFF742D))
                      : Text(
                          _hasMore ? '上拉加载更多' : '没有更多了',
                          style: const TextStyle(
                              color: Colors.grey, fontSize: 12),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard() {
    final detail = _detail;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            height: 100,
            child: RecipeImage(
              url: detail?.coverImage,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  detail?.name ?? '加载中...',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  detail?.description ?? '',
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF666666),
                    height: 1.5,
                  ),
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: (detail?.featureTags ?? [])
                        .map((tag) => Padding(
                              padding: const EdgeInsets.only(right: 6),
                              child: _buildTag(tag),
                            ))
                        .toList(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(text,
          style: const TextStyle(fontSize: 10, color: Color(0xFF999999))),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 18,
            decoration: BoxDecoration(
              color: const Color(0xFFFF742D),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Text(title,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333))),
        ],
      ),
    );
  }

  Widget _buildCategoryFilter() {
    final tags = _detail?.filterTags ?? [];
    return SizedBox(
      height: 32,
      child: TabBar(
        controller: _tagTabController,
        isScrollable: true,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: const Color(0xFFFF742D),
        ),
        labelColor: Colors.white,
        unselectedLabelColor: const Color(0xFF666666),
        indicatorSize: TabBarIndicatorSize.tab,
        labelPadding: const EdgeInsets.symmetric(horizontal: 16),
        tabs: [
          const Tab(child: Text('全部', style: TextStyle(fontSize: 13))),
          ...tags.map(
            (t) => Tab(child: Text(t.name, style: const TextStyle(fontSize: 13))),
          ),
        ],
      ),
    );
  }

  Widget _buildDishItem(RecipeListItem item) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => DishDetail(recipeId: item.id)),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: RecipeImage(
                url: item.coverImage,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Color(0xFF333333),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.subtitle ?? '',
                    style: const TextStyle(
                        color: Color(0xFF999999), fontSize: 12),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        (item.likeCount ?? 0) > 0
                            ? Icons.favorite
                            : Icons.favorite_border,
                        size: 14,
                        color: const Color(0xFFFF4D4D),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        formatCount(item.likeCount),
                        style: const TextStyle(
                            fontSize: 12, color: Color(0xFF999999)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._widget);
  final Widget _widget;

  @override
  double get minExtent => 48;
  @override
  double get maxExtent => 48;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return _widget;
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) => false;
}
