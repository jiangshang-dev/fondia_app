import 'package:flutter/material.dart';
import 'package:fondia/l10n/app_localizations.dart';
import 'package:fondia/stores/LocaleManager.dart';

class Language extends StatefulWidget {
  const Language({super.key});

  @override
  State<Language> createState() => _LanguageState();
}

class _LanguageState extends State<Language> {
  late String _selectedCode;

  @override
  void initState() {
    super.initState();
    _selectedCode = localeManager.localeCode;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    const Color themeOrange = Color(0xFFFF8F00);
    const Color backgroundColor = Color(0xFFF7F7F7);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          l10n.languageSettings,
          style: const TextStyle(color: Colors.black87, fontSize: 18, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline, color: Colors.black54, size: 22),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: LocaleManager.languageOptions.length,
                separatorBuilder: (_, __) => const Divider(
                  height: 1,
                  indent: 16,
                  endIndent: 16,
                  color: Color(0xFFEFEFEF),
                ),
                itemBuilder: (context, index) {
                  final option = LocaleManager.languageOptions[index];
                  final code = option.$1;
                  final label = option.$2;
                  final isSelected = code == _selectedCode;

                  return InkWell(
                    onTap: () async {
                      setState(() => _selectedCode = code);
                      await localeManager.setLocaleCode(code);
                    },
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(index == 0 ? 12 : 0),
                      topRight: Radius.circular(index == 0 ? 12 : 0),
                      bottomLeft: Radius.circular(index == LocaleManager.languageOptions.length - 1 ? 12 : 0),
                      bottomRight: Radius.circular(index == LocaleManager.languageOptions.length - 1 ? 12 : 0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              label,
                              style: TextStyle(
                                fontSize: 15,
                                color: isSelected ? Colors.black87 : Colors.black54,
                                fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
                              ),
                            ),
                          ),
                          if (isSelected)
                            const Icon(Icons.check, color: themeOrange, size: 20),
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
