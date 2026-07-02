import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fondia/api/support.dart';
import 'package:fondia/constants/index.dart';
import 'package:fondia/stores/TokenManager.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

/// 统一客服聊天页：默认 AI 自助，可转人工（WebSocket）
class HumanServiceView extends StatefulWidget {
  const HumanServiceView({
    super.key,
    this.presetMessage,
    this.transferToHuman = false,
    this.source,
  });

  final String? presetMessage;
  final bool transferToHuman;
  final String? source;

  @override
  State<HumanServiceView> createState() => _HumanServiceViewState();
}

class _HumanServiceViewState extends State<HumanServiceView> {
  final TextEditingController _msgController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<Map<String, dynamic>> _chatMessages = [];
  String? _sessionId;
  String _sessionStatus = 'AI';
  String _privacyTip = '小厨致力保护您的隐私，本次通话已加密。';
  String _humanGreeting = '';
  bool _loading = true;
  bool _sending = false;
  WebSocketChannel? _wsChannel;
  Timer? _pollTimer;

  bool get _isHumanMode => _sessionStatus == 'WAITING' || _sessionStatus == 'CHATTING';

  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    try {
      final config = await SupportApi.getConfig();
      _privacyTip = config['privacyTip']?.toString() ?? _privacyTip;
      _humanGreeting = config['humanGreeting']?.toString() ?? '';

      if (widget.transferToHuman) {
        await _doTransfer();
      } else {
        final active = await SupportApi.getActiveSession();
        if (active != null && (active['status'] == 'WAITING' || active['status'] == 'CHATTING')) {
          _sessionId = active['id']?.toString();
          _sessionStatus = active['status']?.toString() ?? 'WAITING';
          await _loadHistory();
          _connectWs();
        } else if (widget.presetMessage != null && widget.presetMessage!.isNotEmpty) {
          await _sendAiMessage(widget.presetMessage!);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('加载失败: $e')));
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _loadHistory() async {
    if (_sessionId == null) return;
    final list = await SupportApi.getMessages(_sessionId!);
    setState(() {
      _chatMessages = list.map((e) => _mapMessage(Map<String, dynamic>.from(e))).toList();
    });
    _scrollToBottom();
  }

  Map<String, dynamic> _mapMessage(Map<String, dynamic> msg) {
    final sender = msg['senderType']?.toString() ?? '';
    return {
      'isMe': sender == 'USER',
      'isAi': sender == 'AI',
      'time': _formatTime(msg['createTime']),
      'text': msg['content']?.toString() ?? '',
    };
  }

  String _formatTime(dynamic ts) {
    if (ts == null) return '';
    final dt = DateTime.fromMillisecondsSinceEpoch(int.parse(ts.toString()));
    return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }

  void _connectWs() {
    if (_sessionId == null) return;
    final wsBase = GlobalConstants.BASE_URL.replaceFirst('http', 'ws');
    final token = tokenManager.getToken();
    final uri = Uri.parse('$wsBase/ws/cs/app/$_sessionId?token=$token');
    _wsChannel?.sink.close();
    _wsChannel = WebSocketChannel.connect(uri);
    _wsChannel!.stream.listen((event) {
      try {
        final json = jsonDecode(event.toString());
        if (json['cmd'] == 'CHAT_PUSH') {
          _loadHistory();
        }
      } catch (_) {}
    });
    _pollTimer?.cancel();
    _pollTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (_isHumanMode) _loadHistory();
    });
  }

  Future<void> _doTransfer() async {
    final res = await SupportApi.transferToHuman(source: widget.source);
    _sessionId = res['id']?.toString();
    _sessionStatus = res['status']?.toString() ?? 'WAITING';
    final greeting = res['humanGreeting']?.toString() ?? _humanGreeting;
    setState(() {
      _chatMessages.add({
        'isMe': false,
        'isAi': false,
        'time': _formatTime(DateTime.now().millisecondsSinceEpoch),
        'text': greeting,
      });
    });
    _connectWs();
    _scrollToBottom();
  }

  Future<void> _sendAiMessage(String text) async {
    setState(() => _sending = true);
    try {
      setState(() {
        _chatMessages.add({
          'isMe': true,
          'isAi': false,
          'time': _formatTime(DateTime.now().millisecondsSinceEpoch),
          'text': text,
        });
      });
      final res = await SupportApi.aiChat(content: text, sessionId: _sessionId, source: widget.source);
      _sessionId = res['sessionId']?.toString() ?? _sessionId;

      if (res['transferred'] == true) {
        _sessionStatus = 'WAITING';
        final greeting = res['humanGreeting']?.toString() ?? _humanGreeting;
        setState(() {
          _chatMessages.add({
            'isMe': false,
            'isAi': false,
            'time': _formatTime(DateTime.now().millisecondsSinceEpoch),
            'text': greeting,
          });
        });
        _connectWs();
      } else {
        setState(() {
          _chatMessages.add({
            'isMe': false,
            'isAi': true,
            'time': _formatTime(DateTime.now().millisecondsSinceEpoch),
            'text': res['reply']?.toString() ?? '',
          });
        });
      }
      _scrollToBottom();
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  Future<void> _sendHumanMessage(String text) async {
    if (_sessionId == null) return;
    setState(() {
      _chatMessages.add({
        'isMe': true,
        'isAi': false,
        'time': _formatTime(DateTime.now().millisecondsSinceEpoch),
        'text': text,
      });
    });
    _scrollToBottom();
    try {
      await SupportApi.sendHumanMessage(_sessionId!, text);
      await _loadHistory();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('发送失败: $e')));
      }
    }
  }

  void _sendMessage() async {
    final text = _msgController.text.trim();
    if (text.isEmpty || _sending) return;
    _msgController.clear();

    if (_isHumanMode) {
      await _sendHumanMessage(text);
    } else {
      await _sendAiMessage(text);
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    _wsChannel?.sink.close();
    _msgController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final title = _isHumanMode ? '人工客服' : '在线客服';
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18, color: Color(0xFF333333)),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: Column(
          children: [
            Text(title, style: const TextStyle(color: Color(0xFF333333), fontSize: 16, fontWeight: FontWeight.bold)),
            if (_isHumanMode)
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width: 6, height: 6, child: DecoratedBox(decoration: BoxDecoration(color: Color(0xFF00BFA5), shape: BoxShape.circle))),
                  SizedBox(width: 4),
                  Text('客服在线中', style: TextStyle(color: Color(0xFF999999), fontSize: 11)),
                ],
              )
            else
              const Text('智能自助', style: TextStyle(color: Color(0xFF999999), fontSize: 11)),
          ],
        ),
        centerTitle: true,
        actions: [
          if (!_isHumanMode)
            TextButton(
              onPressed: _doTransfer,
              child: const Text('转人工', style: TextStyle(color: Color(0xFFFF6A1A), fontSize: 13)),
            ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFFFF6A1A)))
          : SafeArea(
              child: Column(
                children: [
                  _buildTopTipBanner(),
                  Expanded(
                    child: ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      itemCount: _chatMessages.length,
                      itemBuilder: (context, index) => _buildChatBubble(_chatMessages[index]),
                    ),
                  ),
                  _buildBottomChatInput(),
                ],
              ),
            ),
    );
  }

  Widget _buildTopTipBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      color: const Color(0xFFFFF7F2),
      child: Row(
        children: [
          const Icon(Icons.security, size: 14, color: Color(0xFFFF8A4C)),
          const SizedBox(width: 6),
          Expanded(child: Text(_privacyTip, style: const TextStyle(fontSize: 11, color: Color(0xFFFF8A4C)))),
        ],
      ),
    );
  }

  Widget _buildChatBubble(Map<String, dynamic> msg) {
    final bool isMe = msg['isMe'] == true;
    final avatar = isMe ? '🍳' : (msg['isAi'] == true ? '🤖' : '👩‍💻');

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isMe) ...[
            Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(color: Color(0xFFFFE6D5), shape: BoxShape.circle),
              child: Center(child: Text(avatar, style: const TextStyle(fontSize: 18))),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: isMe ? const Color(0xFFFFE6D5) : Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(14),
                      topRight: const Radius.circular(14),
                      bottomLeft: Radius.circular(isMe ? 14 : 2),
                      bottomRight: Radius.circular(isMe ? 2 : 14),
                    ),
                  ),
                  child: Text(
                    msg['text'],
                    style: TextStyle(fontSize: 14, color: isMe ? const Color(0xFF6B3A1A) : const Color(0xFF333333), height: 1.4),
                  ),
                ),
                const SizedBox(height: 4),
                Text(msg['time'], style: const TextStyle(fontSize: 10, color: Color(0xFFCCCCCC))),
              ],
            ),
          ),
          if (isMe) ...[
            const SizedBox(width: 8),
            Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(color: Color(0xFFE0E0E0), shape: BoxShape.circle),
              child: Center(child: Text(avatar, style: const TextStyle(fontSize: 18))),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBottomChatInput() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFEFEFEF), width: 0.5)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 40,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(color: const Color(0xFFF5F6F7), borderRadius: BorderRadius.circular(20)),
              child: TextField(
                controller: _msgController,
                enabled: !_sending,
                style: const TextStyle(fontSize: 14),
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _sendMessage(),
                decoration: InputDecoration(
                  hintText: _isHumanMode ? '描述您遇到的问题...' : '请输入您的问题，AI将基于知识库为您解答...',
                  hintStyle: const TextStyle(color: Color(0xFFBBBBBB), fontSize: 13),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          InkWell(
            onTap: _sending ? null : _sendMessage,
            borderRadius: BorderRadius.circular(20),
            child: Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [Color(0xFFFF955B), Color(0xFFFF6A1A)]),
                shape: BoxShape.circle,
              ),
              child: _sending
                  ? const Padding(padding: EdgeInsets.all(10), child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Icon(Icons.send, color: Colors.white, size: 16),
            ),
          ),
        ],
      ),
    );
  }
}
