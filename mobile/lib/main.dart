import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:shared_ledger/app/app.dart';
import 'package:shared_ledger/app/router.dart';
import 'package:shared_ledger/app/theme.dart';
import 'package:shared_ledger/pocketbase.dart';
import 'package:shared_ledger/repositories/contacts_repository.dart';
import 'package:shared_ledger/repositories/ledger_repository.dart';
import 'package:shared_ledger/repositories/transactions_repository.dart';
import 'package:shared_ledger/services/auth_service.dart';
import 'package:shared_ledger/services/contacts_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import "package:universal_html/html.dart" as html;

final isPwa =
    kIsWeb && html.window.matchMedia('(display-mode: standalone)').matches;
final isWebiOS = kIsWeb &&
    html.window.navigator.userAgent.contains(RegExp(r'iPad|iPod|iPhone'));

late final SharedPreferences prefs;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

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
    final store = AsyncAuthStore(
      save: (String data) async => prefs.setString('pb_auth', data),
      initial: prefs.getString('pb_auth'),
    );

    final pb = PocketBase(
      pocketbaseUrl,
      authStore: store,
    );

    authService = AuthService(pocketbase: pb);
    ledgerRepo = LedgerRepository(
      pocketbase: pb,
      authService: authService,
    );
    contactsRepo = ContactsRepository(
      pocketbase: pb,
      authService: authService,
    );
    contactsService = ContactsService(
      contactsRepository: contactsRepo,
      authService: authService,
    );
    transactionsRepo = TransactionsRepository(
      pocketbase: pb,
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
            return Container(
              padding: EdgeInsets.only(bottom: isPwa && isWebiOS ? 25 : 0),
              color: Theme.of(context).scaffoldBackgroundColor,
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
