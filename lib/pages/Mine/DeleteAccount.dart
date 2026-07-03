import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fondia/api/user.dart';
import 'package:fondia/constants/LegalContent.dart';
import 'package:fondia/pages/Login/index.dart';
import 'package:fondia/stores/TokenManager.dart';

/// 注销账号页面
class DeleteAccountView extends StatefulWidget {
  const DeleteAccountView({super.key});

  @override
  State<DeleteAccountView> createState() => _DeleteAccountViewState();
}

class _DeleteAccountViewState extends State<DeleteAccountView> {
  final TextEditingController _codeController = TextEditingController();

  bool _isReadAndAgreed = false;
  int _countdownTime = 0;
  Timer? _timer;
  bool _loadingPreview = true;
  bool _sendingCode = false;
  bool _submitting = false;
  AccountDeletePreview? _preview;
  String? _loadError;

  @override
  void initState() {
    super.initState();
    _loadPreview();
  }

  Future<void> _loadPreview() async {
    setState(() {
      _loadingPreview = true;
      _loadError = null;
    });
    try {
      final preview = await UserApi.getDeletePreview();
      if (!mounted) return;
      setState(() {
        _preview = preview;
        _loadingPreview = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loadError = e.toString().replaceFirst('DioException [unknown]: ', '');
        _loadingPreview = false;
      });
    }
  }

  Future<void> _sendCode() async {
    if (_countdownTime > 0 || _sendingCode || _preview == null) return;
    setState(() => _sendingCode = true);
    try {
      await UserApi.sendDeleteCode();
      if (!mounted) return;
      _startCountdown();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('验证码已发送')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst('DioException [unknown]: ', ''))),
      );
    } finally {
      if (mounted) setState(() => _sendingCode = false);
    }
  }

  void _startCountdown() {
    _timer?.cancel();
    setState(() => _countdownTime = 60);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        if (_countdownTime <= 1) {
          _countdownTime = 0;
          timer.cancel();
        } else {
          _countdownTime--;
        }
      });
    });
  }

  void _showAgreement() {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('账号注销须知协议'),
        content: SingleChildScrollView(
          child: Text(
            LegalContent.deleteAccountAgreement,
            style: const TextStyle(fontSize: 14, height: 1.6),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('我知道了')),
        ],
      ),
    );
  }

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

    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('极端危险操作提示', style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text('此操作将永久抹除您的账号。重新登录将作为一个全新的账号存在，您确定要继续吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('我再想想', style: TextStyle(color: Colors.black54)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              _submitDelete();
            },
            child: const Text('确定注销', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Future<void> _submitDelete() async {
    if (_submitting) return;
    setState(() => _submitting = true);
    try {
      await UserApi.deleteAccount(_codeController.text.trim());
      await tokenManager.removeToken();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('账号已成功注销')),
      );
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
        (route) => false,
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst('DioException [unknown]: ', ''))),
      );
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _codeController.dispose();
    super.dispose();
  }

  String get _codeHint {
    if (_preview != null && _preview!.maskedContact.isNotEmpty) {
      return _preview!.codeHint;
    }
    return '输入已绑定手机或邮箱的验证码';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          style: TextStyle(color: Colors.black87, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: _loadingPreview
          ? const Center(child: CircularProgressIndicator(color: Color(0xfff3a033)))
          : _loadError != null
              ? _buildErrorState()
              : SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildWarningBanner(),
                      const SizedBox(height: 20),
                      _buildSectionTitle('注销前，请确认以下权益将受到影响：'),
                      _buildNoticeCard(),
                      const SizedBox(height: 20),
                      _buildSectionTitle('安全身份验证'),
                      _buildCodeInput(),
                      const SizedBox(height: 24),
                      _buildAgreementRow(),
                      const SizedBox(height: 32),
                      _buildSubmitButton(),
                    ],
                  ),
                ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_loadError ?? '加载失败', textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: _loadPreview, child: const Text('重试')),
          ],
        ),
      ),
    );
  }

  Widget _buildWarningBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color(0xfffdf2e9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xfff3a033).withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.warning_amber_rounded, color: Color(0xfff3a033), size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              '注意：账号一旦注销，所有数据将无法恢复。',
              style: TextStyle(
                color: const Color(0xfff3a033).withDarkness(0.2),
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoticeCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Column(
        children: [
          _buildNoticeItem(Icons.person_off_outlined, '个人身份信息被抹除',
              '您的头像、昵称、绑定的手机号及第三方账号将全部解绑清除。'),
          _buildDivider(),
          _buildNoticeItem(Icons.account_balance_wallet_outlined, '资产与权益清空',
              '您的代币、积分、会员权益、未消费的订单及卡券将全部作废。'),
          _buildDivider(),
          _buildNoticeItem(Icons.history_edu_outlined, '历史数据不可追溯',
              '发布过的动态、历史足迹、收藏和互动记录等信息将永久彻底消失。'),
        ],
      ),
    );
  }

  Widget _buildCodeInput() {
    return Container(
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
                maxLength: 6,
                buildCounter: (_, {required currentLength, required isFocused, maxLength}) => null,
                style: const TextStyle(fontSize: 15),
                decoration: InputDecoration(
                  hintText: _codeHint,
                  hintStyle: const TextStyle(color: Colors.black38, fontSize: 14),
                  border: InputBorder.none,
                ),
              ),
            ),
            GestureDetector(
              onTap: _sendingCode ? null : _sendCode,
              child: Text(
                _sendingCode
                    ? '发送中...'
                    : (_countdownTime > 0 ? '${_countdownTime}s' : '获取验证码'),
                style: TextStyle(
                  color: (_countdownTime > 0 || _sendingCode)
                      ? Colors.black38
                      : const Color(0xfff3a033),
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAgreementRow() {
    return Row(
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
        Expanded(
          child: Text.rich(
            TextSpan(
              text: '我已悉知并自愿放弃以上的所有资产和权益，同意遵守',
              style: const TextStyle(color: Colors.black45, fontSize: 13, height: 1.4),
              children: [
                WidgetSpan(
                  child: GestureDetector(
                    onTap: _showAgreement,
                    child: const Text(
                      '《账号注销须知协议》',
                      style: TextStyle(color: Color(0xfff3a033)),
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

  Widget _buildSubmitButton() {
    final enabled = _isReadAndAgreed && !_submitting;
    return ElevatedButton(
      onPressed: enabled ? _confirmDelete : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: enabled ? Colors.redAccent : Colors.black12,
        foregroundColor: enabled ? Colors.white : Colors.black38,
        elevation: 0,
        minimumSize: const Size.fromHeight(50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Text(
        _submitting ? '注销中...' : '申请注销账号',
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0, bottom: 12.0),
      child: Text(
        title,
        style: const TextStyle(color: Colors.black87, fontSize: 14, fontWeight: FontWeight.bold),
      ),
    );
  }

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
                Text(title,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87)),
                const SizedBox(height: 4),
                Text(desc,
                    style: const TextStyle(fontSize: 13, color: Colors.black45, height: 1.4)),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return const Padding(
      padding: EdgeInsets.only(left: 54.0),
      child: Divider(height: 1, thickness: 0.5, color: Color(0xFFEEEEEE)),
    );
  }
}

extension on Color {
  Color withDarkness(double factor) => Color.fromARGB(
        alpha,
        (red * (1 - factor)).toInt(),
        (green * (1 - factor)).toInt(),
        (blue * (1 - factor)).toInt(),
      );
}
