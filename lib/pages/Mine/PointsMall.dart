import 'package:flutter/material.dart';
import 'package:fondia/api/member.dart';
import 'package:fondia/pages/Mine/AddressManage.dart';
import 'package:fondia/pages/Mine/MallProductDetail.dart';
import 'package:fondia/constants/index.dart';
import 'package:fondia/models/member_models.dart';

class PointsMallView extends StatefulWidget {
  const PointsMallView({super.key});

  @override
  State<PointsMallView> createState() => _PointsMallViewState();
}

class _PointsMallViewState extends State<PointsMallView> {
  List<MallProduct> _products = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final products = await MemberApi.getMallProducts();
      if (!mounted) return;
      setState(() => _products = products);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB),
      appBar: AppBar(
        title: const Text('积分商城', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 18, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.location_on_outlined, color: Colors.black87),
            tooltip: '收货地址',
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AddressManageView())),
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _load,
              child: GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.72,
                ),
                itemCount: _products.length,
                itemBuilder: (context, index) {
                  final p = _products[index];
                  final img = _resolveImage(p.coverImage);
                  return GestureDetector(
                    onTap: () async {
                      final refreshed = await Navigator.push<bool>(
                        context,
                        MaterialPageRoute(builder: (_) => MallProductDetailView(productId: p.id)),
                      );
                      if (refreshed == true) _load();
                    },
                    child: Container(
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: img != null
                              ? Image.network(img, width: double.infinity, fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => _placeholder())
                              : _placeholder(),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(p.name, maxLines: 2, overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                              const SizedBox(height: 6),
                              Text('${p.pointsPrice} 积分', style: const TextStyle(color: Color(0xFFFF7043), fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    ),
                  );
                },
              ),
            ),
    );
  }

  Widget _placeholder() {
    return Container(
      color: const Color(0xFFEEEEEE),
      child: const Center(child: Icon(Icons.card_giftcard, color: Colors.grey, size: 40)),
    );
  }
}
