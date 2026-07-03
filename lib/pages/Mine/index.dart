import 'package:flutter/material.dart';
import 'package:fondia/api/interaction.dart';
import 'package:fondia/api/user.dart';
import 'package:fondia/l10n/app_localizations.dart';
import 'package:fondia/models/user_profile.dart';
import 'package:fondia/pages/Mine/BrowsingHistory.dart';
import 'package:fondia/pages/Mine/Checkin.dart';
import 'package:fondia/pages/Mine/Collection.dart';
import 'package:fondia/pages/Mine/Feedback.dart';
import 'package:fondia/pages/Mine/Liked.dart';
import 'package:fondia/pages/Mine/MyComment.dart';
import 'package:fondia/pages/Mine/OnlineService.dart';
import 'package:fondia/pages/Mine/PointsLedger.dart';
import 'package:fondia/pages/Mine/PointsMall.dart';
import 'package:fondia/pages/Mine/PointsTasks.dart';
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
  int _collectCount = 0;
  int _likeCount = 0;
  int _browseCount = 0;
  UserProfile? _profile;

  @override
  void initState() {
    super.initState();
    _loadProfile();
    _loadInteractionCounts();
  }

  Future<void> _loadProfile() async {
    if (!tokenManager.isLoggedIn()) return;
    try {
      final profile = await UserApi.getProfile();
      if (!mounted) return;
      setState(() => _profile = profile);
      await tokenManager.saveUserInfo({
        ...profile.toUpdateJson(),
        'id': profile.id,
        'username': profile.username,
        'phone': profile.phone,
        'email': profile.email,
      });
    } catch (_) {}
  }

  Future<void> _loadInteractionCounts() async {
    if (!tokenManager.isLoggedIn()) return;
    try {
      final results = await Future.wait([
        InteractionApi.getMyCollectCount(),
        InteractionApi.getMyLikeCount(),
        InteractionApi.getMyBrowseCount(),
      ]);
      if (!mounted) return;
      setState(() {
        _collectCount = results[0];
        _likeCount = results[1];
        _browseCount = results[2];
      });
    } catch (_) {}
  }

  void _navigateToUserInfo() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const UserInfoView()),
    ).then((_) {
      _loadProfile();
    });
  }

  void _navigateToLogin() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    ).then((_) {
      _loadInteractionCounts();
      _loadProfile();
    });
  }

  void _openPage(Widget page) {
    if (!tokenManager.isLoggedIn()) {
      _navigateToLogin();
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    ).then((_) {
      _loadInteractionCounts();
      _loadProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
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
                _buildSection(l10n.myContent, _buildMyContentGrid(l10n)),
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
    final l10n = context.l10n;
    final isLoggedIn = tokenManager.isLoggedIn();
    final profile = _profile;
    final avatarUrl = profile?.avatarUrl;
    final hasAvatar = avatarUrl != null;

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
                      child: CircleAvatar(
                        radius: 35,
                        backgroundColor: const Color(0xFFEEEEEE),
                        backgroundImage:
                            hasAvatar ? NetworkImage(avatarUrl!) : null,
                        child: hasAvatar
                            ? null
                            : const Icon(Icons.person_outline,
                                color: Colors.grey, size: 30),
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
                                  profile?.displayName ?? tokenManager.getNickname(),
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
                                child: Text(
                                  'Lv.${profile?.cookingLevel ?? 4}',
                                  style: const TextStyle(
                                    color: Colors.orange,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Text(
                            profile?.displaySign ?? tokenManager.getSign(),
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
                              Text(
                                l10n.consecutiveCheckIn(profile?.checkInDays ?? 0),
                                style: const TextStyle(fontSize: 12),
                              ),
                              const Spacer(),
                              Text(
                                l10n.growthValue(profile?.growthValue ?? 0, 1000),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          LinearProgressIndicator(
                            value: profile?.growthProgress ?? 0,
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
                            Text(
                              l10n.clickToLogin,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              l10n.loginForMore,
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
    final l10n = context.l10n;
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
              Text(
                l10n.myPoints,
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              ),
              Text(
                l10n.pointsCount(_profile?.points ?? 0),
                style: const TextStyle(
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
                child: GestureDetector(
                  onTap: () {
                    if (!tokenManager.isLoggedIn()) {
                      _navigateToLogin();
                      return;
                    }
                    _openPage(const PointsLedgerView());
                  },
                  child: Text(
                    l10n.pointsDetail,
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ),
            ],
          ),
          _buildPointsIcon(Icons.assignment_turned_in, l10n.earnPoints, () => _openPage(const PointsTasksView())),
          _buildPointsIcon(Icons.calendar_month, l10n.dailyCheckIn, () => _openPage(const CheckinView())),
          _buildPointsIcon(Icons.shopping_bag, l10n.pointsMall, () => _openPage(const PointsMallView())),
        ],
      ),
    );
  }

  Widget _buildPointsIcon(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 30),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(color: Colors.white, fontSize: 12)),
        ],
      ),
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
  Widget _buildMyContentGrid(AppLocalizations l10n) {
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
            l10n.vipCenter,
            tokenManager.isLoggedIn() ? '' : '-',
            color: Colors.red,
            onTap: () => _openPage(const VipView()),
          ),
          // 跳转到收藏页面
          _buildGridItem(
            Icons.favorite,
            l10n.myCollection,
            tokenManager.isLoggedIn() ? '$_collectCount' : '-',
            color: Colors.red,
            onTap: () => _openPage(const CollectionView()),
          ),
          _buildGridItem(
            Icons.thumb_up,
            l10n.myLikes,
            tokenManager.isLoggedIn() ? '$_likeCount' : '-',
            color: Colors.orange,
            onTap: () => _openPage(const LikedView()),
          ),
          // _buildGridItem(
          //   Icons.comment,
          //   "我的评论",
          //   "36",
          //   color: Colors.blue,
          //   onTap: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(builder: (context) => const MyCommentView()),
          //     );
          //   },
          // ),
          _buildGridItem(
            Icons.history,
            l10n.browseHistory,
            tokenManager.isLoggedIn() ? '$_browseCount' : '-',
            color: Colors.indigo,
            onTap: () => _openPage(const BrowsingHistoryView()),
          ),
          _buildGridItem(
            Icons.chat,
            l10n.onlineService,
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
            l10n.feedback,
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
    final l10n = context.l10n;
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
            title: Text(l10n.settings),
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
            title: Text(l10n.notificationSettings),
            trailing: const Icon(Icons.chevron_right),
          ),
        ],
      ),
    );
  }
}
