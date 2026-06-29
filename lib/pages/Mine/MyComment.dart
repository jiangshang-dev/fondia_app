import 'package:flutter/material.dart';

/// 我的评论页面
class MyCommentView extends StatefulWidget {
  const MyCommentView({super.key});

  @override
  State<MyCommentView> createState() => _MyCommentViewState();
}

class _MyCommentViewState extends State<MyCommentView> {
  // 模拟评论数据列表
  final List<Map<String, dynamic>> _comments = [
    {
      'id': '1',
      'recipeTitle': '秘制红烧肉，肥而不腻超下饭',
      'recipeImage': 'https://images.unsplash.com/photo-1603252109303-2751441dd157?w=150',
      'commentContent': '按照这个配方做出来的红烧肉简直绝了！家里老人小孩都特别爱吃，糖色炒得很成功，感谢大厨分享！',
      'time': '2026-05-20 12:30',
      'likeCount': 12,
    },
    {
      'id': '2',
      'recipeTitle': '夏日必备：清爽柠檬手撕鸡',
      'recipeImage': 'https://images.unsplash.com/photo-1606787366850-de6330128bfc?w=150',
      'commentContent': '味道真的很清爽，酸酸辣辣的特别开胃，就是柠檬籽一定要去干净，不然会有一点点发苦。',
      'time': '2026-05-18 18:45',
      'likeCount': 5,
    },
    {
      'id': '3',
      'recipeTitle': '新手零失败：松软提子生吐司',
      'recipeImage': 'https://images.unsplash.com/photo-1509440159596-0249088772ff?w=150',
      'commentContent': '揉面揉了好久终于出膜了，烤出来满屋子都是奶香味，超级拉丝！',
      'time': '2026-05-12 09:15',
      'likeCount': 0,
    },
  ];

  /// 删除评论交互
  void _deleteComment(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('提示', style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text('确定要删除这条评论吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消', style: TextStyle(color: Colors.black54)),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _comments.removeAt(index);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('评论已删除')),
              );
            },
            child: const Text('删除', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff9f6f3),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          '我的评论',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: _comments.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        itemCount: _comments.length,
        itemBuilder: (context, index) {
          final item = _comments[index];
          return _buildCommentCard(item, index);
        },
      ),
    );
  }

  /// 构建单条评论卡片
  Widget _buildCommentCard(Map<String, dynamic> item, int index) {
    return Container(
      // === 这里已经修复：补上了原来的开括号 ( ===
      margin: const EdgeInsets.only(bottom: 14.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 头部：时间与操作
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                item['time'],
                style: const TextStyle(color: Colors.black38, fontSize: 13),
              ),
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: const Icon(Icons.delete_outline, size: 18, color: Colors.black38),
                onPressed: () => _deleteComment(index),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // 核心：评论的具体内容
          Text(
            item['commentContent'],
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 15,
              height: 1.5,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 14),

          // 被评论的菜谱主体
          InkWell(
            onTap: () {
              // 跳转菜谱详情
            },
            child: Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: const Color(0xfff7f5f2),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6.0),
                    child: Image.network(
                      item['recipeImage'],
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: 50,
                        height: 50,
                        color: Colors.black,
                        child: const Icon(Icons.restaurant, color: Colors.black26, size: 20),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '评论了菜谱',
                          style: TextStyle(color: Colors.black38, fontSize: 11),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item['recipeTitle'],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.black87,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios, size: 12, color: Colors.black26),
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),
          // 底部互动
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Icon(Icons.thumb_up_alt_rounded, size: 14, color: Color(0xfff3a033)),
              const SizedBox(width: 4),
              Text(
                '${item['likeCount']} 人赞过',
                style: const TextStyle(color: Colors.black45, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 空数据状态
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.chat_bubble_outline_rounded, size: 64, color: Colors.black12),
          const SizedBox(height: 16),
          const Text(
            '暂无评论记录',
            style: TextStyle(color: Colors.black38, fontSize: 15),
          ),
        ],
      ),
    );
  }
}