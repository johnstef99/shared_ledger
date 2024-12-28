import 'package:easy_localization/easy_localization.dart' as ez;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_ledger/app/app.dart';
import 'package:shared_ledger/views/settings/settings_viewmodel.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  late SettingsViewModel model;

  static String tr(String key) => ez.tr('settings_view.$key');

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    model = SettingsViewModel(authService: context.app.authService);
  }

  @override
  Widget build(BuildContext context) {
    context.locale;
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          title: Text(tr('appbar_title')),
        ),
        SliverList.list(
          children: [
            ListTile(
              title: Text(tr('change_password_btn')),
              onTap: () => context.go('/settings/change-password'),
              trailing: const Icon(Icons.arrow_forward_ios),
            ),
            ListTile(
              title: Text(tr('change_theme_btn')),
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => _ChangeThemeBottomSheet(),
                );
              },
              trailing: const Icon(Icons.arrow_forward_ios),
            ),
            ListTile(
              title: Text(tr('change_language_btn')),
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => _ChangeLanguageBottomSheet(),
                );
              },
              trailing: const Icon(Icons.arrow_forward_ios),
            ),
            ListTile(
              title: Text(tr('delete_account_btn')),
              onTap: () => context.go('/settings/delete-account'),
              trailing: const Icon(Icons.arrow_forward_ios),
            ),
            ListTile(
              title: Text(tr('logout_btn')),
              trailing: ValueListenableBuilder<bool>(
                valueListenable: model.isLoggingOut,
                builder: (context, isLoggingOut, child) {
                  if (isLoggingOut) {
                    return const SizedBox.square(
                      dimension: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    );
                  }
                  return const Icon(Icons.logout);
                },
              ),
              onTap: () => model.logout(),
            ),
          ],
        ),
      ],
    );
  }
}

class _ChangeLanguageBottomSheet extends StatelessWidget {
  const _ChangeLanguageBottomSheet();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 16),
        Text(
          ez.tr('select_language'),
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        ListTile(
          title: Text(ez.tr('locales.en')),
          onTap: () {
            context.setLocale(const Locale('en'));
            Navigator.of(context).pop();
          },
        ),
        ListTile(
          title: Text(ez.tr('locales.el')),
          onTap: () {
            context.setLocale(const Locale('el'));
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}

class _ChangeThemeBottomSheet extends StatelessWidget {
  const _ChangeThemeBottomSheet();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 16),
        Text(
          ez.tr('select_theme'),
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        for (final mode in ThemeMode.values)
          ListTile(
            title: Text(ez.tr('theme_mode.${mode.name}')),
            onTap: () {
              context.app.themeModeNotifier.update((_) => mode);
              Navigator.of(context).pop();
            },
          ),
      ],
    );
  }
}
