
import 'package:flutter/material.dart';

class DishDetail extends StatefulWidget {
  const DishDetail({super.key});

  @override
  State<DishDetail> createState() => _DishDetailState();
}

class _DishDetailState extends State<DishDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: MediaQuery.removePadding(
        context: context,
        removeTop: true, // 移除顶部安全区域遮挡，让视频顶格
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. 视频播放器区域
              _buildVideoPlayer(),

              // 2. 标题与描述
              _buildTitleSection(),

              // 3. 烹饪信息栏 (时间/难度/热量)
              _buildInfoBar(),

              const Divider(height: 1, thickness: 1, color: Color(0xFFF5F5F5)),

              // 4. 食材准备
              _buildIngredientsSection(),

              const Divider(height: 1, thickness: 1, color: Color(0xFFF5F5F5)),

              // 5. 图文步骤
              _buildStepsSection(),

              // 6. 评论区
              _buildCommentSection(),
            ],
          ),
        ),
      ),
    );
  }

  // 视频播放器模拟组件
  Widget _buildVideoPlayer() {
    return Stack(
      children: [
        AspectRatio(
          aspectRatio: 16 / 10,
          child: Image.network(
            'https://placeholder.com/600x400', // 这里放红烧肉封面图
            fit: BoxFit.cover,
          ),
        ),
        // 视频遮罩与控制按钮
        Positioned.fill(
          child: Container(
            color: Colors.black.withOpacity(0.1),
            child: const Center(
              child: Icon(Icons.play_circle_fill, color: Colors.white, size: 64),
            ),
          ),
        ),
        // 返回键与收藏分享
        Positioned(
          top: 44,
          left: 16,
          right: 16,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
              Row(
                children: [
                  Icon(Icons.star_border, color: Colors.white),
                  SizedBox(width: 4),
                  Text('收藏', style: TextStyle(color: Colors.white)),
                  SizedBox(width: 16),
                  Icon(Icons.share, color: Colors.white),
                ],
              )
            ],
          ),
        ),
        // 视频进度条模拟
        Positioned(
          bottom: 12,
          left: 16,
          right: 16,
          child: Row(
            children: [
              const Icon(Icons.play_arrow, color: Colors.white, size: 20),
              const Text(' 00:12', style: TextStyle(color: Colors.white, fontSize: 12)),
              Expanded(
                child: Slider(value: 0.1, onChanged: (v) {}, activeColor: Colors.orange, inactiveColor: Colors.white30),
              ),
              const Text('03:28 ', style: TextStyle(color: Colors.white, fontSize: 12)),
              const Icon(Icons.fullscreen, color: Colors.white, size: 20),
            ],
          ),
        ),
        // 右侧侧边栏 (点赞/评论)
        Positioned(
          right: 16,
          top: 100,
          child: Column(
            children: [
              _buildVideoSideAction(Icons.favorite, '2.1万'),
              _buildVideoSideAction(Icons.message, '856'),
              // _buildVideoSideAction(Icons. Assignment_turned_in, '做过'),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildVideoSideAction(IconData icon, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 28),
          Text(label, style: const TextStyle(color: Colors.white, fontSize: 12)),
        ],
      ),
    );
  }

  // 标题和标签
  Widget _buildTitleSection() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('红烧肉', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text('肥而不腻，软糯入味，经典家常菜', style: TextStyle(fontSize: 14, color: Colors.grey)),
          const SizedBox(height: 12),
          Row(
            children: ['东北菜', '家常菜', '炖菜', '咸香味'].map((tag) => Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(color: const Color(0xFFF5F5F5), borderRadius: BorderRadius.circular(4)),
              child: Text(tag, style: const TextStyle(fontSize: 12, color: Colors.grey)),
            )).toList(),
          ),
        ],
      ),
    );
  }

  // 信息栏
  Widget _buildInfoBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildInfoItem(Icons.access_time, '60分钟', '烹饪时间'),
          _buildInfoItem(Icons.bar_chart, '中等', '难度'),
          _buildInfoItem(Icons.local_fire_department, '热量约 620 大卡', '每100克'),
        ],
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String top, String bottom) {
    return Column(
      children: [
        Row(children: [Icon(icon, size: 16, color: Colors.orange), Text(' $top', style: const TextStyle(fontWeight: FontWeight.w500))]),
        const SizedBox(height: 4),
        Text(bottom, style: const TextStyle(fontSize: 11, color: Colors.grey)),
      ],
    );
  }

  // 食材准备
  Widget _buildIngredientsSection() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('食材准备', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text('2-3人份', style: TextStyle(color: Colors.grey, fontSize: 13)),
            ],
          ),
          const SizedBox(height: 16),
          _buildIngredientRow('五花肉', '500克', '冰糖', '20克'),
          _buildIngredientRow('生姜', '4片', '大葱', '1根'),
          _buildIngredientRow('料酒', '2勺', '老抽', '1勺'),
        ],
      ),
    );
  }

  Widget _buildIngredientRow(String n1, String v1, String n2, String v2) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(child: Row(children: [
            Container(width: 30, height: 30, decoration: BoxDecoration(color: Colors.orange.withOpacity(0.1), shape: BoxShape.circle)),
            const SizedBox(width: 8),
            Text(n1), Spacer(), Text(v1, style: const TextStyle(color: Colors.grey)),
          ])),
          const SizedBox(width: 40),
          Expanded(child: Row(children: [
            Container(width: 30, height: 30, decoration: BoxDecoration(color: Colors.orange.withOpacity(0.1), shape: BoxShape.circle)),
            const SizedBox(width: 8),
            Text(n2), Spacer(), Text(v2, style: const TextStyle(color: Colors.grey)),
          ])),
        ],
      ),
    );
  }

  // 图文步骤
  Widget _buildStepsSection() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('图文步骤', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          _buildStepItem(1, '五花肉切麻将块，冷水下锅，加入姜片、料酒，焯水去腥，捞出沥干。', '焯水时间：5分钟'),
          _buildStepItem(2, '锅中放少许油，加入冰糖，小火炒至融化，变成枣红色。', '小火慢炒，注意别糊'),
        ],
      ),
    );
  }

  Widget _buildStepItem(int step, String desc, String tip) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(radius: 10, backgroundColor: Colors.orange, child: Text('$step', style: const TextStyle(color: Colors.white, fontSize: 12))),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network('https://placeholder.com/300x150', fit: BoxFit.cover),
                ),
                const SizedBox(height: 8),
                Text(desc, style: const TextStyle(height: 1.5)),
                Text(tip, style: const TextStyle(color: Colors.grey, fontSize: 12, height: 1.8)),
              ],
            ),
          )
        ],
      ),
    );
  }

  // 评论区简易模拟
  Widget _buildCommentSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: const Color(0xFFFAFAFA),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                child: const Text('发表评论...', style: TextStyle(color: Colors.grey, fontSize: 14)),
              )),
              const SizedBox(width: 16),
              const Text('发送', style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CircleAvatar(radius: 18, backgroundImage: NetworkImage('https://placeholder.com/50')),
              const SizedBox(width: 12),
              Expanded(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('小雪爱做饭  Lv.4', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                  SizedBox(height: 4),
                  Text('这个红烧肉做得太棒了，按照步骤来，软糯入味，全家都爱吃！'),
                ],
              ))
            ],
          )
        ],
      ),
    );
  }
}
