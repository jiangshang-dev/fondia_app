import 'package:flutter/material.dart';
import 'package:fondia/api/member.dart';
import 'package:fondia/api/user.dart';
import 'package:fondia/models/member_models.dart';
import 'package:fondia/models/user_profile.dart';
import 'package:fondia/pages/Mine/VipPay.dart';
import 'package:fondia/stores/TokenManager.dart';

class VipView extends StatefulWidget {
  const VipView({super.key});

  @override
  State<VipView> createState() => _VipViewState();
}

class _VipViewState extends State<VipView> {
  UserProfile? _profile;
  MemberStatus? _memberStatus;
  bool _loading = true;

  final List<Map<String, dynamic>> _privileges = [
    {'icon': Icons.card_giftcard, 'title': '每月礼券', 'desc': '无门槛优惠券'},
    {'icon': Icons.menu_book, 'title': '专属食谱', 'desc': '解锁高级料理'},
    {'icon': Icons.trending_up, 'title': '加速升级', 'desc': '1.5倍成长值'},
    {'icon': Icons.support_agent, 'title': '专属客服', 'desc': '24小时极速响应'},
    {'icon': Icons.cake, 'title': '生日好礼', 'desc': '神秘大礼包'},
    {'icon': Icons.ad_units, 'title': '免除广告', 'desc': '纯净清爽体验'},
  ];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    if (!tokenManager.isLoggedIn()) {
      setState(() => _loading = false);
      return;
    }
    setState(() => _loading = true);
    try {
      final results = await Future.wait([
        UserApi.getProfile(),
        MemberApi.getMemberStatus(),
      ]);
      if (!mounted) return;
      setState(() {
        _profile = results[0] as UserProfile;
        _memberStatus = results[1] as MemberStatus;
      });
    } catch (_) {
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  String get _expireText {
    final expire = _memberStatus?.subscription?.expireDate;
    if (expire != null) {
      return '${expire.year}-${expire.month.toString().padLeft(2, '0')}-${expire.day.toString().padLeft(2, '0')} 到期';
    }
    return _memberStatus?.isMember == true ? '会员生效中' : '尚未开通会员';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff7f8fa),
      appBar: AppBar(
        title: const Text('会员中心', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black87)),
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
          : RefreshIndicator(
              onRefresh: _load,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                child: Column(
                  children: [
                    _buildVipCard(),
                    _buildSectionTitle('核心特权'),
                    _buildPrivilegeGrid(),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildVipCard() {
    final isMember = _memberStatus?.isMember == true;
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xfffca63c), Color(0xfff16532)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xfff16532).withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: const Icon(Icons.star, color: Colors.white, size: 30),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          _profile?.displayName ?? '小厨尊享会员',
                          style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        if (isMember) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                            child: const Text('PRO', style: TextStyle(color: Color(0xfff16532), fontSize: 10, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(_expireText, style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 12)),
                  ],
                ),
              )
            ],
          ),
          const SizedBox(height: 28),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('当前成长值', style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 12)),
                  const SizedBox(height: 4),
                  Text(
                    '${_profile?.growthValue ?? 0} / 1000',
                    style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'monospace'),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const VipPayView()))
                      .then((_) => _load());
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xfff16532),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
                child: Text(isMember ? '立即续费' : '开通会员', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xff333333))),
    );
  }

  Widget _buildPrivilegeGrid() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _privileges.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 20,
          crossAxisSpacing: 10,
          childAspectRatio: 0.9,
        ),
        itemBuilder: (context, index) {
          final item = _privileges[index];
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: const Color(0xfff16532).withOpacity(0.08), shape: BoxShape.circle),
                child: Icon(item['icon'] as IconData, color: const Color(0xfff16532), size: 26),
              ),
              const SizedBox(height: 10),
              Text(item['title'] as String, style: const TextStyle(color: Color(0xff333333), fontSize: 13, fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              Text(item['desc'] as String, style: const TextStyle(color: Color(0xff999999), fontSize: 10), textAlign: TextAlign.center),
            ],
          );
        },
      ),
    );
  }
}
