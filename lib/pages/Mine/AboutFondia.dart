import 'package:flutter/material.dart';
import 'package:fondia/components/common/FondiaAppBar.dart';
import 'package:fondia/constants/AppTheme.dart';
import 'package:fondia/constants/LegalContent.dart';
import 'package:fondia/l10n/app_localizations.dart';
import 'package:fondia/pages/Mine/LegalDocument.dart';

/// 关于饭典
class AboutFondiaView extends StatelessWidget {
  const AboutFondiaView({super.key});

  static const appVersion = '1.0.0';

  void _openLegal(BuildContext context, LegalDocType type) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => LegalDocumentView(docType: type)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: AppColors.backgroundCream,
      appBar: FondiaAppBar(
        title: l10n.aboutFondia,
        backgroundColor: AppColors.backgroundCream,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(height: 40),
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                'images/logo.png',
                width: 72,
                height: 72,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.restaurant_menu, color: AppColors.primary, size: 36),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.appName,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'v$appVersion',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                l10n.aboutFondiaTagline,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14, height: 1.5, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 32),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  ListTile(
                    title: Text(l10n.userAgreement),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 12, color: Colors.grey),
                    onTap: () => _openLegal(context, LegalDocType.user),
                  ),
                  const Divider(height: 1, indent: 16),
                  ListTile(
                    title: Text(l10n.privacyPolicy),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 12, color: Colors.grey),
                    onTap: () => _openLegal(context, LegalDocType.privacy),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              '© 2026 Fondia',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
