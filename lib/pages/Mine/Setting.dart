import 'package:flutter/material.dart';
import 'package:fondia/components/common/FondiaAppBar.dart';
import 'package:fondia/components/common/SettingsGroupCard.dart';
import 'package:fondia/components/common/SettingsListTile.dart';
import 'package:fondia/components/common/SettingsSectionTitle.dart';
import 'package:fondia/components/common/SettingsSwitchTile.dart';
import 'package:fondia/constants/AppTheme.dart';
import 'package:fondia/pages/Login/index.dart';
import 'package:fondia/pages/Mine/Account.dart';
import 'package:fondia/pages/Mine/DeleteAccount.dart';
import 'package:fondia/pages/Mine/Language.dart';
import 'package:fondia/pages/Mine/Phone.dart';
import 'package:fondia/pages/Mine/PrivacySettings.dart';
import 'package:fondia/stores/TokenManager.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
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
      backgroundColor: AppColors.backgroundCream,
      appBar: FondiaAppBar(
        title: '设置',
        backgroundColor: AppColors.backgroundCream,
        actions: [
          TextButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.help_outline, color: AppColors.textSecondary, size: 18),
            label: const Text('帮助', style: TextStyle(color: AppColors.textSecondary, fontSize: 14)),
          ),
        ],
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          SettingsSectionTitle(title: '账号与安全'),
          SettingsGroupCard(children: [
            SettingsListTile(
              icon: Icons.phone_android_outlined,
              title: '手机号绑定',
              trailingText: '138****5678',
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PhoneView())),
            ),
            SettingsListTile(
              icon: Icons.link_outlined,
              title: '账号绑定',
              trailingWidget: _socialIcons(),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const Account())),
            ),
            const SettingsListTile(icon: Icons.lock_open_outlined, title: '修改密码'),
            // const SettingsListTile(
            //   icon: Icons.important_devices_outlined,
            //   title: '登录设备管理',
            //   trailingText: '2台设备在线',
            // ),
            // SettingsListTile(
            //   icon: Icons.verified_user_outlined,
            //   title: '隐私设置',
            //   onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PrivacySettings())),
            // ),
            SettingsListTile(
              icon: Icons.person_remove_outlined,
              title: '注销账号',
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DeleteAccountView())),
            ),
          ]),

          SettingsSectionTitle(title: '通用设置'),
          SettingsGroupCard(children: [
            SettingsListTile(
              icon: Icons.language_outlined,
              title: '语言设置',
              trailingText: '简体中文',
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const Language())),
            ),
            SettingsSwitchTile(
              icon: Icons.dark_mode_outlined,
              title: '深色模式',
              value: _isDarkMode,
              onChanged: (v) => setState(() => _isDarkMode = v),
            ),
            const SettingsListTile(icon: Icons.font_download_outlined, title: '字体大小', trailingText: '中'),
            const SettingsListTile(icon: Icons.delete_outline, title: '清除缓存', trailingText: '256MB'),
            const SettingsListTile(icon: Icons.file_download_outlined, title: '下载管理'),
            // SettingsSwitchTile(
            //   icon: Icons.wifi_outlined,
            //   title: '仅Wi-Fi下载',
            //   value: _isOnlyWifiDownload,
            //   onChanged: (v) => setState(() => _isOnlyWifiDownload = v),
            // ),
            // SettingsSwitchTile(
            //   icon: Icons.play_circle_outline,
            //   title: '自动播放视频',
            //   value: _autoPlayVideo,
            //   onChanged: (v) => setState(() => _autoPlayVideo = v),
            // ),
          ]),

          SettingsSectionTitle(title: '消息通知'),
          SettingsGroupCard(children: [
            // SettingsSwitchTile(
            //   icon: Icons.notifications_none_outlined,
            //   title: '评论通知',
            //   value: _notifyComment,
            //   onChanged: (v) => setState(() => _notifyComment = v),
            // ),
            // SettingsSwitchTile(
            //   icon: Icons.eighteen_mp,
            //   title: '点赞通知',
            //   value: _notifyLike,
            //   onChanged: (v) => setState(() => _notifyLike = v),
            // ),
            // SettingsSwitchTile(
            //   icon: Icons.person_add_alt_1_outlined,
            //   title: '粉丝关注通知',
            //   value: _notifyFollow,
            //   onChanged: (v) => setState(() => _notifyFollow = v),
            // ),
            // SettingsSwitchTile(
            //   icon: Icons.card_giftcard_outlined,
            //   title: '活动消息通知',
            //   value: _notifyActivity,
            //   onChanged: (v) => setState(() => _notifyActivity = v),
            // ),
            // SettingsSwitchTile(
            //   icon: Icons.campaign_outlined,
            //   title: '系统公告通知',
            //   value: _notifySystem,
            //   onChanged: (v) => setState(() => _notifySystem = v),
            // ),
            // SettingsSwitchTile(
            //   icon: Icons.mail_outline,
            //   title: '邮件订阅',
            //   value: _emailSubscription,
            //   onChanged: (v) => setState(() => _emailSubscription = v),
            // ),
          ]),

          SettingsSectionTitle(title: '厨房偏好设置'),
          SettingsGroupCard(children: const [
            SettingsListTile(icon: Icons.notifications_active_outlined, title: '智能推荐偏好'),
            SettingsListTile(icon: Icons.restaurant_menu_outlined, title: '忌口设置'),
            SettingsListTile(icon: Icons.assignment_outlined, title: '饮食目标设置', trailingText: '健康饮食'),
            SettingsListTile(icon: Icons.warning_amber_outlined, title: '食材过敏提醒'),
            SettingsListTile(icon: Icons.layers_outlined, title: '食谱难度偏好', trailingText: '中等'),
            SettingsListTile(icon: Icons.access_time, title: '每日推荐时间', trailingText: '上午 7:00'),
          ]),

          SettingsSectionTitle(title: '关于我们'),
          SettingsGroupCard(children: const [
            SettingsListTile(icon: Icons.description_outlined, title: '用户协议'),
            SettingsListTile(icon: Icons.privacy_tip_outlined, title: '隐私政策'),
            SettingsListTile(icon: Icons.info_outline, title: '关于饭典'),
            // SettingsListTile(icon: Icons.cloud_upload_outlined, title: '版本更新', trailingText: 'V1.2.0'),
            // SettingsListTile(icon: Icons.rate_review_outlined, title: '意见反馈'),
            // SettingsListTile(icon: Icons.headset_mic_outlined, title: '联系客服'),
            SettingsListTile(icon: Icons.star_border_outlined, title: '给我们评分'),
          ]),

          const SizedBox(height: 24),
          TextButton.icon(
            onPressed: () async {
              await tokenManager.removeToken();
              if (!context.mounted) return;
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginPage()),
                (route) => false,
              );
            },
            icon: const Icon(Icons.exit_to_app, color: Colors.redAccent),
            label: const Text('退出登录', style: TextStyle(color: Colors.redAccent, fontSize: 16)),
          ),
          // TextButton.icon(
          //   onPressed: () {},
          //   icon: const Icon(Icons.no_accounts_outlined, color: Colors.redAccent),
          //   label: const Text('删除账号', style: TextStyle(color: Colors.redAccent, fontSize: 16)),
          // ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _socialIcons() {
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
