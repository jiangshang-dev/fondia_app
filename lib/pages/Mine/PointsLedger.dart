import 'package:flutter/material.dart';
import 'package:fondia/api/member.dart';
import 'package:fondia/models/member_models.dart';

class PointsLedgerView extends StatefulWidget {
  const PointsLedgerView({super.key});

  @override
  State<PointsLedgerView> createState() => _PointsLedgerViewState();
}

class _PointsLedgerViewState extends State<PointsLedgerView> {
  final List<PointsLedgerItem> _items = [];
  int _pageNo = 1;
  bool _loading = false;
  bool _hasMore = true;

  @override
  void initState() {
    super.initState();
    _loadMore();
  }

  Future<void> _loadMore() async {
    if (_loading || !_hasMore) return;
    setState(() => _loading = true);
    try {
      final page = await MemberApi.getPointsLedger(pageNo: _pageNo);
      if (!mounted) return;
      setState(() {
        _items.addAll(page.records);
        _hasMore = _items.length < page.total;
        _pageNo++;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString().replaceFirst('DioException: ', ''))),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  String _formatTime(int ts) {
    if (ts <= 0) return '-';
    final d = DateTime.fromMillisecondsSinceEpoch(ts);
    return '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')} '
        '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB),
      appBar: AppBar(
        title: const Text('积分明细', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 18, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            _items.clear();
            _pageNo = 1;
            _hasMore = true;
          });
          await _loadMore();
        },
        child: ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: _items.length + (_hasMore ? 1 : 0),
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            if (index >= _items.length) {
              _loadMore();
              return const Center(child: Padding(padding: EdgeInsets.all(16), child: CircularProgressIndicator()));
            }
            final item = _items[index];
            final positive = item.changeAmount >= 0;
            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.title ?? item.bizType, style: const TextStyle(fontWeight: FontWeight.w600)),
                        const SizedBox(height: 4),
                        Text(_formatTime(item.createTime), style: const TextStyle(color: Colors.grey, fontSize: 12)),
                      ],
                    ),
                  ),
                  Text(
                    '${positive ? '+' : ''}${item.changeAmount}',
                    style: TextStyle(
                      color: positive ? const Color(0xFFFF7043) : Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
