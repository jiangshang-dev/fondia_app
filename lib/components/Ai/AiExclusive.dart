import 'package:flutter/material.dart';
import 'package:fondia/components/Ai/AiChatHistory.dart';

class AiExclusiveView extends StatefulWidget {
  const AiExclusiveView({super.key});

  @override
  State<AiExclusiveView> createState() => _AiExclusiveViewState();
}

class _AiExclusiveViewState extends State<AiExclusiveView> {
  // 模拟推荐的提示词数据
  final List<String> _suggestions = [
    '减肥期间晚餐吃什么好？',
    '糖尿病病人早餐推荐',
    '孕妇可以吃海鲜吗？',
    '想增肌，怎么搭配饮食？'
  ];

  // 模拟菜谱数据
  final List<Map<String, String>> _recipes = [
    {
      'title': '西红柿炒鸡蛋',
      'info': '约 280 kcal | 15 分钟',
      'image': 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=200&auto=format&fit=crop', // 占位图，实际可换成本地资产
    },
    {
      'title': '土豆鸡蛋饼',
      'info': '约 320 kcal | 20 分钟',
      'image': 'https://images.unsplash.com/photo-1525351484163-7529414344d8?w=200&auto=format&fit=crop',
    },
    {
      'title': '番茄土豆汤',
      'info': '约 180 kcal | 25 分钟',
      'image': 'https://images.unsplash.com/photo-1547592180-85f173990554?w=200&auto=format&fit=crop',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 使用渐变背景色还原设计图的温馨氛围
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
              // 1. 顶部自定义导航栏
              _buildAppBar(),

              // 2. 聊天主体内容区
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  children: [
                    const SizedBox(height: 16),
                    // AI 助手欢迎信息
                    _buildWelcomeHeader(),
                    const SizedBox(height: 16),
                    // 推荐快捷提问标签
                    _buildSuggestionTags(),
                    const SizedBox(height: 24),
                    // 用户提问气泡
                    _buildUserMessage('家里只有鸡蛋、西红柿、土豆，推荐吃什么？'),
                    const SizedBox(height: 20),
                    // AI 菜谱推荐回复
                    _buildAiResponse(),
                    const SizedBox(height: 16),
                  ],
                ),
              ),

              // 3. 底部操作区（快捷按钮 + 输入框）
              _buildBottomActionArea(),
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
            'AI 助手',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF333333)),
          ),
          TextButton.icon(
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AiChatHistoryView())
            ),
            icon: const Icon(Icons.history, size: 16, color: Color(0xFF666666)),
            label: const Text(
                '对话记录', 
                style: TextStyle(color: Color(0xFF666666), fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  // 欢迎头部组件
  Widget _buildWelcomeHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // AI 头像
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: const Color(0xFFF0F0F0),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5)],
          ),
          child: const Center(
            child: Text('🤖', style: TextStyle(fontSize: 28)), // 可替换为具体的 Image.asset
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text(
                    'Hi，我是你的 AI 营养师',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF333333)),
                  ),
                  const SizedBox(width: 4),
                  const Text('👋', style: TextStyle(fontSize: 16)),
                ],
              ),
              const SizedBox(height: 6),
              const Text(
                '关于饮食、营养、搭配的问题都可以问我~',
                style: TextStyle(fontSize: 13, color: Color(0xFF999999)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // 横向滑动推荐标签组件
  Widget _buildSuggestionTags() {
    return SizedBox(
      height: 76,
      child: GridView.builder(
        scrollDirection: Axis.horizontal,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          childAspectRatio: 0.32, // 调整长宽比以完整包裹文字
        ),
        itemCount: _suggestions.length,
        itemBuilder: (context, index) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFFEFEFEF)),
            ),
            alignment: Alignment.center,
            child: Text(
              _suggestions[index],
              style: const TextStyle(fontSize: 12, color: Color(0xFF555555)),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          );
        },
      ),
    );
  }

  // 用户消息气泡组件
  Widget _buildUserMessage(String text) {
    return Row(
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
              text,
              style: const TextStyle(fontSize: 14, color: Color(0xFF6B3A1A), height: 1.4),
            ),
          ),
        ),
      ],
    );
  }

  // AI 回复组件（包含菜谱列表）
  Widget _buildAiResponse() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // AI 小头像
        Container(
          width: 32,
          height: 32,
          decoration: const BoxDecoration(color: Color(0xFFEAEAEA), shape: BoxShape.circle),
          child: const Center(child: Text('🤖', style: TextStyle(fontSize: 18))),
        ),
        const SizedBox(width: 8),
        // 回复卡片主体
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
                const Text(
                  '好的，根据你提供的食材，推荐以下菜谱：',
                  style: TextStyle(fontSize: 14, color: Color(0xFF333333), fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 12),
                // 菜谱列表循环渲染
                ..._recipes.map((recipe) => _buildRecipeCard(recipe)),
                const SizedBox(height: 8),
                const Text(
                  '需要我帮你生成详细做法吗？',
                  style: TextStyle(fontSize: 13, color: Color(0xFF666666)),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // 单个菜谱卡片条目
  Widget _buildRecipeCard(Map<String, String> recipe) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFF5F5F5)),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              recipe['image']!,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 50,
                height: 50,
                color: Colors.grey[200],
                child: const Icon(Icons.fastfood, size: 20, color: Colors.grey),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  recipe['title']!,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF333333)),
                ),
                const SizedBox(height: 4),
                Text(
                  recipe['info']!,
                  style: const TextStyle(fontSize: 11, color: Color(0xFF999999)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 底部复合操作面板（操作按钮群 + 输入栏）
  Widget _buildBottomActionArea() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 快捷连招按钮行
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildBottomQuickButton(Icons.refresh, '换一批'),
              _buildBottomQuickButton(Icons.assignment, '详细做法'),
              _buildBottomQuickButton(Icons.swap_horiz, '食材替换'),
            ],
          ),
          const SizedBox(height: 12),
          // 真正的对话输入框
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
                  child: Row(
                    children: [
                      const Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: '输入你的问题...',
                            hintStyle: TextStyle(color: Color(0xFFBBBBBB), fontSize: 14),
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      ),
                      // 语音输入按钮 icon
                      IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        icon: const Icon(Icons.mic_none, color: Color(0xFFFFA26B)),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              // 发送右侧橙色圆形按钮
              Container(
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
                child: IconButton(
                  icon: const Icon(Icons.send, color: Colors.white, size: 18),
                  onPressed: () {},
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  // 底部圆角胶囊快捷按钮构建器
  Widget _buildBottomQuickButton(IconData icon, String label) {
    return Container(
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
    );
  }
}