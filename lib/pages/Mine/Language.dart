import 'package:flutter/material.dart';

class Language extends StatefulWidget {
  const Language({super.key});

  @override
  State<Language> createState() => _LanguageState();
}

class _LanguageState extends State<Language> {
  // 模拟当前选中的语言，默认是图片中的“简体中文”
  String _selectedLanguage = '简体中文';

  // 语言列表数据
  final List<String> _languageList = ['简体字（中国大陆地区）', '正体字（中国）', 'English'];

  @override
  Widget build(BuildContext context) {
    // 提取统一的主题颜色
    const Color themeOrange = Color(0xFFFF8F00); // 呼应原图的橙色开关和图标色
    const Color backgroundColor = Color(0xFFF7F7F7); // 页面背景浅灰色

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black87,
            size: 20,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          '语言设置',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        // 如果需要，可以在这里加上原图右上角的帮助按钮
        actions: [
          IconButton(
            icon: const Icon(
              Icons.help_outline,
              color: Colors.black54,
              size: 22,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 顶部的间距，对应原图列表上方的留白
            const SizedBox(height: 12),

            // 语言列表卡片容器
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12), // 原图的圆角卡片风格
              ),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _languageList.length,
                separatorBuilder: (context, index) => const Divider(
                  height: 1,
                  indent: 16,
                  endIndent: 16,
                  color: Color(0xFFEFEFEF), // 超细轻量分割线
                ),
                itemBuilder: (context, index) {
                  final item = _languageList[index];
                  final isSelected = item == _selectedLanguage;

                  return InkWell(
                    onTap: () {
                      setState(() {
                        _selectedLanguage = item;
                      });
                    },
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(index == 0 ? 12 : 0),
                      topRight: Radius.circular(index == 0 ? 12 : 0),
                      bottomLeft: Radius.circular(
                        index == _languageList.length - 1 ? 12 : 0,
                      ),
                      bottomRight: Radius.circular(
                        index == _languageList.length - 1 ? 12 : 0,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      child: Row(
                        children: [
                          // 语言文本
                          Expanded(
                            child: Text(
                              item,
                              style: TextStyle(
                                fontSize: 15,
                                color: isSelected
                                    ? Colors.black87
                                    : Colors.amber,
                                fontWeight: isSelected
                                    ? FontWeight.w500
                                    : FontWeight.normal,
                              ),
                            ),
                          ),
                          // 选中状态下的右侧对勾
                          if (isSelected)
                            const Icon(
                              Icons.check,
                              color: themeOrange,
                              size: 20,
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
