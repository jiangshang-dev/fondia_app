
import 'package:flutter/material.dart';
import 'package:fondia/components/Home/Search.dart';

class TopView extends StatefulWidget {
  const TopView({super.key});

  @override
  State<TopView> createState() => _TopViewState();
}

class _TopViewState extends State<TopView> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '菜谱',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Column(
              children: [
                Text(
                  '让做饭更简单',
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
                SizedBox(width: 8),
                Container(
                  height: 4,
                  width: 60,
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(width: 16),
        Expanded(
          child: GestureDetector(  // 添加 GestureDetector 包裹容器
            onTap: () {
              // 导航到搜索页面
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SearchView()),
              );
            },
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                // color: Colors.grey[100],
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                enabled: false,  // 禁用输入框交互能力
                // 移除原 onTap 回调
                // 搜索框
                decoration: InputDecoration(
                  hintText: '搜索菜谱、食材、菜系',
                  hintStyle: TextStyle(color: Colors.grey[500], fontSize: 16),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.grey[600],
                    size: 24,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
