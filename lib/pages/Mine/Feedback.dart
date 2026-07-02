import 'package:flutter/material.dart';
import 'package:fondia/api/user.dart';
import 'package:fondia/stores/TokenManager.dart';
import 'package:fondia/utils/recipe_image.dart';
import 'package:image_picker/image_picker.dart';

class FeedbackView extends StatefulWidget {
  const FeedbackView({super.key});

  @override
  State<FeedbackView> createState() => _FeedbackViewState();
}

class _FeedbackViewState extends State<FeedbackView> {
  final List<String> _feedbackTypes = ['功能建议', '性能问题', '内容报错', '积分/签到', '其他问题'];
  int _selectedTypeIndex = 0;

  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();

  final List<String> _imageUrls = [];
  bool _uploadingImage = false;
  bool _submitting = false;

  @override
  void dispose() {
    _contentController.dispose();
    _contactController.dispose();
    super.dispose();
  }

  Future<bool> _ensureLogin() async {
    if (tokenManager.isLoggedIn()) return true;
    if (!mounted) return false;
    final goLogin = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('提示'),
        content: const Text('提交反馈需要先登录'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('取消')),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('去登录')),
        ],
      ),
    );
    if (goLogin == true && mounted) {
      await Navigator.pushNamed(context, '/login');
    }
    return tokenManager.isLoggedIn();
  }

  Future<void> _pickAndUploadImage() async {
    if (_imageUrls.length >= 3 || _uploadingImage) return;
    if (!await _ensureLogin()) return;

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
              leading: const Icon(Icons.photo_library_outlined, color: Color(0xFFFF6A1A)),
              title: const Text('从相册选择'),
              onTap: () => Navigator.pop(ctx, ImageSource.gallery),
            ),
            ListTile(
              leading: const Icon(Icons.photo_camera_outlined, color: Color(0xFFFF6A1A)),
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
        maxWidth: 1280,
        maxHeight: 1280,
        imageQuality: 85,
      );
      if (picked == null || !mounted) return;

      setState(() => _uploadingImage = true);
      final url = await UserApi.uploadFeedbackImage(picked.path);
      if (!mounted) return;
      setState(() {
        _imageUrls.add(url);
        _uploadingImage = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _uploadingImage = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
      );
    }
  }

  void _removeImage(int index) {
    setState(() => _imageUrls.removeAt(index));
  }

  Future<void> _submit() async {
    if (_submitting) return;
    final content = _contentController.text.trim();
    if (content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请填写反馈内容')),
      );
      return;
    }
    if (!await _ensureLogin()) return;

    setState(() => _submitting = true);
    try {
      await UserApi.submitFeedback(
        feedbackType: _feedbackTypes[_selectedTypeIndex],
        content: content,
        contact: _contactController.text.trim(),
        images: _imageUrls,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('感谢您的反馈，我们会尽快处理！'),
          backgroundColor: Color(0xFFFF6A1A),
        ),
      );
      Navigator.maybePop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
      );
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18, color: Color(0xFF333333)),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: const Text(
          '意见反馈',
          style: TextStyle(color: Color(0xFF333333), fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Stack(
          children: [
            ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
              children: [
                _buildSectionTitle('反馈类型'),
                _buildTypeSelector(),
                const SizedBox(height: 20),
                _buildSectionTitle('反馈内容'),
                _buildContentCard(),
                const SizedBox(height: 20),
                _buildSectionTitle('联系方式（选填）'),
                _buildContactCard(),
              ],
            ),
            _buildBottomSubmitButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 10),
      child: Text(
        title,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF333333)),
      ),
    );
  }

  Widget _buildTypeSelector() {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: List.generate(_feedbackTypes.length, (index) {
        final isSelected = _selectedTypeIndex == index;
        return InkWell(
          onTap: () => setState(() => _selectedTypeIndex = index),
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFFFFF2EB) : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected ? const Color(0xFFFF8A4C) : const Color(0xFFEFEFEF),
                width: 1.2,
              ),
            ),
            child: Text(
              _feedbackTypes[index],
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? const Color(0xFFFF6A1A) : const Color(0xFF666666),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildContentCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _contentController,
            maxLines: 5,
            maxLength: 300,
            style: const TextStyle(fontSize: 14, color: Color(0xFF333333)),
            decoration: const InputDecoration(
              hintText: '请详细描述您遇到的问题或提出的建议，小厨会认真阅读并不断优化体验～',
              hintStyle: TextStyle(color: Color(0xFFBBBBBB), fontSize: 13, height: 1.4),
              border: InputBorder.none,
              counterStyle: TextStyle(color: Color(0xFFBBBBBB), fontSize: 11),
            ),
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: Color(0xFFF5F5F5)),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              ...List.generate(_imageUrls.length, (index) => _buildImageItem(_imageUrls[index], index)),
              if (_imageUrls.length < 3 && !_uploadingImage) _buildUploadTrigger(),
              if (_uploadingImage)
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFAFAFA),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  alignment: Alignment.center,
                  child: const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFFFF6A1A)),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            '最多可上传 3 张截图或图片（选填）',
            style: TextStyle(fontSize: 11, color: Color(0xFF999999)),
          ),
        ],
      ),
    );
  }

  Widget _buildImageItem(String url, int index) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: SizedBox(
            width: 72,
            height: 72,
            child: RecipeImage(url: url, fit: BoxFit.cover, width: 72, height: 72),
          ),
        ),
        Positioned(
          top: -6,
          right: -6,
          child: GestureDetector(
            onTap: () => _removeImage(index),
            child: Container(
              width: 20,
              height: 20,
              decoration: const BoxDecoration(color: Colors.black54, shape: BoxShape.circle),
              child: const Icon(Icons.close, size: 14, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUploadTrigger() {
    return InkWell(
      onTap: _pickAndUploadImage,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 72,
        height: 72,
        decoration: BoxDecoration(
          color: const Color(0xFFFAFAFA),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFE5E5E5)),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_photo_alternate_outlined, size: 24, color: Color(0xFF999999)),
            SizedBox(height: 4),
            Text('传图片', style: TextStyle(fontSize: 11, color: Color(0xFF999999))),
          ],
        ),
      ),
    );
  }

  Widget _buildContactCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextField(
        controller: _contactController,
        style: const TextStyle(fontSize: 14, color: Color(0xFF333333)),
        decoration: const InputDecoration(
          hintText: '手机号 / 邮箱 / QQ（方便我们与您联系）',
          hintStyle: TextStyle(color: Color(0xFFBBBBBB), fontSize: 13),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildBottomSubmitButton() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        color: Colors.white,
        child: InkWell(
          onTap: _submitting ? null : _submit,
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: _submitting
                    ? [Colors.grey.shade400, Colors.grey.shade500]
                    : const [Color(0xFFFF955B), Color(0xFFFF6A1A)],
              ),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Center(
              child: _submitting
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : const Text(
                      '提交反馈',
                      style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
