import 'package:flutter/material.dart';
import 'package:fondia/components/Mine/Language.dart';
import 'package:fondia/pages/Login/index.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  // 控制开关状态的变量
  bool _isDarkMode = false;
  bool _isOnlyWifiDownload = true;
  bool _autoPlayVideo = false;

  bool _notifyComment = true;
  bool _notifyLike = true;
  bool _notifyFollow = true;
  bool _notifyActivity = true;
  bool _notifySystem = true;
  bool _emailSubscription = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F6F3), // 浅米色背景
      appBar: AppBar(
        backgroundColor: const Color(0xFFF9F6F3),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black87,
            size: 20,
          ),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: const Text(
          '设置',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton.icon(
            onPressed: () {},
            icon: const Icon(
              Icons.help_outline,
              color: Colors.black87,
              size: 18,
            ),
            label: const Text(
              '帮助',
              style: TextStyle(color: Colors.black87, fontSize: 14),
            ),
          ),
        ],
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          // 1. 账号与安全
          _buildSectionTitle('账号与安全'),
          _buildGroupCard([
            _buildListTile(Icons.person_outline, '个人资料'),
            _buildListTile(
              Icons.phone_android_outlined,
              '手机号绑定',
              trailingText: '138****5678',
            ),
            _buildListTile(
              Icons.link_outlined,
              '账号绑定',
              trailingWidget: _buildSocialIcons(),
            ),
            _buildListTile(Icons.lock_open_outlined, '修改密码'),
            _buildListTile(
              Icons.important_devices_outlined,
              '登录设备管理',
              trailingText: '2台设备在线',
            ),
            _buildListTile(Icons.verified_user_outlined, '隐私设置'),
            _buildListTile(Icons.person_remove_outlined, '注销账号'),
          ]),

          // 2. 通用设置
          _buildSectionTitle('通用设置'),
          _buildGroupCard([
            _buildListTile(
              Icons.language_outlined,
              '语言设置',
              trailingText: '简体中文',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Language()),
                );
              },
            ),
            _buildSwitchTile(
              Icons.dark_mode_outlined,
              '深色模式',
              _isDarkMode,
              (v) => setState(() => _isDarkMode = v),
            ),
            _buildListTile(
              Icons.font_download_outlined,
              '字体大小',
              trailingText: '中',
            ),
            _buildListTile(Icons.delete_outline, '清除缓存', trailingText: '256MB'),
            _buildListTile(Icons.file_download_outlined, '下载管理'),
            _buildSwitchTile(
              Icons.wifi_outlined,
              '仅Wi-Fi下载',
              _isOnlyWifiDownload,
              (v) => setState(() => _isOnlyWifiDownload = v),
            ),
            _buildSwitchTile(
              Icons.play_circle_outline,
              '自动播放视频',
              _autoPlayVideo,
              (v) => setState(() => _autoPlayVideo = v),
            ),
          ]),

          // 3. 消息通知
          _buildSectionTitle('消息通知'),
          _buildGroupCard([
            _buildSwitchTile(
              Icons.notifications_none_outlined,
              '评论通知',
              _notifyComment,
              (v) => setState(() => _notifyComment = v),
            ),
            _buildSwitchTile(
              Icons.eighteen_mp,
              '点赞通知',
              _notifyLike,
              (v) => setState(() => _notifyLike = v),
            ),
            _buildSwitchTile(
              Icons.person_add_alt_1_outlined,
              '粉丝关注通知',
              _notifyFollow,
              (v) => setState(() => _notifyFollow = v),
            ),
            _buildSwitchTile(
              Icons.card_giftcard_outlined,
              '活动消息通知',
              _notifyActivity,
              (v) => setState(() => _notifyActivity = v),
            ),
            _buildSwitchTile(
              Icons.campaign_outlined,
              '系统公告通知',
              _notifySystem,
              (v) => setState(() => _notifySystem = v),
            ),
            _buildSwitchTile(
              Icons.mail_outline,
              '邮件订阅',
              _emailSubscription,
              (v) => setState(() => _emailSubscription = v),
            ),
          ]),

          // 4. 厨房偏好设置
          _buildSectionTitle('厨房偏好设置'),
          _buildGroupCard([
            _buildListTile(Icons.notifications_active_outlined, '智能推荐偏好'),
            _buildListTile(Icons.restaurant_menu_outlined, '忌口设置'),
            _buildListTile(
              Icons.assignment_outlined,
              '饮食目标设置',
              trailingText: '健康饮食',
            ),
            _buildListTile(Icons.warning_amber_outlined, '食材过敏提醒'),
            _buildListTile(Icons.layers_outlined, '食谱难度偏好', trailingText: '中等'),
            _buildListTile(
              Icons.access_time,
              '每日推荐时间',
              trailingText: '上午 7:00',
            ),
          ]),

          // 5. 关于我们
          _buildSectionTitle('关于我们'),
          _buildGroupCard([
            _buildListTile(Icons.description_outlined, '用户协议'),
            _buildListTile(Icons.privacy_tip_outlined, '隐私政策'),
            _buildListTile(Icons.info_outline, '关于小厨爱做饭'),
            _buildListTile(
              Icons.cloud_upload_outlined,
              '版本更新',
              trailingText: 'V1.2.0',
            ),
            _buildListTile(Icons.rate_review_outlined, '意见反馈'),
            _buildListTile(Icons.headset_mic_outlined, '联系客服'),
            _buildListTile(Icons.star_border_outlined, '给我们评分'),
          ]),

          const SizedBox(height: 24),

          // 底部退出和删除账号按钮
          TextButton.icon(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
                (route) => false,
              );
            },
            icon: const Icon(Icons.exit_to_app, color: Colors.redAccent),
            label: const Text(
              '退出登录',
              style: TextStyle(color: Colors.redAccent, fontSize: 16),
            ),
          ),
          TextButton.icon(
            onPressed: () {},
            icon: const Icon(
              Icons.no_accounts_outlined,
              color: Colors.redAccent,
            ),
            label: const Text(
              '删除账号',
              style: TextStyle(color: Colors.redAccent, fontSize: 16),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  // 统一的区块标题
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, top: 16, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  // 白底圆角卡片容器
  Widget _buildGroupCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(children: children),
    );
  }

  // 通用的跳转行组件
  Widget _buildListTile(
    IconData icon,
    String title, {
    String? trailingText,
    Widget? trailingWidget,
    VoidCallback? onTap,
  }) {
    return ListTile(
      minLeadingWidth: 20,
      leading: Icon(
        icon,
        color: const Color(0xFFFF9800),
        size: 22,
      ), // 统一使用UI中的橙色色调图标
      title: Text(
        title,
        style: const TextStyle(fontSize: 14, color: Colors.black87),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trailingText != null)
            Text(
              trailingText,
              style: const TextStyle(fontSize: 13, color: Colors.grey),
            ),
          if (trailingWidget != null) trailingWidget,
          const SizedBox(width: 4),
          const Icon(Icons.arrow_forward_ios, size: 12, color: Colors.grey),
        ],
      ),
      onTap: onTap,
    );
  }

  // 通用的开关行组件
  Widget _buildSwitchTile(
    IconData icon,
    String title,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return ListTile(
      minLeadingWidth: 20,
      leading: Icon(icon, color: const Color(0xFFFF9800), size: 22),
      title: Text(
        title,
        style: const TextStyle(fontSize: 14, color: Colors.black87),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: Colors.white,
        activeTrackColor: const Color(0xFFFF9800), // 开关激活时为UI图中的橙色
      ),
    );
  }

  // 模拟账号绑定的第三方图标 (微信、苹果、谷歌)
  Widget _buildSocialIcons() {
    return const Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.wechat, color: Colors.green, size: 18),
        SizedBox(width: 6),
        Icon(Icons.apple, color: Colors.black, size: 18),
        SizedBox(width: 6),
        Icon(Icons.g_mobiledata, color: Colors.blue, size: 22),
      ],
    );
  }
}
