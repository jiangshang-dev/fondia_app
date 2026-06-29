import 'package:flutter/material.dart';
import 'package:fondia/pages/CategoryDetail/DishDetail.dart';

class CategoryView extends StatefulWidget {
  const CategoryView({super.key});

  @override
  State<CategoryView> createState() => _CategoryViewState();
}

class _CategoryViewState extends State<CategoryView> {
  int _selectedCategoryIndex = 0;

  final List<Map<String, dynamic>> _leftCategories = [
    {'name': '地方菜系', 'selected': true},
    {'name': '川菜', 'selected': false},
    {'name': '粤菜', 'selected': false},
    {'name': '鲁菜', 'selected': false},
    {'name': '苏菜', 'selected': false},
    {'name': '浙菜', 'selected': false},
    {'name': '闽菜', 'selected': false},
    {'name': '湘菜', 'selected': false},
    {'name': '徽菜', 'selected': false},
    {'name': '京菜', 'selected': false},
    {'name': '东北菜', 'selected': false},
  ];

  final List<Map<String, dynamic>> _rightContent = [
    {
      'title': '主食',
      'items': [
        {
          'name': '米饭',
          'image':
              '',
        },
        {
          'name': '面食',
          'image':
              '',
        },
        {
          'name': '面条',
          'image':
              '',
        },
        {
          'name': '粥',
          'image':
              '',
        },
        {
          'name': '饺子',
          'image':
              '',
        },
        {
          'name': '包子',
          'image':
              '',
        },
        {
          'name': '炒饭',
          'image':
              '',
        },
        {
          'name': '饼',
          'image':
              '',
        },
      ],
    },
    {
      'title': '菜',
      'items': [
        {
          'name': '家常菜',
          'image':
              '',
        },
        {
          'name': '凉菜',
          'image':
              '',
        },
        {
          'name': '汤羹',
          'image':
              '',
        },
        {
          'name': '红烧',
          'image':
              '',
        },
        {
          'name': '炒菜',
          'image':
              '',
        },
        {
          'name': '蒸菜',
          'image':
              '',
        },
        {
          'name': '炖菜',
          'image':
              '',
        },
        {
          'name': '火锅',
          'image':
              '',
        },
        {
          'name': '烧烤',
          'image':
              '',
        },
        {
          'name': '煎炸',
          'image':
              '',
        },
        {
          'name': '腌制',
          'image':
              '',
        },
        {
          'name': '素菜',
          'image':
              '',
        },
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Container(
                  width: 100,
                  color: Colors.grey[50],
                  child: ListView.builder(
                    itemCount: _leftCategories.length,
                    itemBuilder: (context, index) {
                      final category = _leftCategories[index];
                      final isSelected = index == _selectedCategoryIndex;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedCategoryIndex = index;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 12,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.white : Colors.transparent,
                            border: isSelected ? Border(left: BorderSide(color: Colors.orange, width: 4)) : null,
                          ),
                          child: Text(
                            category['name'],
                            style: TextStyle(
                              color: isSelected ? Colors.black : Colors.grey[600],
                              fontSize: 15,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.all(16),
                    itemCount: _rightContent.length,
                    itemBuilder: (context, index) {
                      final section = _rightContent[index];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                section['title'],
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '更多',
                                style: TextStyle(
                                  color: Colors.grey[500],
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          GridView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 4,
                                    mainAxisExtent: 100, // 固定高度为100（图片60 + 间距8 + 文字高度约20 + 缓冲）
                                    crossAxisSpacing: 12,
                                    mainAxisSpacing: 12
                                ),
                            itemCount: section['items'].length,
                            itemBuilder: (context, itemIndex) {
                              final item = section['items'][itemIndex];
                              return GestureDetector(
                                onTap: () {
                                  // 执行跳转并传参
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const DishDetail(
                                        // 这里传递参数，例如菜品名称
                                        // dishName: item['name'],
                                      ),
                                    ),
                                  );
                                },
                                child: Column(
                                  children: [
                                    Container(
                                      width: 60,
                                      height: 60,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        image: DecorationImage(
                                          image: NetworkImage(item['image']),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      item['name'],
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          SizedBox(height: 24),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
