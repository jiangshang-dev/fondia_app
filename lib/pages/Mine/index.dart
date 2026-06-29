import 'package:flutter/material.dart';
import 'package:fondia/pages/Mine/BrowsingHistory.dart';
import 'package:fondia/pages/Mine/Collection.dart';
import 'package:fondia/pages/Mine/Feedback.dart';
import 'package:fondia/pages/Mine/Liked.dart';
import 'package:fondia/pages/Mine/MyComment.dart';
import 'package:fondia/pages/Mine/OnlineService.dart';
import 'package:fondia/pages/Mine/Setting.dart';
import 'package:fondia/pages/Mine/UserInfo.dart';
import 'package:fondia/pages/Mine/VIP.dart';
import 'package:fondia/stores/TokenManager.dart';
import 'package:fondia/pages/Login/index.dart';

class MineView extends StatefulWidget {
  const MineView({super.key});

  @override
  State<MineView> createState() => _MineViewState();
}

class _MineViewState extends State<MineView> {
  void _navigateToUserInfo() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const UserInfoView()),
    );
  }

  void _navigateToLogin() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB),
      // 使用 SafeArea 避免遮挡顶部状态栏
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildHeader(),
                _buildPointsCard(),
                _buildSection("我的内容", _buildMyContentGrid()),
                // _buildSettingsList(), 设置
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 1. 顶部用户信息
  Widget _buildHeader() {
    final isLoggedIn = tokenManager.isLoggedIn();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Setting()),
                  );
                },
                icon: const Icon(Icons.settings_outlined),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.chat_bubble_outline),
              ),
            ],
          ),
          isLoggedIn
              ? Row(
                  children: [
                    GestureDetector(
                      onTap: _navigateToUserInfo,
                      child: const CircleAvatar(
                        radius: 35,
                        backgroundImage: NetworkImage(
                          'https://via.placeholder.com/150',
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              GestureDetector(
                                onTap: _navigateToUserInfo,
                                child: Text(
                                  tokenManager.getNickname(),
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.orange[100],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Text(
                                  'Lv.4',
                                  style: TextStyle(
                                    color: Colors.orange,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Text(
                            tokenManager.getSign(),
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(
                                Icons.calendar_today_outlined,
                                size: 14,
                                color: Colors.orange,
                              ),
                              const SizedBox(width: 4),
                              const Text(
                                '连续签到 3 天',
                                style: TextStyle(fontSize: 12),
                              ),
                              const Spacer(),
                              const Text(
                                '成长值 680/1000',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          LinearProgressIndicator(
                            value: 0.68,
                            backgroundColor: Colors.grey[200],
                            color: Colors.orange,
                            minHeight: 4,
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              : Row(
                  children: [
                    GestureDetector(
                      onTap: _navigateToLogin,
                      child: const CircleAvatar(
                        radius: 35,
                        backgroundColor: Color(0xFFEEEEEE),
                        child: Icon(
                          Icons.person_outline,
                          color: Colors.grey,
                          size: 30,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: GestureDetector(
                        onTap: _navigateToLogin,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '点击登录',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              '登录后享受更多功能',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.chevron_right,
                      color: Colors.grey,
                      size: 20,
                    ),
                  ],
                ),
        ],
      ),
    );
  }

  // 2. 积分卡片 (橙色渐变)
  Widget _buildPointsCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFA726), Color(0xFFFF7043)],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "我的积分",
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
              const Text(
                "1280 积分",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  "积分明细 >",
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ],
          ),
          _buildPointsIcon(Icons.assignment_turned_in, "去赚积分"),
          _buildPointsIcon(Icons.calendar_month, "每日签到"),
          _buildPointsIcon(Icons.shopping_bag, "积分商城"),
        ],
      ),
    );
  }

  Widget _buildPointsIcon(IconData icon, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 30),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 12)),
      ],
    );
  }

  // 3. 通用区块标题
  Widget _buildSection(
    String title,
    Widget content, {
    bool hasArrow = false,
    String? arrowText,
  }) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (hasArrow)
                Text(
                  "$arrowText >",
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
            ],
          ),
          const SizedBox(height: 12),
          content,
        ],
      ),
    );
  }

  // 4. 我的内容网格 (包含跳转逻辑)
  Widget _buildMyContentGrid() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 4,
        mainAxisSpacing: 16,
        children: [
          _buildGridItem(
            Icons.vaccines,
            "会员中心",
            "56",
            color: Colors.red,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const VipView()),
              );
            },
          ),
          // 跳转到收藏页面
          _buildGridItem(
            Icons.favorite,
            "我的收藏",
            "56",
            color: Colors.red,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CollectionView()),
              );
            },
          ),
          _buildGridItem(
            Icons.thumb_up,
            "我的点赞",
            "128",
            color: Colors.orange,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LikedView()),
              );
            },
          ),
          _buildGridItem(
            Icons.comment,
            "我的评论",
            "36",
            color: Colors.blue,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MyCommentView()),
              );
            },
          ),
          _buildGridItem(
            Icons.history,
            "浏览记录",
            "89",
            color: Colors.indigo,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const BrowsingHistoryView(),
                ),
              );
            },
          ),
          _buildGridItem(
            Icons.chat,
            "在线客服",
            "18",
            color: Colors.amber,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const OnlineServiceView(),
                ),
              );
            },
          ),
          _buildGridItem(
            Icons.feedback,
            "意见反馈",
            "19",
            color: Colors.amber,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FeedbackView()),
              );
            },
          ),
          // _buildGridItem(Icons.restaurant, "做过的菜", "18", color: Colors.amber),
        ],
      ),
    );
  }

  Widget _buildGridItem(
    IconData icon,
    String label,
    String count, {
    Color color = Colors.grey,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 12)),
          Text(count, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }

  // 7. 设置列表
  Widget _buildSettingsList() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text("设置"),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Setting()),
              );
            },
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.notifications_none),
            title: const Text("通知设置"),
            trailing: const Icon(Icons.chevron_right),
          ),
        ],
      ),
    );
  }
}
