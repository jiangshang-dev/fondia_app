import 'package:flutter/material.dart';
import 'package:fondia/api/support.dart';
import 'package:fondia/models/ai_chat_models.dart';
import 'package:fondia/pages/Ai/AiChatHistory.dart';
import 'package:fondia/pages/CategoryDetail/DishDetail.dart';
import 'package:fondia/stores/TokenManager.dart';
import 'package:fondia/utils/ai_recipe_parser.dart';
import 'package:fondia/utils/DioRequest.dart';
import 'package:fondia/utils/recipe_image.dart';
import 'package:fondia/utils/sse_client.dart';

class AiExclusiveView extends StatefulWidget {
  const AiExclusiveView({
    super.key,
    this.initialMessage,
    this.sessionId,
    this.newSession = false,
  });

  /// 进入后自动发送的首条消息（营养咨询表单提交）
  final String? initialMessage;

  /// 从历史记录进入时指定会话
  final String? sessionId;

  /// 是否强制新建会话（营养咨询提交时为 true）
  final bool newSession;

  @override
  State<AiExclusiveView> createState() => _AiExclusiveViewState();
}

class _AiExclusiveViewState extends State<AiExclusiveView> {
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final List<String> _suggestions = const [
    '减肥期间晚餐吃什么好？',
    '糖尿病病人早餐推荐',
    '孕妇可以吃海鲜吗？',
    '想增肌，怎么搭配饮食？',
  ];

