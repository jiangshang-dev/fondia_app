import 'package:fondia/utils/id_util.dart';
class CategoryBrief {
  final String id;
  final String name;
  final String? icon;
  final String? coverImage;
  final int? subType;

  CategoryBrief({
    required this.id,
    required this.name,
    this.icon,
    this.coverImage,
    this.subType,
  });

  factory CategoryBrief.fromJson(Map<String, dynamic> json) {
    return CategoryBrief(
      id: asIdString(json['id']),
      name: json['name']?.toString() ?? '',
      icon: json['icon']?.toString(),
      coverImage: json['coverImage']?.toString(),
      subType: json['subType'] == null ? null : _asInt(json['subType']),
    );
  }
}

/// 标签
class RecipeTag {
  final String id;
  final String name;
  final String? tagType;

  RecipeTag({required this.id, required this.name, this.tagType});

  factory RecipeTag.fromJson(Map<String, dynamic> json) {
    return RecipeTag(
      id: asIdString(json['id']),
      name: json['name']?.toString() ?? '',
      tagType: json['tagType']?.toString(),
    );
  }
}

/// 菜系详情头部
class CuisineDetail {
  final String id;
  final String name;
  final String? coverImage;
  final String? description;
  final List<String> featureTags;
  final List<RecipeTag> filterTags;

  CuisineDetail({
    required this.id,
    required this.name,
    this.coverImage,
    this.description,
    this.featureTags = const [],
    this.filterTags = const [],
  });

