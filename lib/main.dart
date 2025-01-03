import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_ledger/app/app.dart';
import 'package:shared_ledger/app/router.dart';
import 'package:shared_ledger/app/theme.dart';
import 'package:shared_ledger/repositories/contacts_repository.dart';
import 'package:shared_ledger/repositories/ledger_repository.dart';
import 'package:shared_ledger/repositories/transactions_repository.dart';
import 'package:shared_ledger/services/auth_service.dart';
import 'package:shared_ledger/services/contacts_service.dart';
import 'package:shared_ledger/supabase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import "package:universal_html/html.dart" as html;

final isPwa =
    kIsWeb && html.window.matchMedia('(display-mode: standalone)').matches;
final isWebiOS = kIsWeb &&
    html.window.navigator.userAgent.contains(RegExp(r'iPad|iPod|iPhone'));

late final SharedPreferences prefs;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseAnonKey,
  );

  await EasyLocalization.ensureInitialized();

  prefs = await SharedPreferences.getInstance();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({
    super.key,
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final AuthService authService;
  late final LedgerRepository ledgerRepo;
  late final ContactsRepository contactsRepo;
  late final ContactsService contactsService;
  late final TransactionsRepository transactionsRepo;
  late final ThemeModeNotifier themeModeNotifier;

  @override
  void initState() {
    super.initState();
    final supabase = Supabase.instance.client;
    authService = AuthService(supabase: Supabase.instance.client);
    ledgerRepo = LedgerRepository(
      supabase: supabase,
      authService: authService,
    );
    contactsRepo = ContactsRepository(
      supabase: supabase,
      authService: authService,
    );
    contactsService = ContactsService(
      contactsRepository: contactsRepo,
      authService: authService,
    );
    transactionsRepo = TransactionsRepository(
      supabase: supabase,
    );
    themeModeNotifier = ThemeModeNotifier(
      prefs: prefs,
    );
  }

  @override
  Widget build(BuildContext context) {
    return App(
      authService: authService,
      ledgerRepo: ledgerRepo,
      contactsRepo: contactsRepo,
      contactsService: contactsService,
      transactionsRepo: transactionsRepo,
      themeModeNotifier: themeModeNotifier,
      child: MyRootWidget(),
    );
  }
}

class MyRootWidget extends StatefulWidget {
  const MyRootWidget({
    super.key,
    this.router,
  });

  final GoRouter? router;

  @override
  State<MyRootWidget> createState() => _MyRootWidgetState();
}

class _MyRootWidgetState extends State<MyRootWidget> {
  late final GoRouter router;

  @override
  void initState() {
    super.initState();
    router = widget.router ?? generateRouter();
  }

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
      child: ValueListenableBuilder(
        valueListenable: context.app.themeModeNotifier,
        builder: (context, themeMode, child) => MaterialApp.router(
          title: 'Shared Ledger',
          routerConfig: router,
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          builder: (context, child) {
            return Padding(
              padding: EdgeInsets.only(bottom: isPwa && isWebiOS ? 25 : 0),
              child: child!,
            );
          },
          themeMode: themeMode,
          theme: lightTheme,
          darkTheme: darkTheme,
        ),
      ),
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
