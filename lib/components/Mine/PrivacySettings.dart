import 'package:flutter/material.dart';

/// 隐私设置页面
class PrivacySettings extends StatefulWidget {
  const PrivacySettings({super.key});

  @override
  State<PrivacySettings> createState() => _PrivacySettingsState();
}

class _PrivacySettingsState extends State<PrivacySettings> {
  // 模拟隐私开关状态
  bool _personalAd = true;
  bool _showLocation = false;
  bool _searchByPhone = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 还原图片中的浅米色/灰白底色
      backgroundColor: const Color(0xfff9f6f3),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          '隐私设置',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 分组1：添加与搜索
            _buildGroupTitle('社交与发现'),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Column(
                children: [
                  _buildSwitchItem(
                    title: '通过手机号找到我',
                    subtitle: '关闭后，其他人将无法通过手机号搜索到你',
                    value: _searchByPhone,
                    onChanged: (val) => setState(() => _searchByPhone = val),
                  ),
                  _buildDivider(),
                  _buildClickItem(
                    title: '黑名单管理',
                    onTap: () {
                      // 跳转到黑名单列表
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 分组2：权限与个性化（完美复刻原图底部的通用设置和开关样式）
            _buildGroupTitle('个性化与权限'),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Column(
                children: [
                  _buildSwitchItem(
                    title: '个性化广告推荐',
                    subtitle: '关闭后，看到的广告数量不会减少，但相关度会降低',
                    value: _personalAd,
                    onChanged: (val) => setState(() => _personalAd = val),
                  ),
                  _buildDivider(),
                  _buildSwitchItem(
                    title: '允许应用获取位置信息',
                    subtitle: '用于为您提供本地化生活及动态推荐',
                    value: _showLocation,
                    onChanged: (val) => setState(() => _showLocation = val),
                  ),
                  _buildDivider(),
                  _buildClickItem(
                    title: '系统权限设置',
                    trailingText: '去管理',
                    onTap: () {
                      // 跳转系统权限指南
                    },
                  ),
                ],
              ),
            ),

            // 底部补充文案
            const Padding(
              padding: EdgeInsets.only(top: 24.0, left: 8.0, right: 8.0),
              child: Text(
                '如需查阅完整的个人信息收集与保护规则，请前往主页查看《隐私政策》详情。',
                style: TextStyle(
                  color: Colors.black38,
                  fontSize: 13,
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 构建分组标题
  Widget _buildGroupTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0, bottom: 12.0),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.black87,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  /// 构建带 Switch 开关的行（复刻原图右下角深色模式的开关质感）
  Widget _buildSwitchItem({
    required String title,
    String? subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 16, color: Colors.black87, fontWeight: FontWeight.w500),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 12, color: Colors.black38),
                  ),
                ]
              ],
            ),
          ),
          const SizedBox(width: 8),
          // 仿制原图样式的精细 Switch 开关
          Transform.scale(
            scale: 0.85, // 缩小一点显得更精致
            child: Switch(
              value: value,
              onChanged: onChanged,
              activeColor: Colors.white,
              activeTrackColor: const Color(0xfff3a033), // 开启时使用主题橙色
              inactiveThumbColor: Colors.white,
              inactiveTrackColor: const Color(0xffdcd8cf), // 关闭时采用图示深色模式开关的灰色调
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
        ],
      ),
    );
  }

  /// 构建普通的点击跳转行
  Widget _buildClickItem({
    required String title,
    String? trailingText,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: Row(
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 16, color: Colors.black87, fontWeight: FontWeight.w500),
            ),
            const Spacer(),
            if (trailingText != null) ...[
              Text(
                trailingText,
                style: const TextStyle(fontSize: 14, color: Colors.black38),
              ),
              const SizedBox(width: 4),
            ],
            const Icon(
              Icons.arrow_forward_ios,
              size: 14,
              color: Colors.black26,
            ),
          ],
        ),
      ),
    );
  }

  /// 分割线
  Widget _buildDivider() {
    return const Padding(
      padding: EdgeInsets.only(left: 16.0),
      child: Divider(
        height: 1,
        thickness: 0.5,
        color: Color(0xFFEEEEEE),
      ),
    );
  }
}