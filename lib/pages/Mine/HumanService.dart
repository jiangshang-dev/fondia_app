import 'package:flutter/material.dart';

class HumanServiceView extends StatefulWidget {
  const HumanServiceView({super.key});

  @override
  State<HumanServiceView> createState() => _HumanServiceViewState();
}

class _HumanServiceViewState extends State<HumanServiceView> {
  final TextEditingController _msgController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // 模拟真实的人工对话流数据
  final List<Map<String, dynamic>> _chatMessages = [
    {
      'isMe': false,
      'time': '14:35',
      'text': '您好，我是人工客服小美，很高兴为您服务！请问有什么可以帮您的？🌸',
    },
    {
      'isMe': true,
      'time': '14:36',
      'text': '你好，我今天早上签到失败了，连续签到3天的奖励没有拿到，能帮我查查吗？',
    },
    {
      'isMe': false,
      'time': '14:37',
      'text': '好的，收到您的反馈。这边正在为您查询系统后台日志，请稍等 1-2 分钟哦～',
    },
  ];

  @override
  void dispose() {
    _msgController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // 模拟发送消息
  void _sendMessage() {
    if (_msgController.text.trim().isEmpty) return;
    setState(() {
      _chatMessages.add({
        'isMe': true,
        'time': '14:38', // 实际开发用 DateTime 格式化
        'text': _msgController.text.trim(),
      });
    });
    _msgController.clear();
    // 延迟滚动到底部
    Future.delayed(const Duration(milliseconds: 100), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FA), // 保持系统浅灰底色
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18, color: Color(0xFF333333)),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: Column(
          children: [
            const Text(
              '人工客服',
              style: TextStyle(color: Color(0xFF333333), fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 2),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(color: Color(0xFF00BFA5), shape: BoxShape.circle),
                ),
                const SizedBox(width: 4),
                const Text('小美在线中', style: TextStyle(color: Color(0xFF999999), fontSize: 11)),
              ],
            )
          ],
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // 提示横幅：强调人工服务与隐私
            _buildTopTipBanner(),

            // 1. 聊天消息主体对话流
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                itemCount: _chatMessages.length,
                itemBuilder: (context, index) {
                  return _buildChatBubble(_chatMessages[index]);
                },
              ),
            ),

            // 2. 底部复合聊天输入栏（与 AI 助手完美对齐）
            _buildBottomChatInput(),
          ],
        ),
      ),
    );
  }

  // 顶部提示条
  Widget _buildTopTipBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      color: const Color(0xFFFFF7F2), // 经典温暖淡蜜桃粉
      child: const Row(
        children: [
          Icon(Icons.security, size: 14, color: Color(0xFFFF8A4C)),
          SizedBox(width: 6),
          Expanded(
            child: Text(
              '小厨致力保护您的隐私，本次通话已加密。',
              style: TextStyle(fontSize: 11, color: Color(0xFFFF8A4C)),
            ),
          ),
        ],
      ),
    );
  }

  // 1. 聊天气泡构建器
  Widget _buildChatBubble(Map<String, dynamic> msg) {
    final bool isMe = msg['isMe'];

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 左侧客服头像
          if (!isMe) ...[
            Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(color: Color(0xFFFFE6D5), shape: BoxShape.circle),
              child: const Center(child: Text('👩‍💻', style: TextStyle(fontSize: 18))),
            ),
            const SizedBox(width: 8),
          ],

          // 聊天气泡本体
          Flexible(
            child: Column(
              crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: isMe ? const Color(0xFFFFE6D5) : Colors.white, // 我发的用暖粉橙色，客服用白色卡片
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(14),
                      topRight: const Radius.circular(14),
                      bottomLeft: Radius.circular(isMe ? 14 : 2), // 异型切角
                      bottomRight: Radius.circular(isMe ? 2 : 14),
                    ),
                    boxShadow: [
                      if (!isMe)
                        BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 4, offset: const Offset(0, 2))
                    ],
                  ),
                  child: Text(
                    msg['text'],
                    style: TextStyle(
                      fontSize: 14,
                      color: isMe ? const Color(0xFF6B3A1A) : const Color(0xFF333333),
                      height: 1.4,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(msg['time'], style: const TextStyle(fontSize: 10, color: Color(0xFFCCCCCC))),
              ],
            ),
          ),

          // 右侧我的头像
          if (isMe) ...[
            const SizedBox(width: 8),
            Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(color: Color(0xFFE0E0E0), shape: BoxShape.circle),
              child: const Center(child: Text('🍳', style: TextStyle(fontSize: 18))), // 可替换为用户真实头像
            ),
          ],
        ],
      ),
    );
  }

  // 2. 底部复合输入控制栏
  Widget _buildBottomChatInput() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFEFEFEF), width: 0.5)),
      ),
      child: Row(
        children: [
          // 快捷加号扩展（发图片/拍摄）
          IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            icon: const Icon(Icons.add_circle_outline, color: Color(0xFF666666), size: 26),
            onPressed: () {},
          ),
          const SizedBox(width: 10),

          // 核心胶囊文本框
          Expanded(
            child: Container(
              height: 40,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F6F7),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _msgController,
                      style: const TextStyle(fontSize: 14),
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _sendMessage(),
                      decoration: const InputDecoration(
                        hintText: '描述您遇到的问题...',
                        hintStyle: TextStyle(color: Color(0xFFBBBBBB), fontSize: 13),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                  // 语音键
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: const Icon(Icons.mic_none, color: Color(0xFFFF8A4C), size: 22),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),

          // 发送按钮（深度对齐大橙色调圆扣）
          InkWell(
            onTap: _sendMessage,
            borderRadius: BorderRadius.circular(20),
            child: Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFFF955B), Color(0xFFFF6A1A)],
                ),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.send, color: Colors.white, size: 16),
            ),
          )
        ],
      ),
    );
  }
}