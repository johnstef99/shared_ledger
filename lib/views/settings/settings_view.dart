import 'package:easy_localization/easy_localization.dart' as ez;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_ledger/app/locator.dart';
import 'package:shared_ledger/services/auth_service.dart';
import 'package:shared_ledger/views/settings/settings_viewmodel.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  late final SettingsViewModel model;

  static String tr(String key) => ez.tr('settings_view.$key');

  @override
  void initState() {
    model = SettingsViewModel(authService: locator<AuthService>());
    super.initState();
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
