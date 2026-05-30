import 'package:flutter/material.dart';
import 'package:fondia/components/Mine/VipPay.dart';

class VipView extends StatefulWidget {
  const VipView({super.key});

  @override
  State<VipView> createState() => _VipViewState();
}

class _VipViewState extends State<VipView> {
  // 模拟会员权益数据
  final List<Map<String, dynamic>> _privileges = [
    {'icon': Icons.card_giftcard, 'title': '每月礼券', 'desc': '无门槛优惠券'},
    {'icon': Icons.menu_book, 'title': '专属食谱', 'desc': '解锁高级料理'},
    {'icon': Icons.trending_up, 'title': '加速升级', 'desc': '1.5倍成长值'},
    {'icon': Icons.support_agent, 'title': '专属客服', 'desc': '24小时极速响应'},
    {'icon': Icons.eighteen_mp, 'title': '生日好礼', 'desc': '神秘大礼包'},
    {'icon': Icons.ad_units, 'title': '免除广告', 'desc': '纯净清爽体验'},
  ];

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
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            _buildVipCard(),
            _buildSectionTitle('核心特权'),
            _buildPrivilegeGrid(),
            _buildSectionTitle('专属活动'),
            _buildBanner(),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  /// 1. 顶部会员主卡片 (沿用原 UI 的暖橙色渐变风格)
  Widget _buildVipCard() {
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
                        const Text(
                          '小厨尊享会员',
                          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text(
                            'PRO',
                            style: TextStyle(color: Color(0xfff16532), fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '2027-05-29 到期，已陪伴小厨 365 天',
                      style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 12),
                    ),
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
                  const Text('2450 / 5000', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'monospace')),
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  // 跳转到VipPay页面
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const VipPayView()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xfff16532),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
                child: const Text('立即续费',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  /// 2. 统一的区块标题
  Widget _buildSectionTitle(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xff333333)),
      ),
    );
  }

  /// 3. 会员核心特权网格 (对应原 UI 下方的白底圆角卡片布局)
  Widget _buildPrivilegeGrid() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
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
                decoration: BoxDecoration(
                  color: const Color(0xfff16532).withOpacity(0.08),
                  shape: BoxShape.circle,
                ),
                child: Icon(item['icon'] as IconData, color: const Color(0xfff16532), size: 26),
              ),
              const SizedBox(height: 10),
              Text(
                item['title'] as String,
                style: const TextStyle(color: Color(0xff333333), fontSize: 13, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 4),
              Text(
                item['desc'] as String,
                style: const TextStyle(color: Color(0xff999999), fontSize: 10),
                textAlign: TextAlign.center,
              ),
            ],
          );
        },
      ),
    );
  }

  /// 4. 底部活动 Banner
  Widget _buildBanner() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: const DecorationImage(
          image: NetworkImage('https://images.unsplash.com/photo-1556910103-1c02745aae4d?w=500&auto=format&fit=crop&q=60'), // 示例厨房背景图
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [Colors.black.withOpacity(0.6), Colors.transparent],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        padding: const EdgeInsets.all(16),
        alignment: Alignment.centerLeft,
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('尊享特厨线下沙龙', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 4),
            Text('高级大厨面对面授课，限额预约中 >', style: TextStyle(color: Colors.white70, fontSize: 11)),
          ],
        ),
      ),
    );
  }
}