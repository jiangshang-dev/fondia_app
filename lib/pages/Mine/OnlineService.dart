import 'package:flutter/material.dart';
import 'package:fondia/api/support.dart';
import 'package:fondia/l10n/app_localizations.dart';
import 'package:fondia/pages/Mine/HumanService.dart';

class OnlineServiceView extends StatefulWidget {
  const OnlineServiceView({super.key});

  @override
  State<OnlineServiceView> createState() => _OnlineServiceViewState();
}

class _OnlineServiceViewState extends State<OnlineServiceView> {
  bool _loading = true;
  String _welcomeTitle = 'Hi，小厨粉';
  String _welcomeTag = '';
  String _welcomeDesc = '';
  List<Map<String, dynamic>> _faqList = [];
  List<Map<String, dynamic>> _quickEntries = [];
  int _expandedIndex = -1;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final results = await Future.wait([
        SupportApi.getConfig(),
        SupportApi.getFaqList(),
        SupportApi.getQuickEntryList(),
      ]);
      final config = results[0] as Map<String, dynamic>;
      if (!mounted) return;
      final l10n = context.l10n;
      setState(() {
        _welcomeTitle = config['welcomeTitle']?.toString() ?? _welcomeTitle;
        _welcomeTag = config['welcomeTag']?.toString() ?? l10n.welcomeTag;
        _welcomeDesc = config['welcomeDesc']?.toString() ?? l10n.welcomeDesc;
        _faqList = (results[1] as List).map((e) => Map<String, dynamic>.from(e)).toList();
        _quickEntries = (results[2] as List).map((e) => Map<String, dynamic>.from(e)).toList();
        _loading = false;
      });
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  IconData _iconFromKey(String? key) {
    switch (key) {
      case 'wallet':
        return Icons.account_balance_wallet;
      case 'lock_reset':
        return Icons.lock_reset;
      case 'gift':
        return Icons.card_giftcard;
      case 'gavel':
        return Icons.gavel;
      default:
        return Icons.help_outline;
    }
  }

  Color _colorFromHex(String? hex) {
    if (hex == null || hex.isEmpty) return const Color(0xFFFF8A4C);
    try {
      final value = hex.replaceFirst('#', '');
      return Color(int.parse('FF$value', radix: 16));
    } catch (_) {
      return const Color(0xFFFF8A4C);
    }
  }

  void _openChat({String? presetMessage, bool transferToHuman = false, String? source}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HumanServiceView(
          presetMessage: presetMessage,
          transferToHuman: transferToHuman,
          source: source,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18, color: Color(0xFF333333)),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: Text(l10n.onlineService, style: const TextStyle(color: Color(0xFF333333), fontSize: 18, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFFFF6A1A)))
          : Stack(
              children: [
                ListView(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 88),
                  children: [
                    _buildWelcomeBanner(),
                    const SizedBox(height: 16),
                    _buildServiceGrid(),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.only(left: 4, bottom: 12),
                      child: Text(l10n.faqSelfService, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF333333))),
                    ),
                    _buildFaqSection(),
                  ],
                ),
                _buildBottomAction(l10n),
              ],
            ),
    );
  }

  Widget _buildWelcomeBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(colors: [Color(0xFFFF8A4C), Color(0xFFFF6A1A)], begin: Alignment.topLeft, end: Alignment.bottomRight),
        boxShadow: [BoxShadow(color: Color(0xFFFF6A1A).withOpacity(0.15), blurRadius: 10, offset: Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(_welcomeTitle, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(10)),
                child: Text(_welcomeTag, style: const TextStyle(color: Colors.white, fontSize: 10)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(_welcomeDesc, style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 13, height: 1.4)),
        ],
      ),
    );
  }

  Widget _buildServiceGrid() {
    if (_quickEntries.isEmpty) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.01), blurRadius: 10, offset: const Offset(0, 2))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: _quickEntries.map((item) {
          return InkWell(
            onTap: () => _openChat(
              presetMessage: item['presetMessage']?.toString(),
              source: item['title']?.toString(),
            ),
            child: SizedBox(
              width: 70,
              child: Column(
                children: [
                  Icon(_iconFromKey(item['icon']?.toString()), size: 28, color: _colorFromHex(item['iconColor']?.toString())),
                  const SizedBox(height: 8),
                  Text(item['title']?.toString() ?? '', style: const TextStyle(fontSize: 13, color: Color(0xFF333333)), textAlign: TextAlign.center),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

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
        separatorBuilder: (_, __) => const Divider(height: 1, color: Color(0xFFEFEFEF)),
        itemBuilder: (context, index) {
          final isExpanded = _expandedIndex == index;
          return Column(
            children: [
              ListTile(
                title: Text(_faqList[index]['question']?.toString() ?? '', style: const TextStyle(fontSize: 14, color: Color(0xFF333333))),
                trailing: Icon(isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, color: const Color(0xFFCCCCCC), size: 20),
                onTap: () => setState(() => _expandedIndex = isExpanded ? -1 : index),
              ),
              if (isExpanded)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Text(_faqList[index]['answer']?.toString() ?? '', style: const TextStyle(fontSize: 13, color: Color(0xFF666666), height: 1.5)),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBottomAction(AppLocalizations l10n) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        color: Colors.white,
        child: InkWell(
          onTap: () => _openChat(transferToHuman: true),
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFFFF955B), Color(0xFFFF6A1A)]),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [BoxShadow(color: Color(0xFFFF6A1A).withOpacity(0.2), blurRadius: 6, offset: Offset(0, 3))],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.headset_mic, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Text(l10n.summonHuman, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
