import 'package:fondia/utils/id_util.dart';

class InteractionRecord {
  final String id;
  final String recipeId;
  final String? createTime;
  final String? browseTime;

  const InteractionRecord({
    required this.id,
    required this.recipeId,
    this.createTime,
    this.browseTime,
  });

  String? get actionTime => browseTime ?? createTime;

  factory InteractionRecord.fromJson(Map<String, dynamic> json) {
    return InteractionRecord(
      id: asIdString(json['id']),
      recipeId: asIdString(json['recipeId']),
      createTime: json['createTime']?.toString(),
      browseTime: json['browseTime']?.toString(),
    );
  }
}

class InteractionRecordPage {
  final List<InteractionRecord> records;
  final int total;

  const InteractionRecordPage({
    required this.records,
    this.total = 0,
  });

  factory InteractionRecordPage.fromJson(Map<String, dynamic> json) {
    final recordsJson = json['records'];
    return InteractionRecordPage(
      records: recordsJson is List
          ? recordsJson
              .whereType<Map>()
              .map((e) => InteractionRecord.fromJson(Map<String, dynamic>.from(e)))
              .toList()
          : const [],
      total: _asInt(json['total']),
    );
  }
}

class MineRecipeItem {
  final String recipeId;
  final String title;
  final String? subtitle;
  final String? coverImage;
  final int? viewCount;
  final int? likeCount;
  final String? actionTime;
  final List<String> tags;

  const MineRecipeItem({
    required this.recipeId,
    required this.title,
    this.subtitle,
    this.coverImage,
    this.viewCount,
    this.likeCount,
    this.actionTime,
    this.tags = const [],
  });
}

class MineRecipePage {
  final List<MineRecipeItem> items;
  final int total;

  const MineRecipePage({required this.items, this.total = 0});
}

class ToggleInteractionResult {
  final bool active;
  final int count;

  const ToggleInteractionResult({required this.active, this.count = 0});

  factory ToggleInteractionResult.fromJson(Map<String, dynamic> json) {
    return ToggleInteractionResult(
      active: json['active'] == true,
      count: _asInt(json['count']),
    );
  }
}

int _asInt(dynamic value, {int defaultValue = 0}) {
  if (value == null) return defaultValue;
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value.toString()) ?? defaultValue;
}
