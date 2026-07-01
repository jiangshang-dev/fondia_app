import 'package:flutter/material.dart';
import 'package:fondia/api/user.dart';
import 'package:fondia/models/user_profile.dart';
import 'package:fondia/pages/Mine/Account.dart';
import 'package:fondia/pages/Mine/Feedback.dart';
import 'package:fondia/stores/TokenManager.dart';
import 'package:fondia/utils/region_data.dart';
import 'package:fondia/widgets/ChineseDatePicker.dart';
import 'package:fondia/widgets/RegionPickerSheet.dart';
import 'package:image_picker/image_picker.dart';

class UserInfoView extends StatefulWidget {
  const UserInfoView({super.key});

  @override
  State<UserInfoView> createState() => _UserInfoViewState();
}

class _UserInfoViewState extends State<UserInfoView> {
  UserProfile? _profile;
  bool _loading = true;
  bool _saving = false;
  bool _uploadingAvatar = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final profile = await UserApi.getProfile();
      if (!mounted) return;
      setState(() {
        _profile = profile;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  Future<void> _saveProfile() async {
    if (_profile == null || _saving) return;
    setState(() => _saving = true);
    try {
      final updated = await UserApi.updateProfile(_profile!);
      await tokenManager.saveUserInfo(updated.toUpdateJson()
        ..['id'] = updated.id
        ..['username'] = updated.username
        ..['phone'] = updated.phone
        ..['email'] = updated.email);
      if (!mounted) return;
      setState(() {
        _profile = updated;
        _saving = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('保存成功')),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
      );
    }
  }

  Future<String?> _editText({
    required String title,
    required String initial,
    int maxLines = 1,
  }) async {
    final controller = TextEditingController(text: initial);
    return showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: controller,
          maxLines: maxLines,
          autofocus: true,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('取消')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, controller.text.trim()),
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }

  Future<void> _editNickname() async {
    final value = await _editText(
      title: '修改昵称',
      initial: _profile?.nickname ?? '',
    );
    if (value != null && mounted) {
      setState(() => _profile = _profile!.copyWith(nickname: value));
    }
  }

  Future<void> _editSign() async {
    final value = await _editText(
      title: '修改个性签名',
      initial: _profile?.sign ?? '',
      maxLines: 3,
    );
    if (value != null && mounted) {
      setState(() => _profile = _profile!.copyWith(sign: value));
    }
  }

  Future<void> _editAvatar() async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library_outlined, color: Color(0xffff7f32)),
              title: const Text('从相册选择'),
              onTap: () => Navigator.pop(ctx, ImageSource.gallery),
            ),
            ListTile(
              leading: const Icon(Icons.photo_camera_outlined, color: Color(0xffff7f32)),
              title: const Text('拍照上传'),
              onTap: () => Navigator.pop(ctx, ImageSource.camera),
            ),
          ],
        ),
      ),
    );
    if (source == null || !mounted) return;

    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );
      if (picked == null || !mounted) return;

      setState(() => _uploadingAvatar = true);
      final url = await UserApi.uploadAvatar(picked.path);
      if (!mounted) return;
      setState(() {
        _profile = _profile!.copyWith(avatar: url);
        _uploadingAvatar = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('头像上传成功')),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _uploadingAvatar = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
      );
    }
  }

  Future<void> _editBirthday() async {
    final initial = DateTime.tryParse(_profile?.birthday ?? '') ?? DateTime(1995, 8, 18);
    final picked = await ChineseDatePicker.show(
      context,
      initialDate: initial,
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (picked != null && mounted) {
      final text =
          '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
      setState(() => _profile = _profile!.copyWith(birthday: text));
    }
  }

  Future<void> _editAddress() async {
    final provinces = await RegionData.load();
    final initial = RegionData.matchSelection(
      provinces,
      province: _profile?.province,
      city: _profile?.city,
      district: _profile?.district,
    );
    if (!mounted) return;

    final selected = await RegionPickerSheet.show(context, initial: initial);
    if (selected != null && mounted) {
      setState(() => _profile = _profile!.copyWith(
            province: selected.province,
            city: selected.city,
            district: selected.district,
          ));
    }
  }

  Future<void> _editGender() async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('女'),
              onTap: () => Navigator.pop(ctx, '2'),
            ),
            ListTile(
              title: const Text('男'),
              onTap: () => Navigator.pop(ctx, '1'),
            ),
            ListTile(
              title: const Text('未知'),
              onTap: () => Navigator.pop(ctx, '0'),
            ),
          ],
        ),
      ),
    );
    if (selected != null && mounted) {
      setState(() => _profile = _profile!.copyWith(gender: selected));
    }
  }

  Future<void> _editCookLevel() async {
    final selected = await showModalBottomSheet<int>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [1, 2, 3, 4]
              .map(
                (level) => ListTile(
                  title: Text(UserProfile(cookingLevel: level).cookLevelText),
                  onTap: () => Navigator.pop(ctx, level),
                ),
              )
              .toList(),
        ),
      ),
    );
    if (selected != null && mounted) {
      setState(() => _profile = _profile!.copyWith(cookingLevel: selected));
    }
  }

  Future<void> _editTaste() async {
    final value = await _editText(
      title: '口味偏好',
      initial: _profile?.tastePreference ?? '偏好清淡、微辣、甜口',
    );
    if (value != null && mounted) {
      setState(() => _profile = _profile!.copyWith(tastePreference: value));
    }
  }

  Future<void> _editDietary() async {
    final value = await _editText(
      title: '饮食偏好',
      initial: _profile?.dietaryPreference ?? '普通饮食',
    );
    if (value != null && mounted) {
      setState(() => _profile = _profile!.copyWith(dietaryPreference: value));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfffcf9f7),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87, size: 20),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: const Text(
          '个人信息',
          style: TextStyle(color: Colors.black87, fontSize: 18, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: Color(0xffff7f32)))
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(_error!, style: const TextStyle(color: Colors.grey)),
                      TextButton(onPressed: _loadProfile, child: const Text('重试')),
                    ],
                  ),
                )
              : SafeArea(
                  child: Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 10),
                              _buildHeaderCard(),
                              const SizedBox(height: 20),
                              _buildSectionTitle('基础信息'),
                              _buildGroupContainer([
                                _buildListItem(Icons.person_outline, '昵称',
                                    trailingText: _profile!.displayName,
                                    onTap: _editNickname),
                                _buildListItem(Icons.calendar_month_outlined, '生日',
                                    trailingText: _profile!.birthdayDisplayText,
                                    onTap: _editBirthday),
                                _buildListItem(Icons.location_on_outlined, '地址',
                                    trailingText: _profile!.addressText,
                                    onTap: _editAddress),
                                _buildListItem(Icons.wc_outlined, '性别',
                                    trailingText: _profile!.genderText,
                                    onTap: _editGender),
                                _buildListItem(Icons.edit_note_outlined, '个性签名',
                                    trailingText: _profile!.displaySign,
                                    onTap: _editSign),
                                _buildListItem(
                                  Icons.stars_outlined,
                                  '厨艺等级',
                                  onTap: _editCookLevel,
                                  customTrailing: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: const Color(0xfffff0e6),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: const Color(0xffffa366)),
                                    ),
                                    child: Text(
                                      _profile!.cookLevelText,
                                      style: const TextStyle(
                                          color: Color(0xffff6600), fontSize: 12),
                                    ),
                                  ),
                                ),
                                _buildListItem(Icons.shield_outlined, '账号安全',
                                    trailingText: _profile!.securityText,
                                    onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (_) => const Account()),
                                  );
                                }),
                              ]),
                              const SizedBox(height: 20),
                              _buildSectionTitle('偏好设置'),
                              _buildGroupContainer([
                                _buildListItem(Icons.favorite_border, '口味偏好',
                                    trailingText:
                                        _profile!.tastePreference ?? '偏好清淡、微辣、甜口',
                                    onTap: _editTaste),
                                _buildListItem(Icons.description_outlined, '饮食偏好',
                                    trailingText: _profile!.dietaryPreference ?? '普通饮食',
                                    onTap: _editDietary),
                                _buildListItem(
                                  Icons.notifications_none,
                                  '消息通知',
                                  showArrow: false,
                                  customTrailing: Switch(
                                    value: _profile!.notifyEnabled,
                                    activeTrackColor: const Color(0xffff7f32),
                                    onChanged: (val) => setState(
                                      () => _profile = _profile!.copyWith(notifyEnabled: val),
                                    ),
                                  ),
                                ),
                                _buildListItem(
                                  Icons.star_border,
                                  '参与活动',
                                  showArrow: false,
                                  trailingText: '接收活动与福利信息',
                                  customTrailing: Switch(
                                    value: _profile!.activityEnabled,
                                    activeTrackColor: const Color(0xffff7f32),
                                    onChanged: (val) => setState(
                                      () => _profile = _profile!.copyWith(activityEnabled: val),
                                    ),
                                  ),
                                ),
                              ]),
                              const SizedBox(height: 20),
                              _buildSectionTitle('其他'),
                              _buildGroupContainer([
                                _buildListItem(Icons.help_outline, '帮助与反馈', onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (_) => const FeedbackView()),
                                  );
                                }),
                                _buildListItem(Icons.info_outline, '关于我们', onTap: () {
                                  showAboutDialog(
                                    context: context,
                                    applicationName: 'Fondia',
                                    applicationVersion: '1.0.0',
                                    children: const [
                                      Text('爱生活，爱美食，爱分享每一道好菜~'),
                                    ],
                                  );
                                }),
                              ]),
                              const SizedBox(height: 30),
                            ],
                          ),
                        ),
                      ),
                      _buildSaveButton(),
                    ],
                  ),
                ),
    );
  }

  Widget _buildHeaderCard() {
    final avatarUrl = _profile?.avatarUrl;
    final hasAvatar = avatarUrl != null;
    return GestureDetector(
      onTap: _uploadingAvatar ? null : _editAvatar,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.grey[200],
                  backgroundImage:
                      hasAvatar ? NetworkImage(avatarUrl!) : null,
                  child: hasAvatar
                      ? null
                      : const Icon(Icons.person, size: 40, color: Colors.grey),
                ),
                if (_uploadingAvatar)
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black26,
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  )
                else
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Color(0xffff7f32),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.camera_alt, color: Colors.white, size: 14),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _profile!.displayName,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _profile!.displaySign,
                    style: TextStyle(fontSize: 13, color: Colors.grey[500]),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.black26, size: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87),
      ),
    );
  }

  Widget _buildGroupContainer(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: children.length,
        separatorBuilder: (_, __) =>
            const Divider(height: 1, indent: 50, color: Color(0xfff5f5f5)),
        itemBuilder: (_, index) => children[index],
      ),
    );
  }

  Widget _buildListItem(
    IconData icon,
    String title, {
    String? trailingText,
    Widget? customTrailing,
    bool showArrow = true,
    VoidCallback? onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      leading: Icon(icon, color: const Color(0xffff7f32), size: 22),
      title: Text(title, style: const TextStyle(fontSize: 15, color: Colors.black87)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trailingText != null)
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 160),
              child: Text(
                trailingText,
                style: TextStyle(fontSize: 14, color: Colors.grey[400]),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.right,
              ),
            ),
          if (customTrailing != null) ...[
            const SizedBox(width: 6),
            customTrailing,
          ],
          if (showArrow) ...[
            const SizedBox(width: 6),
            const Icon(Icons.arrow_forward_ios, color: Colors.black26, size: 14),
          ],
        ],
      ),
      onTap: onTap,
    );
  }

  Widget _buildSaveButton() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: Colors.white,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _saving ? null : _saveProfile,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xffff7f32),
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(48),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          elevation: 0,
        ),
        child: _saving
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
              )
            : const Text('保存修改', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
