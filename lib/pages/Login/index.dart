import 'package:flutter/material.dart';
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
              _buildTopBar(),

              // 2. 欢迎语与美食插图区域
              _buildHeaderSection(),

              const SizedBox(height: 20),

              // 3. 下半部分白色登录卡片
              Expanded(child: _buildLoginCard()),
            ],
          ),
        ),
      ),
    );
  }

  // 顶部“帮助中心”
  Widget _buildTopBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      alignment: Alignment.centerRight,
      height: 44,
      child: TextButton(
        onPressed: () {},
        child: const Text(
          '帮助中心',
          style: TextStyle(color: Colors.black54, fontSize: 14),
        ),
      ),
    );
  }

  // 欢迎语与插图
  Widget _buildHeaderSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '欢迎来到',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff2d2d2d),
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  '菜谱',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xffff7f32), // 标志性橙色
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  '让做饭更简单，爱生活，爱美食',
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

  // 白色主体登录卡片
  Widget _buildLoginCard() {
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
            // 快捷登录标题
            _buildSectionDivider('快捷登录'),
            const SizedBox(height: 24),

            // 登录按钮列表
            _buildThirdPartyButton(
              icon: Icons.g_mobiledata, // 建议换成真正的谷歌图标资产
              iconColor: Colors.blue,
              text: '使用 Google 账号登录',
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
              icon: Icons.wechat,
              iconColor: const Color(0xff07c160),
              text: '使用微信账号登录',
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
              text: '使用支付宝登录',
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
              text: '使用手机号登录',
              onTap: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const MainPage()),
                  (route) => false,
                );
              },
            ),

            const SizedBox(height: 40),
            // 其他方式登录标题
            _buildSectionDivider('其他方式登录', isSub: true),
            const SizedBox(height: 20),

            // 邮箱与密码登录小图标
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildSubLoginItem(Icons.mail_outline, '邮箱登录', () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const MainPage()),
                    (route) => false,
                  );
                }),
                const SizedBox(width: 60),
                _buildSubLoginItem(Icons.lock_open_outlined, '密码登录', () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const MainPage()),
                    (route) => false,
                  );
                }),
              ],
            ),

            const SizedBox(height: 40),
            // 底部服务协议
            _buildProtocolRow(),
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

  // 协议勾选行
  Widget _buildProtocolRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () => setState(() => _isAgreed = !_isAgreed),
          child: Container(
            // 右边距
            padding: const EdgeInsets.only(right: 8),
            // margin: const EdgeInsets.right(8),
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: _isAgreed ? const Color(0xffff7f32) : Colors.grey[300]!,
                width: 1.5,
              ),
              color: _isAgreed ? const Color(0xffff7f32) : Colors.transparent,
            ),
            child: _isAgreed
                ? const Icon(Icons.check, size: 10, color: Colors.white)
                : null,
          ),
        ),
        Flexible(
          child: RichText(
            text: TextSpan(
              style: const TextStyle(fontSize: 12, color: Colors.black45),
              children: [
                const TextSpan(text: '我已阅读并同意 '),
                WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: GestureDetector(
                    onTap: () {},
                    child: const Text(
                      '《用户协议》',
                      style: TextStyle(color: Color(0xffff7f32), fontSize: 12),
                    ),
                  ),
                ),
                const TextSpan(text: ' 和 '),
                WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: GestureDetector(
                    onTap: () {},
                    child: const Text(
                      '《隐私政策》',
                      style: TextStyle(color: Color(0xffff7f32), fontSize: 12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
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
