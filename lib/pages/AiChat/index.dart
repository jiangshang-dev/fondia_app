import 'package:flutter/material.dart';

import '../../components/Ai/AiExclusive.dart';

class AiChatView extends StatefulWidget {
  const AiChatView({super.key});

  @override
  State<AiChatView> createState() => _AiChatViewState();
}

class _AiChatViewState extends State<AiChatView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB),
      // 1. 添加顶部导航栏
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "AI营养咨询",
          style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            _buildAIHeader(),
            const SizedBox(height: 24),
            _buildStepTitle("1", "你想咨询什么类型的问题？"),
            const SizedBox(height: 12),
            _buildQuestionTypeGrid(),
            const SizedBox(height: 24),
            _buildStepTitle("2", "告诉我你的基本情况和目标"),
            const SizedBox(height: 12),
            _buildInfoForm(),
            const SizedBox(height: 16),
            _buildPrivacyNote(),
            const SizedBox(height: 24),
            _buildActionButton(),
            const SizedBox(height: 32),
            _buildHotQuestions(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // --- 以下为之前的组件实现，保持不变 ---

  Widget _buildAIHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 30,
                backgroundColor: Color(0xFFF5F5F5),
                // todo 图标
                child: Icon(Icons.air, size: 35, color: Colors.orange),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF9F2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    "Hi，我是你的AI营养师\n告诉我你的身体状况和饮食目标，我将为你定制专属的健康饮食方案",
                    style: TextStyle(fontSize: 13, color: Color(0xFF4D2C19), height: 1.5),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildFeatureIcon(Icons.track_changes, "科学定制"),
              _buildFeatureIcon(Icons.verified_user_outlined, "专业可靠"),
              _buildFeatureIcon(Icons.lock_outline, "隐私安全"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureIcon(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.orange),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(fontSize: 11, color: Colors.grey)),
      ],
    );
  }

  Widget _buildStepTitle(String step, String title) {
    return Row(
      children: [
        Container(
          width: 22,
          height: 22,
          alignment: Alignment.center,
          decoration: const BoxDecoration(color: Colors.orange, shape: BoxShape.circle),
          child: Text(step, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(width: 8),
        Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildQuestionTypeGrid() {
    final types = [
      {"name": "减脂餐", "icon": Icons.scale, "selected": true, "color": Colors.green},
      {"name": "控糖饮食", "icon": Icons.water_drop, "selected": false, "color": Colors.blue},
      {"name": "高血压饮食", "icon": Icons.favorite, "selected": false, "color": Colors.red},
      {"name": "高尿酸饮食", "icon": Icons.lens_blur, "selected": false, "color": Colors.purple},
      {"name": "肠胃养护", "icon": Icons.spa, "selected": false, "color": Colors.orange},
      {"name": "其他需求", "icon": Icons.grid_view, "selected": false, "color": Colors.brown},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 0.9,
      ),
      itemCount: types.length,
      itemBuilder: (context, index) {
        bool selected = types[index]['selected'] as bool;
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: selected ? Colors.orange : Colors.transparent, width: 1.5),
          ),
          child: Stack(
            children: [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(types[index]['icon'] as IconData, color: types[index]['color'] as Color, size: 30),
                    const SizedBox(height: 8),
                    Text(types[index]['name'] as String, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
              if (selected)
                const Positioned(
                  top: 4,
                  right: 4,
                  child: Icon(Icons.check_circle, color: Colors.orange, size: 16),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInfoForm() {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          _buildFormRow("性别", _buildGenderToggle()),
          _buildFormRow("年龄", const Text("请选择年龄", style: TextStyle(color: Colors.grey)), hasArrow: true),
          _buildFormRow("身高", const Text("请输入身高  cm", style: TextStyle(color: Colors.grey))),
          _buildFormRow("体重", const Text("请输入体重  kg", style: TextStyle(color: Colors.grey))),
          _buildFormRow("身体状况", const Text("请选择身体状况", style: TextStyle(color: Colors.grey)), hasArrow: true),
          _buildFormRow("饮食目标", const Text("请选择饮食目标", style: TextStyle(color: Colors.grey)), hasArrow: true, isLast: true),
        ],
      ),
    );
  }

  Widget _buildFormRow(String label, Widget trailing, {bool hasArrow = false, bool isLast = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        border: isLast ? null : Border(bottom: BorderSide(color: Colors.grey.withOpacity(0.1))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 14, color: Colors.black87)),
          Row(
            children: [
              trailing,
              if (hasArrow) const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGenderToggle() {
    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(color: const Color(0xFFF5F5F5), borderRadius: BorderRadius.circular(8)),
      child: Row(
        children: [
          _buildGenderBtn("男", true),
          _buildGenderBtn("女", false),
        ],
      ),
    );
  }

  Widget _buildGenderBtn(String text, bool active) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      decoration: BoxDecoration(
        color: active ? Colors.orange : Colors.transparent,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(text, style: TextStyle(color: active ? Colors.white : Colors.grey, fontSize: 13)),
    );
  }

  Widget _buildPrivacyNote() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.lock, size: 12, color: Colors.grey),
        const SizedBox(width: 4),
        Text("你的信息仅用于饮食方案定制，我们将严格保密", style: TextStyle(color: Colors.grey.withOpacity(0.8), fontSize: 11)),
      ],
    );
  }

  Widget _buildActionButton() {
    return InkWell( // 将Container改为InkWell以支持点击事件
      onTap: () {
        // 添加导航逻辑
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AiExclusiveView()),
        );
      },
      child: Container(
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [Color(0xFFFFA726), Color(0xFFFF7043)]),
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(color: Colors.orange.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 5)),
          ],
        ),
        child: const Center(
          child: Text("开始生成专属方案",
            style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHotQuestions() {
    return Column(
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(children: [Icon(Icons.whatshot, color: Colors.orange, size: 18), SizedBox(width: 4), Text("热门问题", style: TextStyle(fontWeight: FontWeight.bold))]),
            Row(children: [Text("换一换", style: TextStyle(color: Colors.grey, fontSize: 12)), Icon(Icons.refresh, size: 14, color: Colors.grey)]),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildQuestionChip("减脂期间可以吃米饭吗？"),
            _buildQuestionChip("糖尿病一人食菜谱怎么搭配？"),
            _buildQuestionChip("孕期吃什么对宝宝好？"),
            _buildQuestionChip("高血压饮食要注意什么？"),
            _buildQuestionChip("儿童挑食怎么办？"),
            _buildQuestionChip("痛风患者能吃海鲜吗？"),
          ],
        )
      ],
    );
  }

  Widget _buildQuestionChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.grey.withOpacity(0.1))),
      child: Text(text, style: const TextStyle(fontSize: 12, color: Colors.black87)),
    );
  }
}