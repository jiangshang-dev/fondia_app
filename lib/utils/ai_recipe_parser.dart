import 'package:fondia/api/search.dart';
import 'package:fondia/models/ai_chat_models.dart';
import 'package:fondia/models/recipe_models.dart';

/// 雪花 ID：纯数字
bool isValidRecipeId(String id) => RegExp(r'^\d{10,20}$').hasMatch(id);

/// 从 AI 回复文本中提取可能的菜名并搜索 App 内菜谱（后端未返回 recipes 时的兜底）
Future<List<AiRecipeCard>> matchRecipesFromText(String text) async {
  final tagCards = await _extractRecipeTagCards(text);
  final cards = <AiRecipeCard>[...tagCards];
  final seen = cards.map((e) => e.id).toSet();

  final names = _extractCandidates(text);
  for (final name in names) {
    if (cards.length >= 5) break;
    try {
      final page = await SearchApi.searchRecipes(keyword: name, pageSize: 3);
      final match = _pickBestMatch(name, page.records);
      if (match != null && seen.add(match.id)) {
        cards.add(_toCard(match));
      }
    } catch (_) {}
  }
  return cards;
}

Future<List<AiRecipeCard>> _extractRecipeTagCards(String text) async {
  final cards = <AiRecipeCard>[];
  final seen = <String>{};
  final tagRe = RegExp(r'\[\[recipe:([^:\]]+):([^\]]+)\]\]');
  for (final m in tagRe.allMatches(text)) {
    var id = m.group(1)?.trim() ?? '';
    final title = m.group(2)?.trim() ?? '';
    if (id.isEmpty) continue;

    if (!isValidRecipeId(id)) {
      final keyword = title.isNotEmpty ? title : id;
      try {
        final page = await SearchApi.searchRecipes(keyword: keyword, pageSize: 3);
        final match = _pickBestMatch(keyword, page.records);
        if (match == null) continue;
        id = match.id;
        if (seen.add(id)) {
          cards.add(_toCard(match));
        }
      } catch (_) {}
      continue;
    }

    if (seen.add(id)) {
      cards.add(AiRecipeCard(id: id, title: title.isNotEmpty ? title : id));
    }
  }
  return cards;
}

List<String> _extractCandidates(String text) {
  final names = <String>[];
  final seen = <String>{};

  for (final line in text.split(RegExp(r'\r?\n'))) {
    final trimmed = line.trim();
    if (trimmed.isEmpty) continue;

    RegExpMatch? m = RegExp(r'^[\d]+[.、)\]]\s*(.+)$').firstMatch(trimmed);
    if (m != null) {
      _addName(seen, names, _cleanName(m.group(1)!));
      continue;
    }
    m = RegExp(r'^[-*•]\s*(.+)$').firstMatch(trimmed);
    if (m != null) {
      _addName(seen, names, _cleanName(m.group(1)!));
      continue;
    }
    for (final b in RegExp(r'[《【]([^《》【】]+)[》】]').allMatches(trimmed)) {
      _addName(seen, names, _cleanName(b.group(1)!));
    }
  }
  return names;
}

void _addName(Set<String> seen, List<String> names, String name) {
  if (name.length >= 2 && seen.add(name)) {
    names.add(name);
  }
}

String _cleanName(String raw) {
  var name = raw.trim();
  name = name.replaceAll(RegExp(r'[：:].*$'), '');
  name = name.replaceAll(RegExp(r'[（(].*?[）)]'), '');
  name = name.replaceAll(RegExp(r'[~～].*$'), '');
  name = name.replaceAll(RegExp(r'\s+'), '');
  if (name.length > 20) name = name.substring(0, 20);
  return name;
}

RecipeListItem? _pickBestMatch(String keyword, List<RecipeListItem> records) {
  if (records.isEmpty) return null;
  for (final item in records) {
    if (item.title.contains(keyword) || keyword.contains(item.title)) {
      return item;
    }
  }
  return records.first;
}

AiRecipeCard _toCard(RecipeListItem item) {
  return AiRecipeCard(
    id: item.id,
    title: item.title,
    subtitle: item.subtitle,
    coverImage: item.coverImage,
    cookMinutes: item.cookMinutes,
  );
}

List<AiRecipeCard> parseRecipeCards(dynamic raw) {
  if (raw is! List) return const [];
  return raw
      .map((e) => AiRecipeCard.fromJson(Map<String, dynamic>.from(e as Map)))
      .where((e) => e.id.isNotEmpty && isValidRecipeId(e.id))
      .toList();
}

/// 非数字 id 时按名称搜索解析真实菜谱 id
Future<String?> resolveRecipeId(String recipeId, {String? title}) async {
  if (isValidRecipeId(recipeId)) return recipeId;
  final keyword = (title != null && title.isNotEmpty) ? title : recipeId;
  try {
    final page = await SearchApi.searchRecipes(keyword: keyword, pageSize: 3);
    final match = _pickBestMatch(keyword, page.records);
    return match?.id;
  } catch (_) {
    return null;
  }
}

/// 隐藏正文中的 [[recipe:id:title]] 标记，卡片单独展示
String stripRecipeTags(String text) {
  return text.replaceAll(RegExp(r'\[\[recipe:[^\]]+\]\]'), '').trim();
}
