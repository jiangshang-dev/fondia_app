import 'package:flutter/material.dart';

/// 账号绑定页面
class Account extends StatefulWidget {
  const Account({super.key});

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  // 模拟各个平台的绑定状态，实际开发中请对接您的状态管理 (Provider/Bloc 等)
  bool isWeChatBound = true;
  bool isAppleBound = true;
  bool isGoogleBound = false;

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
          '账号绑定',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline, color: Colors.black87),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 分组标题
            const Padding(
              padding: EdgeInsets.only(left: 4.0, bottom: 12.0),
              child: Text(
                '第三方账号绑定',
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // 还原图中的圆角白底卡片
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Column(
                children: [
                  // 微信绑定
                  _buildBindingItem(
                    icon: Icons.wechat, // 也可以替换为您的自定义资产图片 AssetImage
                    iconColor: const Color(0xFF07C160),
                    title: '微信',
                    isBound: isWeChatBound,
                    boundText: '已绑定：微信用户',
                    onTap: () {
                      setState(() {
                        isWeChatBound = !isWeChatBound; // 模拟切换状态
                      });
                    },
                  ),
                  _buildDivider(),

                  // Apple 绑定
                  _buildBindingItem(
                    icon: Icons.apple,
                    iconColor: Colors.black,
                    title: 'Apple',
                    isBound: isAppleBound,
                    boundText: '已绑定 Apple ID',
                    onTap: () {
                      setState(() {
                        isAppleBound = !isAppleBound;
                      });
                    },
                  ),
                  _buildDivider(),

                  // Google 绑定
                  _buildBindingItem(
                    icon: Icons.g_mobiledata, // 实际推荐使用自定义 Google SVG/PNG 图标
                    iconColor: const Color(0xFF4285F4),
                    title: 'Google',
                    isBound: isGoogleBound,
                    boundText: '已绑定 Google 账号',
                    onTap: () {
                      setState(() {
                        isGoogleBound = !isGoogleBound;
                      });
                    },
                  ),
                ],
              ),
            ),

            // 底部安全提示
            const Padding(
              padding: EdgeInsets.only(top: 24.0, left: 8.0, right: 8.0),
              child: Text(
                '温馨提示：绑定第三方账号后，您可以使用对应的第三方账号直接登录该应用。为了您的账号安全，请勿将账号授权给他人。',
                style: TextStyle(
                  color: Colors.black45,
                  fontSize: 13,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 构建单行绑定条目
  Widget _buildBindingItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required bool isBound,
    required String boundText,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.0), // 防止点击水波纹溢出圆角
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: Row(
          children: [
            // 左侧平台图标
            Icon(icon, size: 28, color: iconColor),
            const SizedBox(width: 14),

            // 中间名称
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            const Spacer(),

            // 右侧状态：已绑定展示灰色提示字，未绑定展示“去绑定”
            Text(
              isBound ? boundText : '未绑定',
              style: TextStyle(
                fontSize: 14,
                color: isBound ? Colors.black38 : const Color(0xfff3a033), // 未绑定采用图示中类似的暖橙色强调
              ),
            ),
            const SizedBox(width: 4),

            // 右侧箭头
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

  /// 还原图中的极细分割线
  Widget _buildDivider() {
    return const Padding(
      padding: EdgeInsets.only(left: 56.0), // 针对图标对齐的左侧缩进
      child: Divider(
        height: 1,
        thickness: 0.5,
        color: Color(0xFFEEEEEE),
      ),
    );
  }
}