  List<AiChatMessage> _messages = [];
  String? _sessionId;
  bool _loading = true;
  bool _sending = false;
  bool _showWelcome = true;

  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _bootstrap() async {
    if (!tokenManager.isLoggedIn()) {
      if (mounted) {
        setState(() => _loading = false);
        _showLoginTip();
      }
      return;
    }

    try {
      if (widget.newSession) {
        final created = await SupportApi.createAiSession(source: kAiTabSource);
        _sessionId = created['id']?.toString();
      } else if (widget.sessionId != null) {
        _sessionId = widget.sessionId;
        await _loadHistory();
        _showWelcome = _messages.isEmpty;
      } else {
        final active = await SupportApi.getActiveAiSession(source: kAiTabSource);
        _sessionId = active?['id']?.toString();
        if (_sessionId != null) {
          await _loadHistory();
          _showWelcome = _messages.isEmpty;
        }
      }

      final preset = widget.initialMessage?.trim();
      if (preset != null && preset.isNotEmpty) {
        if (mounted) setState(() => _loading = false);
        await _sendMessage(preset);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('加载失败：$e')),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _showLoginTip() {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('需要登录'),
        content: const Text('使用 AI 助手需要先登录账号'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('取消')),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pushNamed(context, '/login');
            },
            child: const Text('去登录'),
          ),
        ],
      ),
    );
  }

  Future<void> _loadHistory() async {
    if (_sessionId == null) return;
    final list = await SupportApi.getMessages(_sessionId!);
    final messages = <AiChatMessage>[];
    for (final raw in list) {
      final msg = Map<String, dynamic>.from(raw);
      final sender = msg['senderType']?.toString() ?? '';
      final isUser = sender == 'USER';
      if (sender != 'USER' && sender != 'AI') continue;
      final text = msg['content']?.toString() ?? '';
      List<AiRecipeCard> recipes = const [];
      if (!isUser && text.isNotEmpty) {
        recipes = await matchRecipesFromText(text);
      }
      messages.add(AiChatMessage(
        isUser: isUser,
        text: text,
        time: _formatTime(msg['createTime']),
        recipes: recipes,
      ));
    }
    if (mounted) {
      setState(() {
        _messages = messages;
        _showWelcome = messages.isEmpty;
      });
      _scrollToBottom();
    }
  }

  String _formatTime(dynamic ts) {
    if (ts == null) return '';
    final dt = DateTime.fromMillisecondsSinceEpoch(int.parse(ts.toString()));
    return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }

  Future<void> _sendMessage(String text) async {
    if (!tokenManager.isLoggedIn()) {
      _showLoginTip();
      return;
    }
    final content = text.trim();
    if (content.isEmpty || _sending) return;

    setState(() {
      _sending = true;
      _showWelcome = false;
      _messages.add(AiChatMessage(
        isUser: true,
        text: content,
        time: _formatTime(DateTime.now().millisecondsSinceEpoch),
      ));
    });
    _inputController.clear();
    _scrollToBottom();

    late final int aiIndex;
    setState(() {
      _messages.add(AiChatMessage(
        isUser: false,
        text: '',
        time: _formatTime(DateTime.now().millisecondsSinceEpoch),
        isStreaming: true,
      ));
      aiIndex = _messages.length - 1;
    });
    _scrollToBottom();

    final accumulator = AiStreamTextAccumulator();
    List<AiRecipeCard> recipes = [];
    var streamError = '';

    void updateAiBubble() {
      if (!mounted || aiIndex >= _messages.length) return;
      _messages[aiIndex] = _messages[aiIndex].copyWith(
        text: accumulator.text,
        isStreaming: true,
      );
      setState(() {});
      _scrollToBottom();
    }

    try {
      await SupportApi.aiChatStream(
        content: content,
        sessionId: _sessionId,
        source: kAiTabSource,
        onEvent: (event) {
          final eventType = event['event']?.toString() ?? '';

          if (eventType == 'APP_META') {
            _sessionId = event['sessionId']?.toString() ?? _sessionId;
            recipes = parseRecipeCards(event['recipes']);
            return;
          }
          if (eventType == 'APP_ERROR') {
            streamError = event['message']?.toString() ?? 'AI服务异常';
            return;
          }
          if (eventType == 'APP_TRANSFER') {
            return;
          }

          accumulator.consume(event);
          updateAiBubble();
        },
      );

      if (recipes.isEmpty && accumulator.text.isNotEmpty) {
        recipes = await matchRecipesFromText(accumulator.text);
      }

      if (mounted) {
        final finalText = accumulator.text.isNotEmpty
            ? accumulator.text
            : (streamError.isNotEmpty ? streamError : '抱歉，AI 暂时无法回复，请稍后重试。');
        setState(() {
          _messages[aiIndex] = _messages[aiIndex].copyWith(
            text: finalText,
            recipes: recipes,
            isStreaming: false,
          );
        });
        _scrollToBottom();
      }
    } catch (e) {
      if (mounted) {
        final fallback = accumulator.text.isNotEmpty
            ? accumulator.text
            : '抱歉，AI 暂时无法回复，请稍后重试。';
        setState(() {
          if (aiIndex < _messages.length) {
            _messages[aiIndex] = _messages[aiIndex].copyWith(
              text: fallback,
              isStreaming: false,
            );
          }
        });
        if (accumulator.text.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('发送失败：${dioErrorMessage(e)}')),
          );
        }
      }
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
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
      resizeToAvoidBottomInset: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFF7F2), Color(0xFFFFFFFF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(),
              Expanded(
                child: _loading && _messages.isEmpty
                    ? const Center(child: CircularProgressIndicator(color: Colors.orange))
                    : ListView(
                        controller: _scrollController,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        children: [
                          const SizedBox(height: 16),
                          if (_showWelcome) ...[
                            _buildWelcomeHeader(),
                            const SizedBox(height: 16),
                            _buildSuggestionTags(),
                          ],
                          ..._messages.map(_buildMessageItem),
                          const SizedBox(height: 16),
                        ],
                      ),
              ),
              _buildBottomActionArea(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, size: 20, color: Color(0xFF333333)),
            onPressed: () => Navigator.maybePop(context),
          ),
          const Text(
            'AI 助手',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF333333)),
          ),
          TextButton.icon(
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AiChatHistoryView()),
              );
            },
            icon: const Icon(Icons.history, size: 16, color: Color(0xFF666666)),
            label: const Text('对话记录', style: TextStyle(color: Color(0xFF666666), fontSize: 13)),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: const Color(0xFFF0F0F0),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5)],
          ),
          child: const Center(child: Text('🤖', style: TextStyle(fontSize: 28))),
        ),
        const SizedBox(width: 12),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Hi，我是你的 AI 营养师',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF333333)),
                  ),
                  SizedBox(width: 4),
                  Text('👋', style: TextStyle(fontSize: 16)),
                ],
              ),
              SizedBox(height: 6),
              Text(
                '关于饮食、营养、搭配的问题都可以问我~',
                style: TextStyle(fontSize: 13, color: Color(0xFF999999)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSuggestionTags() {
    return SizedBox(
      height: 76,
      child: GridView.builder(
        scrollDirection: Axis.horizontal,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          childAspectRatio: 0.32,
        ),
        itemCount: _suggestions.length,
        itemBuilder: (context, index) {
          final text = _suggestions[index];
          return GestureDetector(
            onTap: () => _sendMessage(text),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFFEFEFEF)),
              ),
              alignment: Alignment.center,
              child: Text(
                text,
                style: const TextStyle(fontSize: 12, color: Color(0xFF555555)),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMessageItem(AiChatMessage msg) {
    if (msg.isUser) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Flexible(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: const BoxDecoration(
                  color: Color(0xFFFFE6D5),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                ),
                child: Text(
                  msg.text,
                  style: const TextStyle(fontSize: 14, color: Color(0xFF6B3A1A), height: 1.4),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: const BoxDecoration(color: Color(0xFFEAEAEA), shape: BoxShape.circle),
            child: const Center(child: Text('🤖', style: TextStyle(fontSize: 18))),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFBF9),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFFFF0E5)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    msg.text,
                    style: const TextStyle(fontSize: 14, color: Color(0xFF333333), height: 1.5),
                  ),
                  if (msg.isStreaming)
                    const Text(
                      ' ▍',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFFFF8A4C),
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  if (msg.recipes.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    ...msg.recipes.map(_buildRecipeCard),
                    const SizedBox(height: 8),
                    const Text(
                      '点击菜谱可查看详细做法',
                      style: TextStyle(fontSize: 12, color: Color(0xFF999999)),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecipeCard(AiRecipeCard recipe) {
    return GestureDetector(
      onTap: () => _openRecipe(recipe.id),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFF5F5F5)),
        ),
        child: Row(
          children: [
            RecipeImage(
              url: recipe.coverImage,
              width: 50,
              height: 50,
              borderRadius: BorderRadius.circular(8),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recipe.title,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF333333)),
                  ),
                  if (recipe.infoText.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      recipe.infoText,
                      style: const TextStyle(fontSize: 11, color: Color(0xFF999999)),
                    ),
                  ],
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Color(0xFFCCCCCC), size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomActionArea() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildBottomQuickButton(Icons.refresh, '换一批', '请再推荐一批不同的菜谱'),
              _buildBottomQuickButton(Icons.assignment, '详细做法', '请给出上面推荐菜谱的详细做法步骤'),
              _buildBottomQuickButton(Icons.swap_horiz, '食材替换', '如果缺少某种食材，可以用什么替换？'),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 44,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF6F6F6),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: TextField(
                    controller: _inputController,
                    enabled: !_sending,
                    decoration: const InputDecoration(
                      hintText: '输入你的问题...',
                      hintStyle: TextStyle(color: Color(0xFFBBBBBB), fontSize: 14),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                    textInputAction: TextInputAction.send,
                    onSubmitted: _sendMessage,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: _sending ? null : () => _sendMessage(_inputController.text),
                  customBorder: const CircleBorder(),
                  child: Ink(
                    width: 44,
                    height: 44,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFFFFB385), Color(0xFFFF8A4C)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: _sending
                        ? const Padding(
                            padding: EdgeInsets.all(12),
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                        : const Icon(Icons.send, color: Colors.white, size: 18),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomQuickButton(IconData icon, String label, String prompt) {
    return GestureDetector(
      onTap: _sending ? null : () => _sendMessage(prompt),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFE8E8E8)),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 4, offset: const Offset(0, 2)),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, size: 14, color: const Color(0xFF666666)),
            const SizedBox(width: 4),
            Text(label, style: const TextStyle(fontSize: 12, color: Color(0xFF555555))),
          ],
        ),
      ),
    );
  }
}
