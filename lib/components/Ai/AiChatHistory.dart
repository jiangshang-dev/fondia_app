import 'package:flutter/material.dart';

class AiChatHistoryView extends StatefulWidget {
  const AiChatHistoryView({super.key});

  @override
  State<AiChatHistoryView> createState() => _AiChatHistoryViewState();
}

class _AiChatHistoryViewState extends State<AiChatHistoryView> {
  // 模拟历史对话数据
  final List<Map<String, dynamic>> _historyGroups = [
    {
      'dateGroup': '今天',
      'items': [
        {
          'title': '家里只有鸡蛋、西红柿、土豆，推荐吃什么？',
          'time': '14:32',
          'replySummary': '已推荐：西红柿炒鸡蛋、土豆鸡蛋饼...',
          'tags': ['食材推荐', '家常菜']
        },
        {
          'title': '减肥期间晚餐吃什么好？',
          'time': '09:15',
          'replySummary': '建议选择高蛋白、低碳水低热量的食物...',
          'tags': ['减脂减重']
        }
      ]
    },
    {
      'dateGroup': '昨天',
      'items': [
        {
          'title': '孕妇可以吃海鲜吗？需要注意什么？',
          'time': '昨天 20:45',
          'replySummary': '可以适量食用煮熟的海鲜，避免高汞鱼类...',
          'tags': ['孕期饮食', '营养避坑']
        },
        {
          'title': '想增肌，怎么搭配一日三餐的饮食？',
          'time': '昨天 11:10',
          'replySummary': '增肌期需要保证碳水化合物与蛋白质的充足摄入...',
          'tags': ['运动增肌', '高蛋白']
        }
      ]
    },
    {
      'dateGroup': '更早',
      'items': [
        {
          'title': '糖尿病病人早餐推荐吃什么比较稳定血糖？',
          'time': '2026-05-20',
          'replySummary': '推荐燕麦麸皮、水煮蛋搭配无糖豆浆...',
          'tags': ['慢病调理', '低GI早餐']
        }
      ]
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 延续上一页的温馨微粉色渐变背景
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
              // 1. 自定义顶部导航栏
              _buildAppBar(),

              // 2. 搜索框
              _buildSearchBar(),

              // 3. 历史对话列表区
              Expanded(
                child: _historyGroups.isEmpty
                    ? _buildEmptyState() // 空状态处理
                    : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  itemCount: _historyGroups.length,
                  itemBuilder: (context, groupIndex) {
                    return _buildHistoryGroup(_historyGroups[groupIndex]);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 顶部导航栏组件
  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, size: 20, color: Color(0xFF333333)),
            onPressed: () => Navigator.maybePop(context),
          ),
          const Text(
            '对话记录',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF333333)),
          ),
          // 右侧清空按钮，方便用户管理隐私
          TextButton(
            onPressed: () {
              // 实际业务中加入二次确认弹窗
            },
            child: const Text('清空', style: TextStyle(color: Color(0xFF999999), fontSize: 14)),
          ),
        ],
      ),
    );
  }

  // 搜索框组件
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFEFEFEF)),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 4, offset: const Offset(0, 2)),
          ],
        ),
        child: const TextField(
          decoration: InputDecoration(
            hintText: '搜索历史对话关键词...',
            hintStyle: TextStyle(color: Color(0xFFBBBBBB), fontSize: 13),
            prefixIcon: Icon(Icons.search, color: Color(0xFF999999), size: 20),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(vertical: 9), // 垂直居中
          ),
        ),
      ),
    );
  }

  // 按日期分组构建历史
  Widget _buildHistoryGroup(Map<String, dynamic> group) {
    List<dynamic> items = group['items'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 时间分组标签（今天、昨天、更早）
        Padding(
          padding: const EdgeInsets.only(top: 12.0, left: 4.0),
          child: Text(
            group['dateGroup'],
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF888888)),
          ),
        ),
        // 分组内的卡片列表
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(), // 由外层 ListView 滚动
          itemCount: items.length,
          itemBuilder: (context, index) {
            return _buildHistoryCard(items[index]);
          },
        ),
      ],
    );
  }

  // 单个历史对话记录卡片
  Widget _buildHistoryCard(Map<String, dynamic> item) {
    List<String> tags = List<String>.from(item['tags']);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFFEFE5)), // 淡粉色边框，契合主UI
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFFE6D5).withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          // 点击历史记录还原对话详情逻辑
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 头部：提问标题与时间
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.chat_bubble_outline, size: 16, color: Color(0xFFFF8A4C)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      item['title'],
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF333333),
                          height: 1.3
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    item['time'],
                    style: const TextStyle(fontSize: 11, color: Color(0xFFBBBBBB)),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // 中部：AI 回复摘要
              Text(
                item['replySummary'],
                style: const TextStyle(fontSize: 12, color: Color(0xFF666666)),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              // 底部：功能标签 + 更多操作按钮
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // 标签群
                  Row(
                    children: tags.map((tag) => _buildCardTag(tag)).toList(),
                  ),
                  // 右下角删除或进入的箭头
                  const Icon(Icons.arrow_forward_ios, size: 12, color: Color(0xFFCCCCCC)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 卡片内部的小圆角标签
  Widget _buildCardTag(String label) {
    return Container(
      margin: const EdgeInsets.only(right: 6),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF2EB),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 10, color: Color(0xFFFF8A4C), fontWeight: FontWeight.w500),
      ),
    );
  }

  // 无数据时的空状态组件
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.forum_outlined, size: 64, color: Colors.grey[300]),
          const SizedBox(height: 16),
          const Text('暂无对话记录', style: TextStyle(color: Color(0xFF999999), fontSize: 14)),
        ],
      ),
    );
  }
}