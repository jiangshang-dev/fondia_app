import 'package:flutter/material.dart';
import 'package:fondia/api/cuisine.dart';
import 'package:fondia/components/Home/Slider.dart';
import 'package:fondia/components/common/SectionTitleBar.dart';
import 'package:fondia/l10n/app_localizations.dart';
import 'package:fondia/models/recipe_models.dart';
import 'package:fondia/pages/CategoryDetail/DishDetail.dart';
import 'package:fondia/pages/CategoryDetail/index.dart';
import 'package:fondia/utils/recipe_image.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  List<CategoryBrief> _hotCuisines = [];
  List<CategoryBrief> _allCuisines = [];
  List<RecipeListItem> _recommendList = [];
  List<HomeBanner> _banners = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _loading = true);

    final hotFuture = CuisineApi.listHotCuisines().catchError((_) => <CategoryBrief>[]);
    final allFuture = CuisineApi.listAllCuisines().catchError((_) => <CategoryBrief>[]);
    final recipeFuture = CuisineApi.pageRecipes(pageNo: 1, pageSize: 4).catchError(
      (_) => RecipePage(),
    );
    final bannerFuture = CuisineApi.listHomeBanners().catchError((_) => <HomeBanner>[]);

    final results = await Future.wait([
      hotFuture,
      allFuture,
      recipeFuture,
      bannerFuture,
    ]);

    if (!mounted) return;
    setState(() {
      _hotCuisines = results[0] as List<CategoryBrief>;
      _allCuisines = results[1] as List<CategoryBrief>;
      _recommendList = (results[2] as RecipePage).records;
      _banners = results[3] as List<HomeBanner>;
      _loading = false;
    });
  }

  void _openCuisineDetail(String cuisineId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CategoryDetailView(cuisineId: cuisineId),
      ),
    );
  }

  void _openRecipeDetail(String recipeId) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => DishDetail(recipeId: recipeId)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return RefreshIndicator(
      onRefresh: _loadData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: SliderView(
                items: _banners,
                onRecipeTap: _openRecipeDetail,
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Image.asset('lib/assets/hot.png', width: 32, height: 32),
                  const SizedBox(width: 8),
                  Text(
                    l10n.hotCuisines,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            if (_loading)
              const Padding(
                padding: EdgeInsets.all(24),
                child: CircularProgressIndicator(color: Colors.orange),
              )
            else if (_hotCuisines.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(l10n.noHotCuisines, style: const TextStyle(color: Colors.grey)),
              )
            else
              SizedBox(
                height: 130,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _hotCuisines.take(8).length,
                  separatorBuilder: (_, __) => const SizedBox(width: 16),
                  itemBuilder: (context, index) {
                    final item = _hotCuisines[index];
                    return GestureDetector(
                      onTap: () => _openCuisineDetail(item.id),
                      child: Column(
                        children: [
                          SizedBox(
                            width: 70,
                            height: 100,
                            child: RecipeImage(
                              url: item.coverImage,
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            width: 70,
                            child: Text(
                              item.name,
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            const SizedBox(height: 24),
            SectionTitleBar(title: l10n.cuisineCategory, padding: EdgeInsets.zero),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisExtent: 95,
                ),
                itemCount: _allCuisines.length,
                itemBuilder: (context, index) {
                  final item = _allCuisines[index];
                  return GestureDetector(
                    onTap: () => _openCuisineDetail(item.id),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Center(child: cuisineIconWidget(item.icon)),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          item.name,
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Icon(Icons.keyboard_arrow_down,
                  color: Colors.grey[500], size: 32),
            ),
            const SizedBox(height: 24),
            SectionTitleBar(
              title: l10n.todayRecommend,
              actionText: l10n.refresh,
              padding: EdgeInsets.zero,
              onActionTap: _loadData,
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.85,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: _recommendList.length,
                itemBuilder: (context, index) {
                  final item = _recommendList[index];
                  return GestureDetector(
                    onTap: () => _openRecipeDetail(item.id),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: RecipeImage(
                              url: item.coverImage,
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(16),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.title,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  item.subtitle ?? '',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 12,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const Icon(Icons.favorite_border,
                                        size: 14, color: Colors.red),
                                    const SizedBox(width: 4),
                                    Text(
                                      formatCount(item.likeCount),
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 12,
                                      ),
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
                },
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
