import 'dart:async';
import 'package:flutter/material.dart';

/// 手机号绑定页面
class PhoneView extends StatefulWidget {
  const PhoneView({super.key});

  @override
  State<PhoneView> createState() => _PhoneViewState();
}

class _PhoneViewState extends State<PhoneView> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();

  bool _isAgreed = false; // 是否同意协议

  // 倒计时相关变量
  Timer? _timer;
  int _countdownTime = 0;

  /// 开始倒计时
  void _startCountdown() {
    if (_phoneController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请输入手机号')),
      );
      return;
    }
    if (_countdownTime == 0) {
      setState(() {
        _countdownTime = 60;
      });
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          if (_countdownTime < 1) {
            _timer?.cancel();
          } else {
            _countdownTime--;
          }
        });
      });
    }
  }

  /// 提交绑定
  void _handleSubmit() {
    if (!_isAgreed) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请先勾选并阅读用户协议与隐私政策')),
      );
      return;
    }
    // TODO: 在这里处理具体的绑定接口请求
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('绑定成功')),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _phoneController.dispose();
    _codeController.dispose();
    super.dispose();
  }

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
          '手机号绑定',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // 分组标题
                  const Padding(
                    padding: EdgeInsets.only(left: 4.0, bottom: 12.0),
                    child: Text(
                      '绑定安全手机',
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  // 输入框卡片区（还原圆角白底卡片）
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Column(
                      children: [
                        // 手机号输入行
                        _buildInputField(
                          icon: Icons.phone_android_rounded,
                          controller: _phoneController,
                          hintText: '请输入手机号码',
                          keyboardType: TextInputType.phone,
                          suffix: const Text(
                            '+86',
                            style: TextStyle(color: Colors.black45, fontSize: 15),
                          ),
                        ),
                        _buildDivider(),

                        // 验证码输入行
                        _buildInputField(
                          icon: Icons.lock_outline_rounded,
                          controller: _codeController,
                          hintText: '请输入验证码',
                          keyboardType: TextInputType.number,
                          suffix: GestureDetector(
                            onTap: _startCountdown,
                            child: Text(
                              _countdownTime > 0 ? '${_countdownTime}s后重发' : '获取验证码',
                              style: TextStyle(
                                color: _countdownTime > 0
                                    ? Colors.black38
                                    : const Color(0xfff3a033), // 沿用原本的标识橙色
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // 协议勾选区
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 24,
                        height: 24,
                        child: Checkbox(
                          value: _isAgreed,
                          activeColor: const Color(0xfff3a033),
                          shape: const CircleBorder(), // 圆形勾选框更显精致
                          onChanged: (value) {
                            setState(() {
                              _isAgreed = value ?? false;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text.rich(
                          TextSpan(
                            text: '我已阅读并同意',
                            style: TextStyle(color: Colors.black45, fontSize: 13, height: 1.3),
                            children: [
                              TextSpan(
                                text: '《用户服务协议》',
                                style: TextStyle(color: Color(0xfff3a033)),
                              ),
                              TextSpan(text: '与'),
                              TextSpan(
                                text: '《隐私政策》',
                                style: TextStyle(color: Color(0xfff3a033)),
                              ),
                              TextSpan(text: '，授权应用绑定该手机号用于账号安全验证。'),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // 确定绑定按钮
                  ElevatedButton(
                    onPressed: _handleSubmit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xfff3a033), // 使用主题橙色
                      foregroundColor: Colors.white,
                      elevation: 0,
                      minimumSize: const Size.fromHeight(50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      '确定绑定',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 通用输入框行构建
  Widget _buildInputField({
    required IconData icon,
    required TextEditingController controller,
    required String hintText,
    required TextInputType keyboardType,
    required Widget suffix,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 22, color: const Color(0xfff3a033)), // 统一左侧图标色调
          const SizedBox(width: 14),
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: keyboardType,
              style: const TextStyle(fontSize: 15, color: Colors.black87),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: const TextStyle(color: Colors.black38, fontSize: 15),
                border: InputBorder.none,
              ),
            ),
          ),
          suffix,
        ],
      ),
    );
  }

  /// 细分割线
  Widget _buildDivider() {
    return const Padding(
      padding: EdgeInsets.only(left: 52.0),
      child: Divider(
        height: 1,
        thickness: 0.5,
        color: Color(0xFFEEEEEE),
      ),
    );
  }
}