class AiRecipeCard {
  final String id;
  final String title;
  final String? subtitle;
  final String? coverImage;
  final int? cookMinutes;

  AiRecipeCard({
    required this.id,
    required this.title,
    this.subtitle,
    this.coverImage,
    this.cookMinutes,
  });

  factory AiRecipeCard.fromJson(Map<String, dynamic> json) {
    return AiRecipeCard(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      subtitle: json['subtitle']?.toString(),
      coverImage: json['coverImage']?.toString(),
      cookMinutes: json['cookMinutes'] == null
          ? null
          : int.tryParse(json['cookMinutes'].toString()),
    );
  }

  String get infoText {
    final parts = <String>[];
    if (subtitle != null && subtitle!.isNotEmpty) {
      parts.add(subtitle!);
    }
    if (cookMinutes != null && cookMinutes! > 0) {
      parts.add('$cookMinutes 分钟');
    }
    return parts.join(' | ');
  }
}

class AiChatMessage {
  final bool isUser;
  final String text;
  final String? time;
  final List<AiRecipeCard> recipes;
  final bool isStreaming;
  final List<AiThinkingStep> thinkingSteps;
  final bool thinkingComplete;
  final bool thinkingExpanded;

  AiChatMessage({
    required this.isUser,
    required this.text,
    this.time,
    this.recipes = const [],
    this.isStreaming = false,
    this.thinkingSteps = const [],
    this.thinkingComplete = false,
    this.thinkingExpanded = false,
  });

  AiChatMessage copyWith({
    String? text,
    List<AiRecipeCard>? recipes,
    bool? isStreaming,
    List<AiThinkingStep>? thinkingSteps,
    bool? thinkingComplete,
    bool? thinkingExpanded,
  }) {
    return AiChatMessage(
      isUser: isUser,
      text: text ?? this.text,
      time: time,
      recipes: recipes ?? this.recipes,
      isStreaming: isStreaming ?? this.isStreaming,
      thinkingSteps: thinkingSteps ?? this.thinkingSteps,
      thinkingComplete: thinkingComplete ?? this.thinkingComplete,
      thinkingExpanded: thinkingExpanded ?? this.thinkingExpanded,
    );
  }
}

/// 一条可展开的推理步骤。标题用于概览，正文支持 Markdown。
class AiThinkingStep {
  final String title;
  final String content;

  const AiThinkingStep({required this.title, required this.content});

  AiThinkingStep copyWith({String? title, String? content}) => AiThinkingStep(
    title: title ?? this.title,
    content: content ?? this.content,
  );
}

class AiSessionSummary {
  final String id;
  final String? lastMessage;
  final int? lastMessageTime;

  AiSessionSummary({required this.id, this.lastMessage, this.lastMessageTime});

  factory AiSessionSummary.fromJson(Map<String, dynamic> json) {
    return AiSessionSummary(
      id: json['id']?.toString() ?? '',
      lastMessage: json['lastMessage']?.toString(),
      lastMessageTime: json['lastMessageTime'] == null
          ? null
          : int.tryParse(json['lastMessageTime'].toString()),
    );
  }
}

/// AI Tab 会话来源标识，与后端 source 字段一致
const String kAiTabSource = 'ai_tab';

/// 在线客服会话来源（与 AI Tab 严格隔离）
const String kCsGeneralSource = 'general';
