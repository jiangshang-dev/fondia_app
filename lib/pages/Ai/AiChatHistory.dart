import 'package:flutter/material.dart';
import 'package:fondia/api/support.dart';
import 'package:fondia/models/ai_chat_models.dart';
import 'package:fondia/pages/Ai/AiExclusive.dart';
import 'package:fondia/stores/TokenManager.dart';

class AiChatHistoryView extends StatefulWidget {
  const AiChatHistoryView({super.key});

  @override
  State<AiChatHistoryView> createState() => _AiChatHistoryViewState();
}

class _AiChatHistoryViewState extends State<AiChatHistoryView> {
  List<AiSessionSummary> _sessions = [];
  bool _loading = true;
  String _keyword = '';

  @override
  void initState() {
    super.initState();
    _loadSessions();
  }

  Future<void> _loadSessions() async {
    if (!tokenManager.isLoggedIn()) {
      if (mounted) setState(() => _loading = false);
      return;
    }
    try {
      final list = await SupportApi.listAiSessions();
      if (mounted) {
        setState(() {
          _sessions = list
              .map((e) => AiSessionSummary.fromJson(Map<String, dynamic>.from(e)))
              .where((e) => e.id.isNotEmpty)
              .toList();
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('加载失败：$e')));
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  List<Map<String, dynamic>> _groupedSessions() {
    final filtered = _sessions.where((s) {
      if (_keyword.isEmpty) return true;
      return (s.lastMessage ?? '').contains(_keyword);
    }).toList();

    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day).millisecondsSinceEpoch;
    final yesterdayStart = todayStart - 86400000;

    final groups = <String, List<AiSessionSummary>>{};
    for (final s in filtered) {
      final ts = s.lastMessageTime ?? 0;
      String label;
      if (ts >= todayStart) {
        label = '今天';
      } else if (ts >= yesterdayStart) {
        label = '昨天';
      } else {
        final dt = DateTime.fromMillisecondsSinceEpoch(ts);
        label = '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
      }
      groups.putIfAbsent(label, () => []).add(s);
    }
    return groups.entries
        .map((e) => {'dateGroup': e.key, 'items': e.value})
        .toList();
  }

  String _formatTime(int? ts) {
    if (ts == null) return '';
    final dt = DateTime.fromMillisecondsSinceEpoch(ts);
    return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final groups = _groupedSessions();

    return Scaffold(
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
              _buildSearchBar(),
              Expanded(
                child: _loading
                    ? const Center(child: CircularProgressIndicator(color: Colors.orange))
                    : !tokenManager.isLoggedIn()
                        ? _buildEmpty('请先登录查看对话记录')
                        : groups.isEmpty
                            ? _buildEmpty('暂无对话记录')
                            : ListView.builder(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                itemCount: groups.length,
                                itemBuilder: (context, gi) {
                                  final group = groups[gi];
                                  final items = group['items'] as List<AiSessionSummary>;
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 12),
                                        child: Text(
                                          group['dateGroup'] as String,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF666666),
                                          ),
                                        ),
                                      ),
                                      ...items.map((item) => _buildHistoryItem(item)),
                                    ],
                                  );
                                },
                              ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmpty(String text) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.chat_bubble_outline, size: 48, color: Colors.grey[400]),
          const SizedBox(height: 12),
          Text(text, style: TextStyle(color: Colors.grey[600])),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
          const Expanded(
            child: Text(
              '对话记录',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add_comment_outlined, size: 22),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const AiExclusiveView(newSession: true)),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFEFEFEF)),
        ),
        child: Row(
          children: [
            const Icon(Icons.search, size: 18, color: Color(0xFFBBBBBB)),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                decoration: const InputDecoration(
                  hintText: '搜索对话内容...',
                  hintStyle: TextStyle(fontSize: 14, color: Color(0xFFBBBBBB)),
                  border: InputBorder.none,
                  isDense: true,
                ),
                onChanged: (v) => setState(() => _keyword = v.trim()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryItem(AiSessionSummary item) {
    final title = item.lastMessage ?? '新对话';
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => AiExclusiveView(sessionId: item.id),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFF0F0F0)),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: Color(0xFFFFF0E5),
                shape: BoxShape.circle,
              ),
              child: const Center(child: Text('🤖', style: TextStyle(fontSize: 20))),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatTime(item.lastMessageTime),
                    style: const TextStyle(fontSize: 12, color: Color(0xFF999999)),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Color(0xFFCCCCCC)),
          ],
        ),
      ),
    );
  }
}
