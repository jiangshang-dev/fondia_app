import 'package:flutter/material.dart';

/// 浏览记录页面
class BrowsingHistoryView extends StatefulWidget {
  const BrowsingHistoryView({super.key});

  @override
  State<BrowsingHistoryView> createState() => _BrowsingHistoryViewState();
}

class _BrowsingHistoryViewState extends State<BrowsingHistoryView> {
  // 模拟按天分组的浏览记录数据
  final List<Map<String, dynamic>> _historyData = [
    {
      'date': '今天',
      'items': [
        {
          'title': '金黄酥脆大油条，配方比例全公开',
          'image': 'https://images.unsplash.com/photo-1509440159596-0249088772ff?w=150',
          'views': '12.8w次看过',
          'time': '10:25'
        },
        {
          'title': '老北京炸酱面，地道酱香的核心秘诀',
          'image': 'https://images.unsplash.com/photo-1585032226651-759b368d7246?w=150',
          'views': '4.5w次看过',
          'time': '09:12'
        }
      ]
    },
    {
      'date': '昨天',
      'items': [
        {
          'title': '巨好吃的泰式菠萝炒饭，酸甜开胃',
          'image': 'https://images.unsplash.com/photo-1606787366850-de6330128bfc?w=150',
          'views': '8.2w次看过',
          'time': '昨天 20:15'
        }
      ]
    },
    {
      'date': '更早之前',
      'items': [
        {
          'title': '冬日暖胃：胡椒猪肚鸡汤正宗做法',
          'image': 'https://images.unsplash.com/photo-1603252109303-2751441dd157?w=150',
          'views': '23w次看过',
          'time': '5月22日'
        }
      ]
    }
  ];

  /// 清空所有历史记录
  void _clearAllHistory() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('提示', style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text('确定要清空所有的浏览记录吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消', style: TextStyle(color: Colors.black54)),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _historyData.clear();
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('浏览记录已全部清空')),
              );
            },
            child: const Text('清空', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  /// 删除单条历史记录
  void _deleteOneItem(int groupIndex, int itemIndex) {
    setState(() {
      _historyData[groupIndex]['items'].removeAt(itemIndex);
      // 如果某一组（如“昨天”）下的条目被删光了，则移除该组标题
      if (_historyData[groupIndex]['items'].isEmpty) {
        _historyData.removeAt(groupIndex);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 保持产品全局的浅米色底色
      backgroundColor: const Color(0xfff9f6f3),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          '浏览记录',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          if (_historyData.isNotEmpty)
            TextButton(
              onPressed: _clearAllHistory,
              child: const Text(
                '清空',
                style: TextStyle(color: Colors.black54, fontSize: 15),
              ),
            ),
        ],
      ),
      body: _historyData.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        itemCount: _historyData.length,
        itemBuilder: (context, groupIndex) {
          final group = _historyData[groupIndex];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 时间分组标签（今天、昨天、更早）
              Padding(
                padding: const EdgeInsets.only(left: 4.0, top: 12.0, bottom: 10.0),
                child: Text(
                  group['date'],
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // 白底圆角卡片包裹内部条目
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(), // 由外层 ListView 统一滚动
                  itemCount: group['items'].length,
                  separatorBuilder: (context, index) => const Padding(
                    padding: EdgeInsets.only(left: 88.0), // 分割线避开左侧缩略图
                    child: Divider(height: 1, thickness: 0.5, color: Color(0xFFEEEEEE)),
                  ),
                  itemBuilder: (context, itemIndex) {
                    final item = group['items'][itemIndex];
                    return _buildHistoryItem(item, groupIndex, itemIndex);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  /// 构建单行足迹条目
  Widget _buildHistoryItem(Map<String, dynamic> item, int groupIndex, int itemIndex) {
    return InkWell(
      onTap: () {
        // TODO: 跳转至对应的菜谱播放或详情页
      },
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            // 1. 菜谱左侧正方形图片（大圆角）
            ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Image.network(
                item['image'],
                width: 64,
                height: 64,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 64,
                  height: 64,
                  color: Colors.black,
                  child: const Icon(Icons.restaurant, color: Colors.black26),
                ),
              ),
            ),
            const SizedBox(width: 12),

            // 2. 中间菜谱标题及热度描述
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['title'],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.local_fire_department_rounded, size: 14, color: Color(0xfff3a033)), // 主题橙色火苗
                      const SizedBox(width: 2),
                      Text(
                        item['views'],
                        style: const TextStyle(color: Colors.black38, fontSize: 12),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        item['time'],
                        style: const TextStyle(color: Colors.black26, fontSize: 11),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // 3. 右侧删除小交叉
            IconButton(
              icon: const Icon(Icons.clear_rounded, size: 16, color: Colors.black26),
              onPressed: () => _deleteOneItem(groupIndex, itemIndex),
            ),
          ],
        ),
      ),
    );
  }

  /// 空记录缺省状态
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 采用和主页契合的圆形时钟图标
          const Icon(Icons.history_toggle_off_rounded, size: 64, color: Colors.black12),
          const SizedBox(height: 16),
          const Text(
            '最近没有浏览记录哦~',
            style: TextStyle(color: Colors.black38, fontSize: 15),
          ),
        ],
      ),
    );
  }
}