  factory CuisineDetail.fromJson(Map<String, dynamic> json) {
    return CuisineDetail(
      id: asIdString(json['id']),
      name: json['name']?.toString() ?? '',
      coverImage: json['coverImage']?.toString(),
      description: json['description']?.toString(),
      featureTags: (json['featureTags'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      filterTags: (json['filterTags'] as List<dynamic>?)
              ?.map((e) => RecipeTag.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

/// 菜谱列表项
class RecipeListItem {
  final String id;
  final String title;
  final String? subtitle;
  final String? coverImage;
  final String? cuisineName;
  final int? difficulty;
  final int? cookMinutes;
  final int? likeCount;
  final List<String> tags;

  RecipeListItem({
    required this.id,
    required this.title,
    this.subtitle,
    this.coverImage,
    this.cuisineName,
    this.difficulty,
    this.cookMinutes,
    this.likeCount,
    this.tags = const [],
  });

  factory RecipeListItem.fromJson(Map<String, dynamic> json) {
    return RecipeListItem(
      id: asIdString(json['id']),
      title: json['title']?.toString() ?? '',
      subtitle: json['subtitle']?.toString(),
      coverImage: json['coverImage']?.toString(),
      cuisineName: json['cuisineName']?.toString(),
      difficulty: json['difficulty'] == null ? null : _asInt(json['difficulty']),
      cookMinutes:
          json['cookMinutes'] == null ? null : _asInt(json['cookMinutes']),
      likeCount: json['likeCount'] == null ? null : _asInt(json['likeCount']),
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e.toString()).toList() ??
          [],
    );
  }
}

/// 分类页分区
class CategorySection {
  final String? categoryId;
  final String title;
  final int? subType;
  final List<RecipeListItem> recipes;

  CategorySection({
    this.categoryId,
    required this.title,
    this.subType,
    this.recipes = const [],
  });

  factory CategorySection.fromJson(Map<String, dynamic> json) {
    return CategorySection(
      categoryId: json['categoryId'] == null
          ? null
          : asIdString(json['categoryId']),
      title: json['title']?.toString() ?? '',
      subType: json['subType'] == null ? null : _asInt(json['subType']),
      recipes: (json['recipes'] as List<dynamic>?)
              ?.map((e) => RecipeListItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

/// 分类树
class CategoryTree {
  final String cuisineId;
  final String cuisineName;
  final List<CategorySection> sections;

  CategoryTree({
    required this.cuisineId,
    required this.cuisineName,
    this.sections = const [],
  });

  factory CategoryTree.fromJson(Map<String, dynamic> json) {
    return CategoryTree(
      cuisineId: asIdString(json['cuisineId']),
      cuisineName: json['cuisineName']?.toString() ?? '',
      sections: (json['sections'] as List<dynamic>?)
              ?.map((e) => CategorySection.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

/// 食材
class RecipeIngredient {
  final String id;
  final String name;
  final String amount;
  final String? image;

  RecipeIngredient({
    required this.id,
    required this.name,
    required this.amount,
    this.image,
  });

  factory RecipeIngredient.fromJson(Map<String, dynamic> json) {
    return RecipeIngredient(
      id: asIdString(json['id']),
      name: json['name']?.toString() ?? '',
      amount: json['amount']?.toString() ?? '',
      image: json['image']?.toString(),
    );
  }
}

/// 步骤
class RecipeStep {
  final String id;
  final int stepNo;
  final String? image;
  final String content;
  final String? tip;

  RecipeStep({
    required this.id,
    required this.stepNo,
    this.image,
    required this.content,
    this.tip,
  });

  factory RecipeStep.fromJson(Map<String, dynamic> json) {
    return RecipeStep(
      id: asIdString(json['id']),
      stepNo: _asInt(json['stepNo']),
      image: json['image']?.toString().trim(),
      content: json['content']?.toString() ?? '',
      tip: json['tip']?.toString(),
    );
  }
}

/// 菜谱详情
class RecipeDetail {
  final String id;
  final String title;
  final String? subtitle;
  final String? description;
  final String? coverImage;
  final String? videoUrl;
  final String? videoId;
  final String? playUrl;
  final int? videoDuration;
  final int? difficulty;
  final int? cookMinutes;
  final int? calories;
  final String? servingSize;
  final int? likeCount;
  final int? collectCount;
  final int? commentCount;
  final int? viewCount;
  final String? cuisineId;
  final String? cuisineName;
  final List<String> tags;
  final List<RecipeIngredient> ingredients;
  final List<RecipeStep> steps;

  RecipeDetail({
    required this.id,
    required this.title,
    this.subtitle,
    this.description,
    this.coverImage,
    this.videoUrl,
    this.videoId,
    this.playUrl,
    this.videoDuration,
    this.difficulty,
    this.cookMinutes,
    this.calories,
    this.servingSize,
    this.likeCount,
    this.collectCount,
    this.commentCount,
    this.viewCount,
    this.cuisineId,
    this.cuisineName,
    this.tags = const [],
    this.ingredients = const [],
    this.steps = const [],
  });

  factory RecipeDetail.fromJson(Map<String, dynamic> json) {
    return RecipeDetail(
      id: asIdString(json['id']),
      title: json['title']?.toString() ?? '',
      subtitle: json['subtitle']?.toString(),
      description: json['description']?.toString(),
      coverImage: _nullableString(json['coverImage']),
      videoUrl: _nullableString(json['videoUrl']),
      videoId: _nullableString(json['videoId']) ?? _nullableString(json['videoUrl']),
      playUrl: _nullableString(json['playUrl']),
      videoDuration: json['videoDuration'] == null
          ? null
          : _asInt(json['videoDuration']),
      difficulty:
          json['difficulty'] == null ? null : _asInt(json['difficulty']),
      cookMinutes:
          json['cookMinutes'] == null ? null : _asInt(json['cookMinutes']),
      calories: json['calories'] == null ? null : _asInt(json['calories']),
      servingSize: json['servingSize']?.toString(),
      likeCount: json['likeCount'] == null ? null : _asInt(json['likeCount']),
      collectCount:
          json['collectCount'] == null ? null : _asInt(json['collectCount']),
      commentCount:
          json['commentCount'] == null ? null : _asInt(json['commentCount']),
      viewCount: json['viewCount'] == null ? null : _asInt(json['viewCount']),
      cuisineId: json['cuisineId'] == null
          ? null
          : asIdString(json['cuisineId']),
      cuisineName: json['cuisineName']?.toString(),
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e.toString()).toList() ??
          [],
      ingredients: (json['ingredients'] as List<dynamic>?)
              ?.map((e) => RecipeIngredient.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      steps: (json['steps'] as List<dynamic>?)
              ?.map((e) => RecipeStep.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

/// 分页结果
class RecipePage {
  final List<RecipeListItem> records;
  final int total;
  final int current;
  final int pages;

  RecipePage({
    this.records = const [],
    this.total = 0,
    this.current = 1,
    this.pages = 0,
  });

  factory RecipePage.fromJson(Map<String, dynamic> json) {
    return RecipePage(
      records: (json['records'] as List<dynamic>?)
              ?.map((e) => RecipeListItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      total: _asInt(json['total']),
      current: _asInt(json['current'], defaultValue: 1),
      pages: _asInt(json['pages']),
    );
  }
}

int _asInt(dynamic value, {int defaultValue = 0}) {
  if (value == null) return defaultValue;
  if (value is int) return value;
  if (value is double) return value.toInt();
  return int.tryParse(value.toString()) ?? defaultValue;
}

String? _nullableString(dynamic value) {
  if (value == null) return null;
  final text = value.toString();
  if (text.isEmpty || text == 'null') return null;
  return text;
}

/// 难度文案
String difficultyLabel(int? difficulty) {
  switch (difficulty) {
    case 1:
      return '简单';
    case 3:
      return '困难';
    default:
      return '中等';
  }
}

/// 数量格式化（如 2.1万）
String formatCount(num? count) {
  if (count == null || count == 0) return '0';
  if (count >= 10000) {
    return '${(count / 10000).toStringAsFixed(1)}万';
  }
  return count.toString();
}

/// 首页轮播图
class HomeBanner {
  final String id;
  final String? recipeId;
  final String title;
  final String? subtitle;
  final String? imageUrl;

  HomeBanner({
    required this.id,
    this.recipeId,
    required this.title,
    this.subtitle,
    this.imageUrl,
  });

  factory HomeBanner.fromJson(Map<String, dynamic> json) {
    return HomeBanner(
      id: asIdString(json['id']),
      recipeId: json['recipeId'] != null ? asIdString(json['recipeId']) : null,
      title: json['title']?.toString() ?? '',
      subtitle: json['subtitle']?.toString(),
      imageUrl: json['imageUrl']?.toString(),
    );
  }
}
