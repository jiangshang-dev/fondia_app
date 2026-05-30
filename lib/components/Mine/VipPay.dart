import 'package:flutter/material.dart';

class VipPayView extends StatefulWidget {
  const VipPayView({super.key});

  @override
  State<VipPayView> createState() => _VipPayViewState();
}

class _VipPayViewState extends State<VipPayView> {
  // 选中的套餐索引
  int _selectedPackageIndex = 0;

  // 选中的支付方式：'google' | 'apple' | 'alipay'
  String _selectedPayMethod = 'alipay';

  // 模拟会员套餐数据
  final List<Map<String, dynamic>> _packages = [
    {'title': '连续包月', 'price': '15', 'originalPrice': '25', 'desc': '次月15元自动续费', 'tag': '首月特惠'},
    {'title': '连续包季', 'price': '45', 'originalPrice': '68', 'desc': '次季45元自动续费', 'tag': '最省心'},
    {'title': '年度会员', 'price': '158', 'originalPrice': '218', 'desc': '相当于13.1元/月', 'tag': '低至5折'},
    {'title': '单月体验', 'price': '25', 'originalPrice': '25', 'desc': '无自动续费绑定', 'tag': ''},
  ];

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
      body: Stack(
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
                  const SizedBox(height: 100), // 为底部固定按钮留出空间
                ],
              ),
            ),
          ),
          _buildBottomPayBar(),
        ],
      ),
    );
  }

  /// 1. 顶部精简会员卡片 (呼应上一页面的设计)
  Widget _buildMiniVipCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xfffca63c), Color(0xfff16532)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.star, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '小厨尊享会员 (PRO)',
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  '2027-05-29 到期',
                  style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 12),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  /// 区块标题
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Text(
        title,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xff333333)),
      ),
    );
  }

  /// 2. 套餐选择网格
  Widget _buildPackageGrid() {
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
        final item = _packages[index];
        final isSelected = _selectedPackageIndex == index;
        final hasTag = (item['tag'] as String).isNotEmpty;

        return GestureDetector(
          onTap: () => setState(() => _selectedPackageIndex = index),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xfffff7f4) : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? const Color(0xfff16532) : Colors.transparent,
                    width: 1.5,
                  ),
                ),
                padding: const EdgeInsets.all(14),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['title'],
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? const Color(0xfff16532) : const Color(0xff333333),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '￥',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: isSelected ? const Color(0xfff16532) : const Color(0xff333333)),
                        ),
                        Text(
                          item['price'],
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: isSelected ? const Color(0xfff16532) : const Color(0xff333333)),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '￥${item['originalPrice']}',
                          style: const TextStyle(fontSize: 11, color: Color(0xffbbbbbb), decoration: TextDecoration.lineThrough),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item['desc'],
                      style: const TextStyle(fontSize: 10, color: Color(0xff999999)),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              if (hasTag)
                Positioned(
                  top: -6,
                  left: -2,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(colors: [Color(0xfff16532), Color(0xfffca63c)]),
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(8), bottomRight: Radius.circular(8)),
                    ),
                    child: Text(
                      item['tag'],
                      style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
                    ),
                  ),
                )
            ],
          ),
        );
      },
    );
  }

  /// 3. 支付方式列表 (Google Play / Apple Pay / 支付宝)
  Widget _buildPayMethods() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          _buildPayTile(
            id: 'google',
            icon: Icons.shop_two,
            iconColor: Colors.blue,
            title: 'Google Play',
            subtitle: '支持 Google 绑定的卡券与信用卡',
          ),
          const Divider(height: 1, indent: 54),
          _buildPayTile(
            id: 'apple',
            icon: Icons.apple,
            iconColor: Colors.black,
            title: 'Apple Pay',
            subtitle: '通过 App Store 安全支付',
          ),
          const Divider(height: 1, indent: 54),
          _buildPayTile(
            id: 'alipay',
            icon: Icons.account_balance_wallet,
            iconColor: const Color(0xff108ee9),
            title: '支付宝支付',
            subtitle: '跳转支付宝客户端进行快捷支付',
          ),
        ],
      ),
    );
  }

  Widget _buildPayTile({
    required String id,
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
  }) {
    final isSelected = _selectedPayMethod == id;
    return ListTile(
      onTap: () => setState(() => _selectedPayMethod = id),
      leading: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(color: iconColor.withOpacity(0.1), shape: BoxShape.circle),
        child: Icon(icon, color: iconColor, size: 24),
      ),
      title: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xff333333))),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 11, color: Color(0xff999999))),
      trailing: Icon(
        isSelected ? Icons.check_circle : Icons.radio_button_off,
        color: isSelected ? const Color(0xfff16532) : const Color(0xffcccccc),
        size: 22,
      ),
    );
  }

  /// 4. 底部固定结算栏
  Widget _buildBottomPayBar() {
    final currentPrice = _packages[_selectedPackageIndex]['price'];
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 12,
          bottom: MediaQuery.of(context).padding.bottom + 12,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, -4))],
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
                Text(
                  currentPrice,
                  style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xfff16532)),
                ),
              ],
            ),
            GestureDetector(
              onTap: () {
                // TODO: 在这里触发实际的底层支付逻辑
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('正在使用 $_selectedPayMethod 支付 ￥$currentPrice...')),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 12),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xfffca63c), Color(0xfff16532)]),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Text(
                  '立即安全支付',
                  style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}