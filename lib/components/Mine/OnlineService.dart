import 'package:flutter/material.dart';
import 'package:fondia/components/Mine/HumanService.dart';

// 在线客服页面
class OnlineServiceView extends StatefulWidget {
  const OnlineServiceView({super.key});

  @override
  State<OnlineServiceView> createState() => _OnlineServiceViewState();
}

class _OnlineServiceViewState extends State<OnlineServiceView> {
  // 模拟自助常见问题数据
  final List<Map<String, String>> _faqList = [
    {'question': '如何获取更多积分？', 'answer': '您可以通过每日签到、分享优质菜谱、参与社区互动等方式获得丰厚的积分奖励。'},
    {'question': '菜谱上传审核需要多久？', 'answer': '一般情况下，审核团队会在12小时内完成内容合规性审核，请耐心等待。'},
    {'question': '账号绑定手机号如何更换？', 'answer': '前往“设置 > 账号与安全 > 手机号绑定”，验证原手机号后即可输入新号码完成更换。'},
    {'question': '积分商城的商品多久发货？', 'answer': '实物商品将在兑换后3个工作日内发出，虚拟奖品（如会员、优惠券）将实时到账。'},
    {'question': '发现恶意抄袭或违规内容如何举报？', 'answer': '您可以在相关内容详情页点击右上角“...”，选择“举报”，客服会尽快介入处理。'},
  ];

  // 记录当前展开的问题索引
  int _expandedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 沿用系统的浅灰/微蓝白低调背景色
      backgroundColor: const Color(0xFFF7F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18, color: Color(0xFF333333)),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: const Text(
          '在线客服',
          style: TextStyle(color: Color(0xFF333333), fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // 主体滚动内容
          ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 88), // 底部留空给固定按钮
            children: [
              // 1. 顶部温馨欢迎 Banner（像素级致敬大卡片风格）
              _buildWelcomeBanner(),
              const SizedBox(height: 16),

              // 2. 核心自助功能金刚区
              _buildServiceGrid(),
              const SizedBox(height: 20),

              // 3. 常见问题列表标题
              const Padding(
                padding: EdgeInsets.only(left: 4, bottom: 12),
                child: Text(
                  '常见问题自助',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF333333)),
                ),
              ),

              // 4. FAQ 列表容器
              _buildFaqSection(),
            ],
          ),

          // 5. 底部固定“转人工客服”橙色大按钮
          _buildBottomAction(),
        ],
      ),
    );
  }

  // 1. 欢迎横幅（致敬图中的积分卡片渐变与圆角）
  Widget _buildWelcomeBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [Color(0xFFFF8A4C), Color(0xFFFF6A1A)], // 抽取自 image_eb7269.png 的核心橙色
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF6A1A).withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('Hi，小厨粉', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(10)),
                child: const Text('智能自助', style: TextStyle(color: Colors.white, fontSize: 10)),
              )
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '我是小厨专属客服，有什么可以帮您的？您可以通过下方自助服务或点击底部直接与我沟通。',
            style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 13, height: 1.4),
          ),
        ],
      ),
    );
  }

  // 2. 自助功能网络（致敬“我的内容”多图标网格排版）
  Widget _buildServiceGrid() {
    final List<Map<String, dynamic>> services = [
      {'icon': Icons.account_balance_wallet, 'label': '异常处理', 'color': const Color(0xFFFF8A4C)},
      {'icon': Icons.lock_reset, 'label': '账号找回', 'color': const Color(0xFF4C8AFF)},
      {'icon': Icons.card_giftcard, 'label': '兑换咨询', 'color': const Color(0xFFFFB300)},
      {'icon': Icons.gavel, 'label': '社区规范', 'color': const Color(0xFF00BFA5)},
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.01), blurRadius: 10, offset: const Offset(0, 2))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: services.map((item) {
          return InkWell(
            onTap: () {},
            child: SizedBox(
              width: 70,
              child: Column(
                children: [
                  Icon(item['icon'], size: 28, color: item['color']),
                  const SizedBox(height: 8),
                  Text(item['label'], style: const TextStyle(fontSize: 13, color: Color(0xFF333333))),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // 4. FAQ 自助折叠卡片（致敬底部的行项圆角设置风格）
  Widget _buildFaqSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.01), blurRadius: 10, offset: const Offset(0, 2))],
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _faqList.length,
        separatorBuilder: (context, index) => const Divider(height: 1, color: Color(0xFFEFEFEF)),
        itemBuilder: (context, index) {
          final isExpanded = _expandedIndex == index;
          return Column(
            children: [
              ListTile(
                title: Text(
                  _faqList[index]['question']!,
                  style: const TextStyle(fontSize: 14, color: Color(0xFF333333)),
                ),
                trailing: Icon(
                  isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                  color: const Color(0xFFCCCCCC),
                  size: 20,
                ),
                onTap: () {
                  setState(() {
                    _expandedIndex = isExpanded ? -1 : index;
                  });
                },
              ),
              if (isExpanded)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Text(
                    _faqList[index]['answer']!,
                    style: const TextStyle(fontSize: 13, color: Color(0xFF666666), height: 1.5),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  // 5. 底部固定按钮
  Widget _buildBottomAction() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        color: Colors.white,
        child: InkWell(
          onTap: () {
            // 点击进入人工对话页面逻辑
            Navigator.push(context, MaterialPageRoute(builder: (context) => HumanServiceView()));
          },
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFF955B), Color(0xFFFF6A1A)],
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
            child:
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.headset_mic, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Text(
                  '召唤人工客服',
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}