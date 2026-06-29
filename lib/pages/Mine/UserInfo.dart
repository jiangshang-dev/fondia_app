import 'package:flutter/material.dart';

class UserInfoView extends StatefulWidget {
  const UserInfoView({super.key});

  @override
  State<UserInfoView> createState() => _UserInfoViewState();
}

class _UserInfoViewState extends State<UserInfoView> {
  // 开关状态变量
  bool _notificationEnabled = true;
  bool _joinActivityEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfffcf9f7), // 柔和的浅色背景
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87, size: 20),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: const Text(
          '个人信息',
          style: TextStyle(color: Colors.black87, fontSize: 18, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_horiz, color: Colors.black87),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    _buildHeaderCard(),
                    const SizedBox(height: 20),
                    _buildSectionTitle('基础信息'),
                    _buildGroupContainer([
                      _buildListItem(Icons.person_outline, '昵称', trailingText: '小厨爱做饭'),
                      _buildListItem(Icons.calendar_month_outlined, '生日', trailingText: '1995-08-18'),
                      _buildListItem(Icons.location_on_outlined, '地址', trailingText: '广东省 广州市 天河区'),
                      _buildListItem(Icons.wc_outlined, '性别', trailingText: '女'),
                      _buildListItem(Icons.edit_note_outlined, '个性签名', trailingText: '爱生活，爱美食，爱分享每一道好菜~'),
                      _buildListItem(Icons.stars_outlined, '厨艺等级',
                        customTrailing: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xfffff0e6),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xffffa366)),
                          ),
                          child: const Text('Lv.4 厨艺达人', style: TextStyle(color: Color(0xffff6600), fontSize: 12)),
                        ),
                      ),
                      _buildListItem(Icons.shield_outlined, '账号安全', trailingText: '已保护'),
                    ]),
                    const SizedBox(height: 20),
                    _buildSectionTitle('偏好设置'),
                    _buildGroupContainer([
                      _buildListItem(Icons.favorite_border, '口味偏好', trailingText: '偏好清淡、微辣、甜口'),
                      _buildListItem(Icons.description_outlined, '饮食偏好', trailingText: '普通饮食'),
                      _buildListItem(
                        Icons.notifications_none,
                        '消息通知',
                        showArrow: false,
                        customTrailing: Switch(
                          value: _notificationEnabled,
                          activeColor: Colors.white,
                          activeTrackColor: const Color(0xffff7f32),
                          inactiveTrackColor: Colors.grey[300],
                          onChanged: (val) => setState(() => _notificationEnabled = val),
                        ),
                      ),
                      _buildListItem(
                        Icons.star_border,
                        '参与活动',
                        showArrow: false,
                        trailingText: '接收活动与福利信息',
                        customTrailing: Switch(
                          value: _joinActivityEnabled,
                          activeColor: Colors.white,
                          activeTrackColor: const Color(0xffff7f32),
                          inactiveTrackColor: Colors.grey[300],
                          onChanged: (val) => setState(() => _joinActivityEnabled = val),
                        ),
                      ),
                    ]),
                    const SizedBox(height: 20),
                    _buildSectionTitle('其他'),
                    _buildGroupContainer([
                      _buildListItem(Icons.help_outline, '帮助与反馈'),
                      _buildListItem(Icons.info_outline, '关于我们'),
                    ]),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
            _buildSaveButton(),
          ],
        ),
      ),
    );
  }

  // 1. 顶部头像和名字卡片
  Widget _buildHeaderCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: Colors.grey[200],
                // 建议替换成你的网络图 NetworkImage 或资产图 AssetImage
                backgroundImage: const NetworkImage('https://placeholder.co/150'),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Color(0xffff7f32),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.camera_alt, color: Colors.white, size: 14),
                ),
              )
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '小厨爱做饭',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
                const SizedBox(height: 6),
                Text(
                  '爱生活，爱美食，爱分享每一道好菜~',
                  style: TextStyle(fontSize: 13, color: Colors.grey[500]),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios, color: Colors.black26, size: 16),
        ],
      ),
    );
  }

  // 2. 分组标题
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87),
      ),
    );
  }

  // 3. 白底圆角包裹容器
  Widget _buildGroupContainer(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: children.length,
        separatorBuilder: (_, __) => const Divider(height: 1, indent: 50, color: Color(0xfff5f5f5)),
        itemBuilder: (_, index) => children[index],
      ),
    );
  }

  // 4. 通用列表行组件
  Widget _buildListItem(
      IconData icon,
      String title, {
        String? trailingText,
        Widget? customTrailing,
        bool showArrow = true,
      }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      leading: Icon(icon, color: const Color(0xffff7f32), size: 22),
      title: Text(title, style: const TextStyle(fontSize: 15, color: Colors.black87)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trailingText != null)
            Container(
              constraints: const BoxConstraints(maxWidth: 160),
              child: Text(
                trailingText,
                style: TextStyle(fontSize: 14, color: Colors.grey[400]),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          if (customTrailing != null) ...[
            const SizedBox(width: 6),
            customTrailing,
          ],
          if (showArrow) ...[
            const SizedBox(width: 6),
            const Icon(Icons.arrow_forward_ios, color: Colors.black26, size: 14),
          ]
        ],
      ),
      onTap: () {},
    );
  }

  // 5. 底部固定保存按钮
  Widget _buildSaveButton() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: Colors.white,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          // 保存修改的点击事件
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xffff7f32),
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(48),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          elevation: 0,
        ),
        child: const Text('保存修改', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ),
    );
  }
}