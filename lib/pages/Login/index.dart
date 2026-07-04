import 'package:flutter/material.dart';
import 'package:fondia/components/common/ProtocolAgreementRow.dart';
import 'package:fondia/l10n/app_localizations.dart';
import 'package:fondia/pages/Login/EmailLogin.dart';
import 'package:fondia/pages/Login/PasswordLogin.dart';
import 'package:fondia/pages/Main/index.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // 是否同意协议
  bool _isAgreed = false;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      // 使用带微弱渐变底色的背景
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xfffff5ee), // 顶部浅浅的暖橙色
              Color(0xfffcf9f7), // 中下部柔和底色
            ],
            stops: [0.0, 0.4],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              // 1. 顶部工具栏（帮助中心）
              _buildTopBar(l10n),

              // 2. 欢迎语与美食插图区域
              _buildHeaderSection(l10n),

              const SizedBox(height: 20),

              // 3. 下半部分白色登录卡片
              Expanded(child: _buildLoginCard(l10n)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      alignment: Alignment.centerRight,
      height: 44,
      child: TextButton(
        onPressed: () {},
        child: Text(
          l10n.helpCenter,
          style: const TextStyle(color: Colors.black54, fontSize: 14),
        ),
      ),
    );
  }

  Widget _buildHeaderSection(AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.welcomeTo,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff2d2d2d),
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.recipes,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xffff7f32),
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  l10n.loginSlogan,
                  style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                ),
                // 模拟文字下方的波浪线
                const SizedBox(height: 4),
                CustomPaint(
                  size: const Size(60, 8),
                  painter: _WaveLinePainter(),
                ),
              ],
            ),
          ),
          // 右侧美食大图占位
          Container(
            width: 130,
            height: 130,
            decoration: const BoxDecoration(
              // 实际开发请替换为 Image.asset('assets/images/salad.png')
              image: DecorationImage(
                image: NetworkImage('https://placeholder.co/150'),
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginCard(AppLocalizations l10n) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const SizedBox(height: 12),
            _buildSectionDivider(l10n.quickLogin),
            const SizedBox(height: 24),

            _buildThirdPartyButton(
              icon: Icons.g_mobiledata,
              iconColor: Colors.green,
              text: l10n.loginWithGoogle,
              onTap: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const MainPage()),
                  (route) => false,
                );
              },
            ),
            const SizedBox(height: 16),
            _buildThirdPartyButton(
              icon: Icons.apple,
              // iconColor: const Color(0xff07c160),
              iconColor: Colors.black,
              text: l10n.loginWithApple,
              onTap: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const MainPage()),
                  (route) => false,
                );
              },
            ),
            const SizedBox(height: 16),
            _buildThirdPartyButton(
              icon: Icons.payment, // 支付宝可以使用自定义资产图，这里用类似图标代替
              iconColor: const Color(0xff1677ff),
              text: l10n.loginWithAlipay,
              onTap: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const MainPage()),
                  (route) => false,
                );
              },
            ),
            const SizedBox(height: 16),
            _buildThirdPartyButton(
              icon: Icons.phone_android,
              iconColor: const Color(0xffff7f32),
              text: l10n.loginWithPhone,
              onTap: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const MainPage()),
                  (route) => false,
                );
              },
            ),

            const SizedBox(height: 40),
            _buildSectionDivider(l10n.otherLogin, isSub: true),
            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildSubLoginItem(Icons.mail_outline, l10n.emailLogin, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const EmailLoginView()),
                  );
                }),
                const SizedBox(width: 60),
                _buildSubLoginItem(Icons.lock_open_outlined, l10n.passwordLogin, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const PasswordLoginView()),
                  );
                }),
              ],
            ),

            const SizedBox(height: 40),
            // 底部服务协议
            ProtocolAgreementRow(
              value: _isAgreed,
              onChanged: (v) => setState(() => _isAgreed = v),
              style: ProtocolCheckboxStyle.circle,
              center: true,
            ),
          ],
        ),
      ),
    );
  }

  // 带有左右装饰线的标题
  Widget _buildSectionDivider(String text, {bool isSub = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 24,
          height: 1,
          color: isSub ? Colors.grey[200] : const Color(0xffffa366),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            text,
            style: TextStyle(
              fontSize: isSub ? 12 : 15,
              fontWeight: isSub ? FontWeight.normal : FontWeight.w600,
              color: isSub ? Colors.grey[400] : const Color(0xff2d2d2d),
            ),
          ),
        ),
        Container(
          width: 24,
          height: 1,
          color: isSub ? Colors.grey[200] : const Color(0xffffa366),
        ),
      ],
    );
  }

  // 大的快捷登录按钮封装
  Widget _buildThirdPartyButton({
    required IconData icon,
    required Color iconColor,
    required String text,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(28),
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          color: const Color(0xfffff9f5), // 淡淡的按钮底色
          borderRadius: BorderRadius.circular(28),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            const SizedBox(width: 16),
            Text(
              text,
              style: const TextStyle(
                fontSize: 15,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 小型底部轻量登录选项
  Widget _buildSubLoginItem(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[200]!),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.black54, size: 20),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}

// 辅助类：绘制欢迎词下方的手绘感觉小波浪/曲线线段
class _WaveLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xffffa366)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final path = Path();
    path.moveTo(0, size.height / 2);
    path.quadraticBezierTo(
      size.width * 0.25,
      size.height,
      size.width * 0.5,
      size.height / 2,
    );
    path.quadraticBezierTo(size.width * 0.75, 0, size.width, size.height / 2);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
