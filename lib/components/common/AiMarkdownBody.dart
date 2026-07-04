import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

/// AI 助手消息 Markdown 渲染（标题、列表、加粗、引用等）
class AiMarkdownBody extends StatelessWidget {
  const AiMarkdownBody({
    super.key,
    required this.data,
    this.showCursor = false,
  });

  final String data;
  final bool showCursor;

  static MarkdownStyleSheet _styleSheet() {
    const baseColor = Color(0xFF333333);
    const mutedColor = Color(0xFF666666);
    const accentColor = Color(0xFFFF8A4C);

    return MarkdownStyleSheet(
      p: const TextStyle(fontSize: 14, color: baseColor, height: 1.55),
      pPadding: const EdgeInsets.only(bottom: 6),
      h1: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: baseColor, height: 1.35),
      h1Padding: const EdgeInsets.only(top: 8, bottom: 6),
      h2: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: baseColor, height: 1.35),
      h2Padding: const EdgeInsets.only(top: 8, bottom: 6),
      h3: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: baseColor, height: 1.35),
      h3Padding: const EdgeInsets.only(top: 6, bottom: 4),
      h4: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: baseColor, height: 1.35),
      strong: const TextStyle(fontWeight: FontWeight.bold, color: baseColor),
      em: const TextStyle(fontStyle: FontStyle.italic, color: baseColor),
      blockquote: const TextStyle(fontSize: 14, color: mutedColor, height: 1.5),
      blockquoteDecoration: BoxDecoration(
        border: Border(left: BorderSide(color: accentColor.withValues(alpha: 0.55), width: 3)),
      ),
      blockquotePadding: const EdgeInsets.only(left: 12, top: 2, bottom: 2),
      listBullet: const TextStyle(fontSize: 14, color: baseColor),
      listIndent: 20,
      code: const TextStyle(
        fontSize: 13,
        color: baseColor,
        backgroundColor: Color(0xFFF0F0F0),
        fontFamily: 'monospace',
      ),
      codeblockDecoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(8),
      ),
      codeblockPadding: const EdgeInsets.all(10),
      horizontalRuleDecoration: BoxDecoration(
        border: Border(top: BorderSide(color: Color(0xFFE8E8E8), width: 1)),
      ),
      tableHead: const TextStyle(fontWeight: FontWeight.bold, color: baseColor),
      tableBody: const TextStyle(fontSize: 14, color: baseColor),
      a: const TextStyle(color: accentColor, decoration: TextDecoration.underline),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty && !showCursor) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (data.isNotEmpty)
          MarkdownBody(
            data: data,
            shrinkWrap: true,
            styleSheet: _styleSheet(),
            selectable: true,
          ),
        if (showCursor)
          const Text(
            '▍',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFFFF8A4C),
              fontWeight: FontWeight.w300,
            ),
          ),
      ],
    );
  }
}
