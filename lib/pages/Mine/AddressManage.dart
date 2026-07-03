import 'package:flutter/material.dart';
import 'package:fondia/api/member.dart';
import 'package:fondia/models/member_models.dart';

class AddressManageView extends StatefulWidget {
  const AddressManageView({super.key, this.selectMode = false});

  /// 从商城兑换进入时为 true，点击地址即返回选中项
  final bool selectMode;

  @override
  State<AddressManageView> createState() => _AddressManageViewState();
}

class _AddressManageViewState extends State<AddressManageView> {
  List<UserAddress> _list = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final list = await MemberApi.getAddressList();
      if (!mounted) return;
      setState(() => _list = list);
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

  Future<void> _openEditor([UserAddress? address]) async {
    final saved = await Navigator.push<UserAddress>(
      context,
      MaterialPageRoute(builder: (_) => _AddressEditView(address: address)),
    );
    if (saved != null) _load();
  }

  Future<void> _delete(UserAddress address) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('删除地址'),
        content: const Text('确定删除该收货地址吗？'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('取消')),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('删除')),
        ],
      ),
    );
    if (ok != true || address.id == null) return;
    try {
      await MemberApi.deleteAddress(address.id!);
      if (mounted) _load();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString().replaceFirst('DioException: ', ''))),
        );
      }
    }
  }

  Future<void> _setDefault(UserAddress address) async {
    if (address.id == null) return;
    try {
      await MemberApi.setDefaultAddress(address.id!);
      if (mounted) _load();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString().replaceFirst('DioException: ', ''))),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB),
      appBar: AppBar(
        title: Text(widget.selectMode ? '选择收货地址' : '收货地址',
            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
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
              child: _list.isEmpty
                  ? ListView(
                      children: const [
                        SizedBox(height: 120),
                        Center(child: Text('暂无地址，请添加', style: TextStyle(color: Colors.grey))),
                      ],
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: _list.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final item = _list[index];
                        return _AddressCard(
                          address: item,
                          onTap: widget.selectMode
                              ? () => Navigator.pop(context, item)
                              : null,
                          onEdit: () => _openEditor(item),
                          onDelete: () => _delete(item),
                          onSetDefault: item.isDefault == 1 ? null : () => _setDefault(item),
                        );
                      },
                    ),
            ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF7043),
              foregroundColor: Colors.white,
              minimumSize: const Size.fromHeight(48),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            ),
            onPressed: () => _openEditor(),
            child: const Text('新增地址', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ),
      ),
    );
  }
}

class _AddressCard extends StatelessWidget {
  const _AddressCard({
    required this.address,
    this.onTap,
    required this.onEdit,
    required this.onDelete,
    this.onSetDefault,
  });

  final UserAddress address;
  final VoidCallback? onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback? onSetDefault;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(address.receiverName,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  const SizedBox(width: 12),
                  Text(address.receiverPhone, style: const TextStyle(color: Color(0xFF666666))),
                  if (address.isDefault == 1) ...[
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF7043).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text('默认', style: TextStyle(color: Color(0xFFFF7043), fontSize: 11)),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 8),
              Text(address.fullText, style: const TextStyle(color: Color(0xFF333333), height: 1.4)),
              if (onTap == null) ...[
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (onSetDefault != null)
                      TextButton(onPressed: onSetDefault, child: const Text('设为默认')),
                    TextButton(onPressed: onEdit, child: const Text('编辑')),
                    TextButton(onPressed: onDelete, child: const Text('删除', style: TextStyle(color: Colors.red))),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _AddressEditView extends StatefulWidget {
  const _AddressEditView({this.address});

  final UserAddress? address;

  @override
  State<_AddressEditView> createState() => _AddressEditViewState();
}

class _AddressEditViewState extends State<_AddressEditView> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  late final TextEditingController _phoneCtrl;
  late final TextEditingController _provinceCtrl;
  late final TextEditingController _cityCtrl;
  late final TextEditingController _districtCtrl;
  late final TextEditingController _detailCtrl;
  bool _isDefault = false;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final a = widget.address;
    _nameCtrl = TextEditingController(text: a?.receiverName ?? '');
    _phoneCtrl = TextEditingController(text: a?.receiverPhone ?? '');
    _provinceCtrl = TextEditingController(text: a?.province ?? '');
    _cityCtrl = TextEditingController(text: a?.city ?? '');
    _districtCtrl = TextEditingController(text: a?.district ?? '');
    _detailCtrl = TextEditingController(text: a?.detailAddress ?? '');
    _isDefault = (a?.isDefault ?? 0) == 1;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _provinceCtrl.dispose();
    _cityCtrl.dispose();
    _districtCtrl.dispose();
    _detailCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate() || _saving) return;
    setState(() => _saving = true);
    try {
      final addr = UserAddress(
        id: widget.address?.id,
        receiverName: _nameCtrl.text.trim(),
        receiverPhone: _phoneCtrl.text.trim(),
        province: _provinceCtrl.text.trim(),
        city: _cityCtrl.text.trim(),
        district: _districtCtrl.text.trim(),
        detailAddress: _detailCtrl.text.trim(),
        isDefault: _isDefault ? 1 : 0,
      );
      final saved = await MemberApi.saveAddress(addr);
      if (!mounted) return;
      Navigator.pop(context, saved);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString().replaceFirst('DioException: ', ''))),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.address == null ? '新增地址' : '编辑地址'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _field('收货人', _nameCtrl, validator: (v) => (v == null || v.trim().isEmpty) ? '请输入收货人' : null),
            _field('手机号', _phoneCtrl,
                keyboard: TextInputType.phone,
                validator: (v) => (v == null || v.trim().length < 11) ? '请输入有效手机号' : null),
            _field('省份', _provinceCtrl),
            _field('城市', _cityCtrl),
            _field('区县', _districtCtrl),
            _field('详细地址', _detailCtrl, maxLines: 2,
                validator: (v) => (v == null || v.trim().isEmpty) ? '请输入详细地址' : null),
            SwitchListTile(
              title: const Text('设为默认地址'),
              value: _isDefault,
              activeColor: const Color(0xFFFF7043),
              onChanged: (v) => setState(() => _isDefault = v),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF7043),
              foregroundColor: Colors.white,
              minimumSize: const Size.fromHeight(48),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            ),
            onPressed: _saving ? null : _save,
            child: _saving
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                : const Text('保存', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ),
      ),
    );
  }

  Widget _field(String label, TextEditingController ctrl,
      {TextInputType? keyboard, int maxLines = 1, String? Function(String?)? validator}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: ctrl,
        keyboardType: keyboard,
        maxLines: maxLines,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
        ),
      ),
    );
  }
}
