import 'package:flutter/material.dart';

// 意见反馈组件
class FeedbackView extends StatefulWidget {
  const FeedbackView({super.key});

  @override
  State<FeedbackView> createState() => _FeedbackViewState();
}

class _FeedbackViewState extends State<FeedbackView> {
  // 反馈类型列表
  final List<String> _feedbackTypes = ['功能建议', '性能问题', '内容报错', '积分/签到', '其他问题'];
  // 当前选中的反馈类型索引
  int _selectedTypeIndex = 0;

  // 输入框控制器
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();

  // 模拟已选择的图片列表（实际开发中可配合 image_picker 使用）
  final List<String> _selectedImages = [];

  @override
  void dispose() {
    _contentController.dispose();
    _contactController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 沿用系统的浅灰/微蓝白低调背景色（源自 image_eb7269.png）
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
        onTap: () => FocusScope.of(context).unfocus(), // 点击空白处收起键盘
        child: Stack(
          children: [
            // 主体滚动表单内容
            ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 100), // 底部留出空间给提交按钮
              children: [
                // 1. 反馈类型选择区域
                _buildSectionTitle('反馈类型'),
                _buildTypeSelector(),
                const SizedBox(height: 20),

                // 2. 反馈内容输入与图片上传卡片（整合在纯白圆角卡片中）
                _buildSectionTitle('反馈内容'),
                _buildContentCard(),
                const SizedBox(height: 20),

                // 3. 联系方式输入卡片
                _buildSectionTitle('联系方式（选填）'),
                _buildContactCard(),
              ],
            ),

            // 4. 底部固定“提交反馈”大橙色按钮
            _buildBottomSubmitButton(),
          ],
        ),
      ),
    );
  }

  // 小标题构建器（致敬“我的内容”深灰色标题加粗风格）
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 10),
      child: Text(
        title,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF333333)),
      ),
    );
  }

  // 1. 反馈类型选择器组件（横向流式标签）
  Widget _buildTypeSelector() {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: List.generate(_feedbackTypes.length, (index) {
        final isSelected = _selectedTypeIndex == index;
        return InkWell(
          onTap: () {
            setState(() {
              _selectedTypeIndex = index;
            });
          },
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              // 选中时采用主题渐变橙的单色淡化版或纯白，未选中时为纯白
              color: isSelected ? const Color(0xFFFFF2EB) : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected ? const Color(0xFFFF8A4C) : const Color(0xFFEFEFEF),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.01), blurRadius: 4, offset: const Offset(0, 2))
              ],
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

  // 2. 反馈内容与图片上传的复合卡片容器
  Widget _buildContentCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.01), blurRadius: 10, offset: const Offset(0, 2))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 文本输入框
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

          // 图片上传九宫格区域
          Row(
            children: [
              // 模拟已选图片显示
              ..._selectedImages.map((img) => _buildImageItem(img)),
              // 如果图片没满3张，显示上传按钮
              if (_selectedImages.length < 3) _buildUploadTrigger(),
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

  // 单个已选图片预览小方块
  Widget _buildImageItem(String path) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F7),
        borderRadius: BorderRadius.circular(8),
        image: DecorationImage(image: NetworkImage(path), fit: BoxFit.cover),
      ),
    );
  }

  // 添加图片的虚线/加号触发器
  Widget _buildUploadTrigger() {
    return InkWell(
      onTap: () {
        // 触发相册选择逻辑
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 72,
        height: 72,
        decoration: BoxDecoration(
          color: const Color(0xFFFAFAFA),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFE5E5E5), style: BorderStyle.solid),
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

  // 3. 联系方式卡片组件
  Widget _buildContactCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.01), blurRadius: 10, offset: const Offset(0, 2))
        ],
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

  // 4. 底部固定橙色提交按钮
  Widget _buildBottomSubmitButton() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        color: Colors.white,
        child: InkWell(
          onTap: () {
            // 执行提交反馈逻辑（业务代码接口调用）
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('感谢您的反馈，我们会尽快处理！'), backgroundColor: Color(0xFFFF6A1A)),
            );
            Navigator.maybePop(context);
          },
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFF955B), Color(0xFFFF6A1A)], // 深度还原大橙卡渐变
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFF6A1A).withOpacity(0.2),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                )
              ],
            ),
            child: const Center(
              child: Text(
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