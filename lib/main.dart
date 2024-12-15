import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_ledger/app/locator.dart';
import 'package:shared_ledger/models/contact_model.dart';
import 'package:shared_ledger/models/ledger_model.dart';
import 'package:shared_ledger/models/transaction_model.dart';
import 'package:shared_ledger/repositories/transactions_repository.dart';
import 'package:shared_ledger/services/contacts_service.dart';
import 'package:shared_ledger/views/contacts/contacts_view.dart';
import 'package:shared_ledger/views/contacts/contact_create_or_edit/contact_create_or_edit_view.dart';
import 'package:shared_ledger/views/invalid_path/invalid_path_view.dart';
import 'package:shared_ledger/views/ledgers/ledger_create_or_edit/ledger_create_or_edit_view.dart';
import 'package:shared_ledger/views/ledgers/ledgers_view.dart';
import 'package:shared_ledger/views/home/home_view.dart';
import 'package:shared_ledger/views/login/login_view.dart';
import 'package:shared_ledger/services/auth_service.dart';
import 'package:shared_ledger/supabase.dart';
import 'package:shared_ledger/views/settings/change_password_view.dart';
import 'package:shared_ledger/views/settings/delete_account_view.dart';
import 'package:shared_ledger/views/settings/settings_view.dart';
import 'package:shared_ledger/views/transactions/transactions_view.dart';
import 'package:shared_ledger/views/transactions/transaction_create_or_edit/transaction_create_or_edit_view.dart';
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

GoRouter getDefaultRouter() => GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const SplashPage(),
          redirect: (context, state) async {
            final auth = locator<AuthService>();
            return auth.user.value.isNotEmpty ? '/ledgers' : '/login';
          },
        ),
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginView(),
        ),
        StatefulShellRoute.indexedStack(
          builder: (context, state, child) => HomeView(child: child),
          branches: [
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/ledgers',
                  builder: (context, state) => const LedgersView(),
                  routes: [
                    GoRoute(
                      path: '/create',
                      builder: (context, state) =>
                          const LedgerCreateOrEditView(),
                    ),
                    GoRoute(
                      path: '/:ledgerId',
                      redirect: (context, state) {
                        final ledgerId =
                            int.tryParse(state.pathParameters['ledgerId']!);
                        if (ledgerId == null) {
                          return '/ledgers';
                        }
                        return null;
                      },
                      builder: (context, state) {
                        final ledgerId =
                            int.parse(state.pathParameters['ledgerId']!);
                        final model = switch (state.extra) {
                          Ledger l => l,
                          _ => null,
                        };
                        return TransactionsView(ledger: (ledgerId, model));
                      },
                      routes: [
                        GoRoute(
                          path: '/edit',
                          builder: (context, state) {
                            final ledgerId =
                                int.parse(state.pathParameters['ledgerId']!);
                            final ledger = switch (state.extra) {
                              Ledger l => l,
                              _ => null,
                            };
                            return LedgerCreateOrEditView(
                              ledgerOrId: (ledgerId, ledger),
                            );
                          },
                        ),
                        GoRoute(
                          path: '/transactions/create',
                          builder: (context, state) {
                            final ledgerId =
                                int.parse(state.pathParameters['ledgerId']!);
                            return TransactionCreateOrEditView(
                              ledgerId: ledgerId,
                            );
                          },
                        ),
                        GoRoute(
                          path: '/transactions/:transactionId/edit',
                          redirect: (context, state) {
                            final ledgerId =
                                int.parse(state.pathParameters['ledgerId']!);
                            final transactionId = int.tryParse(
                              state.pathParameters['transactionId']!,
                            );
                            if (transactionId == null) {
                              return '/ledgers/$ledgerId';
                            }
                            return null;
                          },
                          builder: (context, state) {
                            final ledgerId =
                                int.parse(state.pathParameters['ledgerId']!);

                            final transaction = state.extra;
                            if (transaction is Transaction) {
                              return TransactionCreateOrEditView(
                                ledgerId: ledgerId,
                                transaction: transaction,
                              );
                            }

                            final transactionId = int.parse(
                              state.pathParameters['transactionId']!,
                            );

                            return Scaffold(
                              body: FutureBuilder(
                                future: locator<TransactionsRepository>()
                                    .getTransaction(transactionId),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }

                                  if (snapshot.hasError) {
                                    return Center(
                                      child: Text(
                                        'Something went wrong',
                                      ),
                                    );
                                  }

                                  final transaction =
                                      snapshot.data as Transaction;

                                  if (transaction.ledgerId != ledgerId) {
                                    return const InvalidPathView();
                                  }

                                  return TransactionCreateOrEditView(
                                    ledgerId: ledgerId,
                                    transaction: transaction,
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/contacts',
                  builder: (context, state) => const ContactsView(),
                  routes: [
                    GoRoute(
                      path: '/create',
                      builder: (context, state) =>
                          const ContactCreateOrEditView(),
                    ),
                    GoRoute(
                      path: '/:contactId/edit',
                      redirect: (context, state) {
                        final contactId = int.tryParse(
                          state.pathParameters['contactId']!,
                        );
                        if (contactId == null) {
                          return '/contacts';
                        }
                        return null;
                      },
                      builder: (context, state) {
                        final contact = state.extra;

                        if (contact is Contact) {
                          return ContactCreateOrEditView(contact: contact);
                        }

                        final contactId = int.parse(
                          state.pathParameters['contactId']!,
                        );

                        return Scaffold(
                          body: FutureBuilder(
                            future: locator<ContactsService>()
                                .getContact(contactId),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }

                              if (snapshot.hasError) {
                                return Center(
                                  child: Text(
                                    'Something went wrong',
                                  ),
                                );
                              }

                              final contact = snapshot.data as Contact;

                              return ContactCreateOrEditView(contact: contact);
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/settings',
                  builder: (context, state) => const SettingsView(),
                  routes: [
                    GoRoute(
                      path: '/change-password',
                      builder: (context, state) => const ChangePasswordView(),
                    ),
                    GoRoute(
                      path: '/delete-account',
                      builder: (context, state) => const DeleteAccountView(),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ],
    );

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
