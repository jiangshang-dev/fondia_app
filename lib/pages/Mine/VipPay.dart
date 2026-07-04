import 'package:flutter/material.dart';
import 'package:fondia/api/member.dart';
import 'package:fondia/api/payment.dart';
import 'package:fondia/models/member_models.dart';
import 'package:fondia/models/user_profile.dart';
import 'package:fondia/api/user.dart';

class VipPayView extends StatefulWidget {
  const VipPayView({super.key});

  @override
  State<VipPayView> createState() => _VipPayViewState();
}

class _PayChannelOption {
  _PayChannelOption({
    required this.code,
    required this.name,
    required this.subtitle,
    required this.defaultSelected,
  });

  final String code;
  final String name;
  final String subtitle;
  final bool defaultSelected;

  factory _PayChannelOption.fromJson(Map<String, dynamic> json) {
    return _PayChannelOption(
      code: json['code']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      subtitle: json['subtitle']?.toString() ?? '',
      defaultSelected: json['defaultSelected'] == true,
    );
  }
}

class _VipPayViewState extends State<VipPayView> {
  int _selectedPackageIndex = 0;
  String _selectedPayMethod = 'ALIPAY';
  List<MemberPlan> _packages = [];
  List<_PayChannelOption> _payChannels = [];
  MemberStatus? _memberStatus;
  UserProfile? _profile;
  bool _loading = true;
  bool _paying = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final results = await Future.wait([
        MemberApi.getPlans(),
        MemberApi.getMemberStatus(),
        UserApi.getProfile(),
        PaymentApi.getChannels(),
      ]);
      if (!mounted) return;
      final channelData = results[3] as Map<String, dynamic>;
      final channels = (channelData['channels'] as List<dynamic>? ?? [])
          .map((e) => _PayChannelOption.fromJson(Map<String, dynamic>.from(e)))
          .where((e) => e.code.isNotEmpty)
          .toList();
      setState(() {
        _packages = results[0] as List<MemberPlan>;
        _memberStatus = results[1] as MemberStatus;
        _profile = results[2] as UserProfile;
        _payChannels = channels;
        if (_packages.isNotEmpty) _selectedPackageIndex = 0;
        if (channels.isNotEmpty) {
          _selectedPayMethod = channels.firstWhere((c) => c.defaultSelected, orElse: () => channels.first).code;
        }
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString().replaceFirst('DioException: ', ''))),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _pay() async {
    if (_packages.isEmpty || _paying) return;
    setState(() => _paying = true);
    try {
      final plan = _packages[_selectedPackageIndex];
      final order = await MemberApi.createMemberOrder(
        planId: plan.id,
        payChannel: _selectedPayMethod,
      );
      final prepay = await PaymentApi.prepay(
        orderNo: order.orderNo,
        payChannel: _selectedPayMethod,
      );

      final mockPay = prepay['mockPay'] == true;
      if (mockPay) {
        await PaymentApi.verify(
          orderNo: order.orderNo,
          payChannel: _selectedPayMethod,
        );
      } else if (_selectedPayMethod == 'ALIPAY') {
        // TODO: 调起支付宝 SDK（tobias），成功后由异步回调或客户端轮询确认
        await _pollUntilPaid(order.orderNo);
      } else {
        // TODO: in_app_purchase 调起 Apple / Google 内购后提交 receipt
        throw Exception('内购支付尚未接入，请开启 mock-enabled 或使用支付宝沙箱');
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('支付成功！订单 ${order.orderNo}')),
      );
      Navigator.pop(context, true);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString().replaceFirst('DioException: ', ''))),
        );
      }
    } finally {
      if (mounted) setState(() => _paying = false);
    }
  }

  Future<void> _pollUntilPaid(String orderNo) async {
    for (var i = 0; i < 30; i++) {
      await Future.delayed(const Duration(seconds: 2));
      final status = await PaymentApi.getOrderStatus(orderNo);
      if (status['payStatus'] == 1) return;
    }
    throw Exception('支付结果确认超时，请稍后在会员中心查看');
  }

  String get _expireText {
    final expire = _memberStatus?.subscription?.expireDate;
    if (expire != null) {
      return '${expire.year}-${expire.month.toString().padLeft(2, '0')}-${expire.day.toString().padLeft(2, '0')} 到期';
    }
    return '尚未开通';
  }

  IconData _iconForChannel(String code) {
    switch (code) {
      case 'APPLE_IAP':
        return Icons.apple;
      case 'GOOGLE_PLAY':
        return Icons.shop_two;
      default:
        return Icons.account_balance_wallet;
    }
  }

  Color _colorForChannel(String code) {
    switch (code) {
      case 'APPLE_IAP':
        return Colors.black;
      case 'GOOGLE_PLAY':
        return Colors.blue;
      default:
        return const Color(0xff108ee9);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff7f8fa),
      appBar: AppBar(
        title: const Text('会员续费', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black87)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 18, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                Positioned.fill(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildMiniVipCard(),
                        _buildSectionTitle('选择续费套餐'),
                        _buildPackageGrid(),
                        _buildSectionTitle('选择支付方式'),
                        _buildPayMethods(),
                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ),
                _buildBottomPayBar(),
              ],
            ),
    );
  }

  Widget _buildMiniVipCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xfffca63c), Color(0xfff16532)], begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), shape: BoxShape.circle),
            child: const Icon(Icons.star, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${_profile?.displayName ?? '小厨'}尊享会员',
                  style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(_expireText, style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 12)),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xff333333))),
    );
  }

  Widget _buildPackageGrid() {
    if (_packages.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Text('暂无可用套餐', style: TextStyle(color: Colors.grey)),
      );
    }
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _packages.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.2,
      ),
      itemBuilder: (context, index) {
        final plan = _packages[index];
        final isSelected = _selectedPackageIndex == index;
        return GestureDetector(
          onTap: () => setState(() => _selectedPackageIndex = index),
          child: Container(
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xfffff7f4) : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: isSelected ? const Color(0xfff16532) : Colors.transparent, width: 1.5),
            ),
            padding: const EdgeInsets.all(14),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(plan.name, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: isSelected ? const Color(0xfff16532) : const Color(0xff333333))),
                const SizedBox(height: 6),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('￥', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: isSelected ? const Color(0xfff16532) : const Color(0xff333333))),
                    Text(plan.price.toStringAsFixed(0), style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: isSelected ? const Color(0xfff16532) : const Color(0xff333333))),
                    if (plan.originalPrice != null) ...[
                      const SizedBox(width: 4),
                      Text('￥${plan.originalPrice!.toStringAsFixed(0)}', style: const TextStyle(fontSize: 11, color: Color(0xffbbbbbb), decoration: TextDecoration.lineThrough)),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Text('${plan.durationDays}天有效', style: const TextStyle(fontSize: 10, color: Color(0xff999999))),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPayMethods() {
    if (_payChannels.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Text('暂无可用支付方式', style: TextStyle(color: Colors.grey)),
      );
    }
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: _payChannels.asMap().entries.map((entry) {
          final channel = entry.value;
          final isLast = entry.key == _payChannels.length - 1;
          return Column(
            children: [
              _buildPayTile(channel: channel),
              if (!isLast) const Divider(height: 1, indent: 54),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPayTile({required _PayChannelOption channel}) {
    final isSelected = _selectedPayMethod == channel.code;
    return ListTile(
      onTap: () => setState(() => _selectedPayMethod = channel.code),
      leading: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(color: _colorForChannel(channel.code).withValues(alpha: 0.1), shape: BoxShape.circle),
        child: Icon(_iconForChannel(channel.code), color: _colorForChannel(channel.code), size: 24),
      ),
      title: Text(channel.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
      subtitle: Text(channel.subtitle, style: const TextStyle(fontSize: 11, color: Color(0xff999999))),
      trailing: Icon(isSelected ? Icons.check_circle : Icons.radio_button_off, color: isSelected ? const Color(0xfff16532) : const Color(0xffcccccc), size: 22),
    );
  }

  Widget _buildBottomPayBar() {
    final price = _packages.isEmpty ? 0 : _packages[_selectedPackageIndex].price;
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.only(left: 20, right: 20, top: 12, bottom: MediaQuery.of(context).padding.bottom + 12),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 10, offset: const Offset(0, -4))],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                const Text('总计:', style: TextStyle(fontSize: 13, color: Color(0xff666666))),
                const SizedBox(width: 4),
                const Text('￥', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xfff16532))),
                Text(price.toStringAsFixed(0), style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xfff16532))),
              ],
            ),
            GestureDetector(
              onTap: _packages.isEmpty || _paying || _payChannels.isEmpty ? null : _pay,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: _packages.isEmpty || _payChannels.isEmpty ? [Colors.grey, Colors.grey] : const [Color(0xfffca63c), Color(0xfff16532)]),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: _paying
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : const Text('立即安全支付', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
