import 'package:flutter/material.dart';
import 'package:fondia/pages/Ai/AiExclusive.dart';

class AiChatView extends StatefulWidget {
  const AiChatView({super.key, this.initialConsultType});

  /// 从 AI 首页热门需求带入的咨询类型
  final String? initialConsultType;

  @override
  State<AiChatView> createState() => _AiChatViewState();
}

class _AiChatViewState extends State<AiChatView> {
  static const _consultTypes = [
    _ConsultType('减脂餐', Icons.scale, Colors.green),
    _ConsultType('控糖饮食', Icons.water_drop, Colors.blue),
    _ConsultType('高血压饮食', Icons.favorite, Colors.red),
    _ConsultType('高尿酸饮食', Icons.lens_blur, Colors.purple),
    _ConsultType('肠胃养护', Icons.spa, Colors.orange),
    _ConsultType('其他需求', Icons.grid_view, Colors.brown),
  ];

  static const _conditions = ['健康', '糖尿病', '高血压', '高尿酸', '肠胃敏感', '孕期', '哺乳期'];
  static const _goals = ['减重', '维持体重', '增肌', '控糖', '低盐饮食', '均衡营养'];

  int _selectedTypeIndex = 0;
  String _gender = '男';
  int? _age;
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  String? _condition;
  String? _goal;

  @override
  void initState() {
    super.initState();
    if (widget.initialConsultType != null) {
      final idx = _consultTypes.indexWhere((e) => e.name == widget.initialConsultType);
      if (idx >= 0) _selectedTypeIndex = idx;
    }
  }

