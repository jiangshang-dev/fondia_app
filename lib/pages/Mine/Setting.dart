import 'package:flutter/material.dart';
import 'package:fondia/components/common/FondiaAppBar.dart';
import 'package:fondia/components/common/SettingsGroupCard.dart';
import 'package:fondia/components/common/SettingsListTile.dart';
import 'package:fondia/components/common/SettingsSectionTitle.dart';
import 'package:fondia/components/common/SettingsSwitchTile.dart';
import 'package:fondia/constants/AppTheme.dart';
import 'package:fondia/l10n/app_localizations.dart';
import 'package:fondia/pages/Login/index.dart';
import 'package:fondia/pages/Mine/DeleteAccount.dart';
import 'package:fondia/pages/Mine/Language.dart';
import 'package:fondia/stores/LocaleManager.dart';
import 'package:fondia/stores/TokenManager.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    localeManager.addListener(_onLocaleChanged);
  }

  @override
  void dispose() {
    localeManager.removeListener(_onLocaleChanged);
    super.dispose();
  }

  void _onLocaleChanged() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      backgroundColor: AppColors.backgroundCream,
      appBar: FondiaAppBar(
        title: l10n.settings,
        backgroundColor: AppColors.backgroundCream,
        actions: [
          TextButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.help_outline, color: AppColors.textSecondary, size: 18),
            label: Text(l10n.help, style: const TextStyle(color: AppColors.textSecondary, fontSize: 14)),
          ),
        ],
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          SettingsSectionTitle(title: l10n.accountSecurity),
          SettingsGroupCard(children: [
            SettingsListTile(icon: Icons.lock_open_outlined, title: l10n.changePassword),
            SettingsListTile(
              icon: Icons.person_remove_outlined,
              title: l10n.deleteAccount,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DeleteAccountView())),
            ),
          ]),

          SettingsSectionTitle(title: l10n.generalSettings),
          SettingsGroupCard(children: [
            SettingsListTile(
              icon: Icons.language_outlined,
              title: l10n.languageSettings,
              trailingText: localeManager.currentLanguageLabel,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const Language())),
            ),
            SettingsSwitchTile(
              icon: Icons.dark_mode_outlined,
              title: l10n.darkMode,
              value: _isDarkMode,
              onChanged: (v) => setState(() => _isDarkMode = v),
            ),
            SettingsListTile(icon: Icons.font_download_outlined, title: l10n.fontSize, trailingText: l10n.medium),
            SettingsListTile(icon: Icons.delete_outline, title: l10n.clearCache, trailingText: '256MB'),
            SettingsListTile(icon: Icons.file_download_outlined, title: l10n.downloadManagement),
          ]),

          SettingsSectionTitle(title: l10n.messageNotification),
          const SettingsGroupCard(children: []),

          SettingsSectionTitle(title: l10n.kitchenPreferences),
          SettingsGroupCard(children: [
            SettingsListTile(icon: Icons.notifications_active_outlined, title: l10n.smartRecommend),
            SettingsListTile(icon: Icons.restaurant_menu_outlined, title: l10n.dietaryRestrictions),
            SettingsListTile(icon: Icons.assignment_outlined, title: l10n.dietGoal, trailingText: l10n.healthyDiet),
            SettingsListTile(icon: Icons.warning_amber_outlined, title: l10n.allergyReminder),
            SettingsListTile(icon: Icons.layers_outlined, title: l10n.recipeDifficulty, trailingText: l10n.difficultyMedium),
            SettingsListTile(icon: Icons.access_time, title: l10n.dailyRecommendTime, trailingText: l10n.morning7),
          ]),

          SettingsSectionTitle(title: l10n.aboutUs),
          SettingsGroupCard(children: [
            SettingsListTile(icon: Icons.description_outlined, title: l10n.userAgreement),
            SettingsListTile(icon: Icons.privacy_tip_outlined, title: l10n.privacyPolicy),
            SettingsListTile(icon: Icons.info_outline, title: l10n.aboutFondia),
            SettingsListTile(icon: Icons.star_border_outlined, title: l10n.rateUs),
          ]),

          const SizedBox(height: 24),
          TextButton.icon(
            onPressed: () async {
              await tokenManager.removeToken();
              if (!context.mounted) return;
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginPage()),
                (route) => false,
              );
            },
            icon: const Icon(Icons.exit_to_app, color: Colors.redAccent),
            label: Text(l10n.logout, style: const TextStyle(color: Colors.redAccent, fontSize: 16)),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
