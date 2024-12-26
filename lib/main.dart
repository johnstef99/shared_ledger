import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_ledger/app/locator.dart';
import 'package:shared_ledger/app/router.dart';
import 'package:shared_ledger/supabase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import "package:universal_html/html.dart" as html;

final isPwa =
    kIsWeb && html.window.matchMedia('(display-mode: standalone)').matches;
final isWebiOS = kIsWeb &&
    html.window.navigator.userAgent.contains(RegExp(r'iPad|iPod|iPhone'));

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseAnonKey,
  );

  await EasyLocalization.ensureInitialized();

  setupLocator();

  runApp(const MyApp());
}

final _router = getDefaultRouter();

class MyApp extends StatelessWidget {
  const MyApp({super.key, this.router});

  final GoRouter? router;

  @override
  Widget build(BuildContext context) {
    return EasyLocalization(
      path: 'assets/translations',
      supportedLocales: const [
        Locale('en'),
        Locale('el'),
      ],
      useOnlyLangCode: true,
      fallbackLocale: const Locale('en'),
      useFallbackTranslations: true,
      child: Builder(builder: (context) {
        return MaterialApp.router(
          title: 'Shared Ledger',
          routerConfig: router ?? _router,
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          builder: (context, child) {
            return Padding(
              padding: EdgeInsets.only(bottom: isPwa && isWebiOS ? 25 : 0),
              child: child!,
            );
          },
          theme: ThemeData(
            colorScheme: const ColorScheme.light(
              primary: Colors.black,
            ),
            useMaterial3: true,
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                elevation: 2,
                fixedSize: const Size(double.infinity, 48),
                maximumSize: const Size(350, 48),
              ),
            ),
          ),
        );
      }),
    );
  }
}

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
