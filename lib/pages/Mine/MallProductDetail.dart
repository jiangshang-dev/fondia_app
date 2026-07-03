import 'package:flutter/material.dart';
import 'package:fondia/api/member.dart';
import 'package:fondia/constants/index.dart';
import 'package:fondia/models/member_models.dart';
import 'package:fondia/pages/Mine/AddressManage.dart';

class MallProductDetailView extends StatefulWidget {
  const MallProductDetailView({super.key, required this.productId});

  final String productId;

  @override
  State<MallProductDetailView> createState() => _MallProductDetailViewState();
}

class _MallProductDetailViewState extends State<MallProductDetailView> {
  MallProduct? _product;
  PointsAccountSummary? _points;
  UserAddress? _selectedAddress;
  bool _loading = true;
  bool _redeeming = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final results = await Future.wait([
        MemberApi.getMallProductDetail(widget.productId),
        MemberApi.getPointsSummary(),
      ]);
      if (!mounted) return;
      final product = results[0] as MallProduct;
      setState(() {
        _product = product;
        _points = results[1] as PointsAccountSummary;
      });
      if (product.isPhysical) {
        final addresses = await MemberApi.getAddressList();
        if (!mounted) return;
        setState(() {
          _selectedAddress = addresses.isEmpty
              ? null
              : addresses.firstWhere((a) => a.isDefault == 1, orElse: () => addresses.first);
        });
      }
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

  String? _resolveImage(String? url) {
    if (url == null || url.isEmpty) return null;
    if (url.startsWith('http')) return url;
    return '${GlobalConstants.BASE_URL}/sys/common/static/$url';
  }

  Future<void> _pickAddress() async {
    final picked = await Navigator.push<UserAddress>(
      context,
      MaterialPageRoute(builder: (_) => const AddressManageView(selectMode: true)),
    );
    if (picked != null) setState(() => _selectedAddress = picked);
  }

  Future<void> _redeem() async {
    final product = _product;
    if (product == null || _redeeming) return;

    if (product.isPhysical && _selectedAddress?.id == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('请先选择收货地址')));
      return;
    }

    final balance = _points?.balance ?? 0;
    if (balance < product.pointsPrice) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('积分不足')));
      return;
    }

    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('确认兑换'),
        content: Text('将消耗 ${product.pointsPrice} 积分兑换「${product.name}」'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('取消')),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('确认')),
        ],
      ),
    );
    if (ok != true) return;

    setState(() => _redeeming = true);
    try {
      final order = await MemberApi.redeemProduct(
        productId: product.id,
        addressId: product.isPhysical ? _selectedAddress!.id : null,
      );
      if (!mounted) return;
      final msg = product.isVirtual
          ? '兑换成功！${order.virtualPayload ?? '虚拟权益已发放'}'
          : '兑换成功，订单号：${order.orderNo}，等待发货';
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('兑换成功'),
          content: Text(msg),
          actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('好的'))],
        ),
      );
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString().replaceFirst('DioException: ', ''))),
        );
      }
    } finally {
      if (mounted) setState(() => _redeeming = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final product = _product;
    final img = product != null ? _resolveImage(product.coverImage) : null;

    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB),
      appBar: AppBar(
        title: const Text('商品详情', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
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
          : product == null
              ? const Center(child: Text('商品不存在'))
              : Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AspectRatio(
                              aspectRatio: 1,
                              child: img != null
                                  ? Image.network(img, fit: BoxFit.cover, width: double.infinity,
                                      errorBuilder: (_, __, ___) => _placeholder())
                                  : _placeholder(),
                            ),
                            Container(
                              width: double.infinity,
                              color: Colors.white,
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(product.name,
                                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                  if (product.subtitle != null && product.subtitle!.isNotEmpty) ...[
                                    const SizedBox(height: 6),
                                    Text(product.subtitle!, style: const TextStyle(color: Color(0xFF999999))),
                                  ],
                                  const SizedBox(height: 12),
                                  Text('${product.pointsPrice} 积分',
                                      style: const TextStyle(
                                          color: Color(0xFFFF7043), fontSize: 22, fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 8),
                                  Text(
                                    product.isPhysical ? '实物商品 · 兑换后需填写地址发货' : '虚拟商品 · 兑换后自动到账',
                                    style: const TextStyle(fontSize: 12, color: Color(0xFF888888)),
                                  ),
                                ],
                              ),
                            ),
                            if (product.isPhysical) ...[
                              const SizedBox(height: 12),
                              _buildAddressSection(),
                            ],
                            const SizedBox(height: 80),
                          ],
                        ),
                      ),
                    ),
                    _buildBottomBar(product),
                  ],
                ),
    );
  }

  Widget _buildAddressSection() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('收货地址', style: TextStyle(fontWeight: FontWeight.bold)),
              TextButton(onPressed: _pickAddress, child: const Text('选择地址')),
            ],
          ),
          if (_selectedAddress == null)
            const Text('暂无地址，请先添加', style: TextStyle(color: Colors.grey))
          else
            Text(
              '${_selectedAddress!.receiverName} ${_selectedAddress!.receiverPhone}\n${_selectedAddress!.fullText}',
              style: const TextStyle(height: 1.5),
            ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(MallProduct product) {
    final balance = _points?.balance ?? 0;
    return Container(
      padding: EdgeInsets.only(left: 16, right: 16, top: 12, bottom: MediaQuery.of(context).padding.bottom + 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, -2))],
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('我的积分：$balance', style: const TextStyle(fontSize: 12, color: Color(0xFF666666))),
              Text('${product.pointsPrice} 积分', style: const TextStyle(color: Color(0xFFFF7043), fontWeight: FontWeight.bold)),
            ],
          ),
          const Spacer(),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF7043),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            ),
            onPressed: _redeeming ? null : _redeem,
            child: _redeeming
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                : Text(product.isVirtual ? '立即兑换' : '确认兑换'),
          ),
        ],
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      color: const Color(0xFFEEEEEE),
      child: const Center(child: Icon(Icons.card_giftcard, color: Colors.grey, size: 64)),
    );
  }
}
