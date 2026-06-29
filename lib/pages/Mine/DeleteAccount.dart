import 'dart:async';
import 'package:flutter/material.dart';

/// 注销账号页面
class DeleteAccountView extends StatefulWidget {
  const DeleteAccountView({super.key});

  @override
  State<DeleteAccountView> createState() => _DeleteAccountViewState();
}

class _DeleteAccountViewState extends State<DeleteAccountView> {
  final TextEditingController _codeController = TextEditingController();

  bool _isReadAndAgreed = false; // 是否同意注销协议
  int _countdownTime = 0;        // 验证码倒计时
  Timer? _timer;

  /// 开始获取验证码倒计时
  void _startCountdown() {
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

  /// 确认注销操作
  void _confirmDelete() {
    if (!_isReadAndAgreed) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请先阅读并勾选注销须知')),
      );
      return;
    }
    if (_codeController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请输入验证码以验证身份')),
      );
      return;
    }

    // 弹出二次危险确认弹窗
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('极端危险操作提示', style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text('此操作将永久抹除您的账号。重新登录将作为一个全新的账号存在，您确定要继续吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('我再想想', style: TextStyle(color: Colors.black54)),
          ),
          TextButton(
            onPressed: () {
              // TODO: 调用注销接口，清空本地 Token 并返回登录页
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('账号注销申请已提交，审核将在7个工作日内完成')),
              );
            },
            child: const Text('确定注销', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 保持与原图一致的浅米色底色
      backgroundColor: const Color(0xfff9f6f3),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          '注销账号',
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
            // 警告横幅提示
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: const Color(0xfffdf2e9), // 淡暖橙/淡红背景提示危险
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xfff3a033).withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.warning_amber_rounded, color: Color(0xfff3a033), size: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      '注意：账号一旦注销，所有数据将无法恢复。',
                      style: TextStyle(color: const Color(0xfff3a033).withDarkness(0.2), fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
            _buildSectionTitle('注销前，请确认以下权益将受到影响：'),

            // 还原圆角白底卡片，展示注销影响
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Column(
                children: [
                  _buildNoticeItem(Icons.person_off_outlined, '个人身份信息被抹除', '您的头像、昵称、绑定的手机号及第三方账号将全部解绑清除。'),
                  _buildDivider(),
                  _buildNoticeItem(Icons.account_balance_wallet_outlined, '资产与权益清空', '您的代币、积分、会员权益、未消费的订单及卡券将全部作废。'),
                  _buildDivider(),
                  _buildNoticeItem(Icons.history_edu_outlined, '历史数据不可追溯', '发布过的动态、历史足迹、收藏和互动记录等信息将永久彻底消失。'),
                ],
              ),
            ),

            const SizedBox(height: 20),
            _buildSectionTitle('安全身份验证'),

            // 验证码卡片区
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  children: [
                    const Icon(Icons.shield_outlined, size: 22, color: Color(0xfff3a033)),
                    const SizedBox(width: 14),
                    Expanded(
                      child: TextField(
                        controller: _codeController,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(fontSize: 15),
                        decoration: const InputDecoration(
                          hintText: '输入已绑定手机 138****5678 的验证码',
                          hintStyle: TextStyle(color: Colors.black38, fontSize: 14),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: _startCountdown,
                      child: Text(
                        _countdownTime > 0 ? '${_countdownTime}s' : '获取验证码',
                        style: TextStyle(
                          color: _countdownTime > 0 ? Colors.black38 : const Color(0xfff3a033),
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // 同意单选框
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 24,
                  height: 24,
                  child: Checkbox(
                    value: _isReadAndAgreed,
                    activeColor: const Color(0xfff3a033),
                    shape: const CircleBorder(),
                    onChanged: (val) => setState(() => _isReadAndAgreed = val ?? false),
                  ),
                ),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text.rich(
                    TextSpan(
                      text: '我已悉知并自愿放弃以上的所有资产和权益，同意遵守',
                      style: TextStyle(color: Colors.black45, fontSize: 13, height: 1.4),
                      children: [
                        TextSpan(
                          text: '《账号注销须知协议》',
                          style: TextStyle(color: Color(0xfff3a033)),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // 注销确认按钮（采用危险警告红或者主题橙，这里按钮采用高级灰色与红色的状态变化组合）
            ElevatedButton(
              onPressed: _confirmDelete,
              style: ElevatedButton.styleFrom(
                backgroundColor: _isReadAndAgreed ? Colors.redAccent : Colors.black12,
                foregroundColor: _isReadAndAgreed ? Colors.white : Colors.black38,
                elevation: 0,
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                '申请注销账号',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 标题小组件
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0, bottom: 12.0),
      child: Text(
        title,
        style: const TextStyle(color: Colors.black87, fontSize: 14, fontWeight: FontWeight.bold),
      ),
    );
  }

  /// 须知行条目构建
  Widget _buildNoticeItem(IconData icon, String title, String desc) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 24, color: Colors.black54),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87)),
                const SizedBox(height: 4),
                Text(desc, style: const TextStyle(fontSize: 13, color: Colors.black45, height: 1.4)),
              ],
            ),
          )
        ],
      ),
    );
  }

  /// 分割线
  Widget _buildDivider() {
    return const Padding(
      padding: EdgeInsets.only(left: 54.0),
      child: Divider(height: 1, thickness: 0.5, color: Color(0xFFEEEEEE)),
    );
  }
}

/// 快捷扩展用于颜色微调
extension on Color {
  Color withDarkness(double factor) => Color.fromARGB(
    alpha,
    (red * (1 - factor)).toInt(),
    (green * (1 - factor)).toInt(),
    (blue * (1 - factor)).toInt(),
  );
}