  @override
  void dispose() {
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  String _buildPrompt() {
    final type = _consultTypes[_selectedTypeIndex].name;
    final buffer = StringBuffer('我想进行「$type」相关的营养咨询，请根据以下信息为我定制饮食方案并推荐 App 内合适的菜谱：\n');
    buffer.writeln('- 性别：$_gender');
    if (_age != null) buffer.writeln('- 年龄：$_age 岁');
    final height = _heightController.text.trim();
    if (height.isNotEmpty) buffer.writeln('- 身高：$height cm');
    final weight = _weightController.text.trim();
    if (weight.isNotEmpty) buffer.writeln('- 体重：$weight kg');
    if (_condition != null) buffer.writeln('- 身体状况：$_condition');
    if (_goal != null) buffer.writeln('- 饮食目标：$_goal');
    buffer.write('\n请给出 3-5 道适合我的菜谱推荐，菜名请用「《菜名》」格式标注，方便我查看详情。');
    return buffer.toString();
  }

  Future<void> _pickAge() async {
    final picked = await showModalBottomSheet<int>(
      context: context,
      builder: (ctx) {
        return SizedBox(
          height: 280,
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(12),
                child: Text('选择年龄', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: 83,
                  itemBuilder: (_, i) {
                    final age = i + 18;
                    return ListTile(
                      title: Text('$age 岁'),
                      onTap: () => Navigator.pop(ctx, age),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
    if (picked != null) setState(() => _age = picked);
  }

  Future<void> _pickOption(String title, List<String> options, String? current, ValueChanged<String> onPick) async {
    final picked = await showModalBottomSheet<String>(
      context: context,
      builder: (ctx) {
        return SizedBox(
          height: 320,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: options.length,
                  itemBuilder: (_, i) {
                    final item = options[i];
                    return ListTile(
                      title: Text(item),
                      trailing: current == item ? const Icon(Icons.check, color: Colors.orange) : null,
                      onTap: () => Navigator.pop(ctx, item),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
    if (picked != null) onPick(picked);
  }

  void _submit() {
    if (_age == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('请选择年龄')));
      return;
    }
    final prompt = _buildPrompt();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AiExclusiveView(
          initialMessage: prompt,
          newSession: true,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'AI营养咨询',
          style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            _buildAIHeader(),
            const SizedBox(height: 24),
            _buildStepTitle('1', '你想咨询什么类型的问题？'),
            const SizedBox(height: 12),
            _buildQuestionTypeGrid(),
            const SizedBox(height: 24),
            _buildStepTitle('2', '告诉我你的基本情况和目标'),
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
                child: Icon(Icons.restaurant_menu, size: 35, color: Colors.orange),
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
                    'Hi，我是你的AI营养师\n告诉我你的身体状况和饮食目标，我将为你定制专属的健康饮食方案',
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
              _buildFeatureIcon(Icons.track_changes, '科学定制'),
              _buildFeatureIcon(Icons.verified_user_outlined, '专业可靠'),
              _buildFeatureIcon(Icons.lock_outline, '隐私安全'),
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
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 0.9,
      ),
      itemCount: _consultTypes.length,
      itemBuilder: (context, index) {
        final type = _consultTypes[index];
        final selected = _selectedTypeIndex == index;
        return GestureDetector(
          onTap: () => setState(() => _selectedTypeIndex = index),
          child: Container(
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
                      Icon(type.icon, color: type.color, size: 30),
                      const SizedBox(height: 8),
                      Text(type.name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
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
          _buildFormRow('性别', _buildGenderToggle()),
          _buildFormRow(
            '年龄',
            GestureDetector(
              onTap: _pickAge,
              child: Text(
                _age == null ? '请选择年龄' : '$_age 岁',
                style: TextStyle(color: _age == null ? Colors.grey : Colors.black87),
              ),
            ),
            hasArrow: true,
          ),
          _buildFormRow(
            '身高',
            SizedBox(
              width: 120,
              child: TextField(
                controller: _heightController,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.right,
                decoration: const InputDecoration(
                  hintText: '请输入 cm',
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                  border: InputBorder.none,
                  isDense: true,
                ),
              ),
            ),
          ),
          _buildFormRow(
            '体重',
            SizedBox(
              width: 120,
              child: TextField(
                controller: _weightController,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.right,
                decoration: const InputDecoration(
                  hintText: '请输入 kg',
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                  border: InputBorder.none,
                  isDense: true,
                ),
              ),
            ),
          ),
          _buildFormRow(
            '身体状况',
            GestureDetector(
              onTap: () => _pickOption('选择身体状况', _conditions, _condition, (v) => setState(() => _condition = v)),
              child: Text(
                _condition ?? '请选择身体状况',
                style: TextStyle(color: _condition == null ? Colors.grey : Colors.black87),
              ),
            ),
            hasArrow: true,
          ),
          _buildFormRow(
            '饮食目标',
            GestureDetector(
              onTap: () => _pickOption('选择饮食目标', _goals, _goal, (v) => setState(() => _goal = v)),
              child: Text(
                _goal ?? '请选择饮食目标',
                style: TextStyle(color: _goal == null ? Colors.grey : Colors.black87),
              ),
            ),
            hasArrow: true,
            isLast: true,
          ),
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
          _buildGenderBtn('男'),
          _buildGenderBtn('女'),
        ],
      ),
    );
  }

  Widget _buildGenderBtn(String text) {
    final active = _gender == text;
    return GestureDetector(
      onTap: () => setState(() => _gender = text),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
        decoration: BoxDecoration(
          color: active ? Colors.orange : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(text, style: TextStyle(color: active ? Colors.white : Colors.grey, fontSize: 13)),
      ),
    );
  }

  Widget _buildPrivacyNote() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.lock, size: 12, color: Colors.grey),
        const SizedBox(width: 4),
        Text('你的信息仅用于饮食方案定制，我们将严格保密', style: TextStyle(color: Colors.grey.withOpacity(0.8), fontSize: 11)),
      ],
    );
  }

  Widget _buildActionButton() {
    return InkWell(
      onTap: _submit,
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
          child: Text(
            '开始生成专属方案',
            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget _buildHotQuestions() {
    const questions = [
      '减脂期间可以吃米饭吗？',
      '糖尿病一人食菜谱怎么搭配？',
      '孕期吃什么对宝宝好？',
      '高血压饮食要注意什么？',
    ];
    return Column(
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(children: [
              Icon(Icons.whatshot, color: Colors.orange, size: 18),
              SizedBox(width: 4),
              Text('热门问题', style: TextStyle(fontWeight: FontWeight.bold)),
            ]),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: questions.map((q) => _buildQuestionChip(q)).toList(),
        ),
      ],
    );
  }

  Widget _buildQuestionChip(String text) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => AiExclusiveView(initialMessage: text, newSession: true),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.withOpacity(0.1)),
        ),
        child: Text(text, style: const TextStyle(fontSize: 12, color: Colors.black87)),
      ),
    );
  }
}

class _ConsultType {
  final String name;
  final IconData icon;
  final Color color;

  const _ConsultType(this.name, this.icon, this.color);
}
