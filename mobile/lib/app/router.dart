import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_ledger/app/app.dart';
import 'package:shared_ledger/main.dart';
import 'package:shared_ledger/models/contact_model.dart';
import 'package:shared_ledger/models/ledger_model.dart';
import 'package:shared_ledger/models/transaction_model.dart';
import 'package:shared_ledger/views/contacts/contact_create_or_edit/contact_create_or_edit_view.dart';
import 'package:shared_ledger/views/contacts/contacts_view.dart';
import 'package:shared_ledger/views/home/home_view.dart';
import 'package:shared_ledger/views/invalid_path/invalid_path_view.dart';
import 'package:shared_ledger/views/ledgers/ledger_create_or_edit/ledger_create_or_edit_view.dart';
import 'package:shared_ledger/views/ledgers/ledger_share/ledger_share_view.dart';
import 'package:shared_ledger/views/ledgers/ledgers_view.dart';
import 'package:shared_ledger/views/login/login_view.dart';
import 'package:shared_ledger/views/settings/change_password_view.dart';
import 'package:shared_ledger/views/settings/delete_account_view.dart';
import 'package:shared_ledger/views/settings/settings_view.dart';
import 'package:shared_ledger/views/transactions/transaction_create_or_edit/transaction_create_or_edit_view.dart';
import 'package:shared_ledger/views/transactions/transactions_view.dart';

GoRouter generateRouter() => GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const SplashPage(),
          redirect: (context, state) async {
            final auth = context.app.authService;
            return auth.user.value.isNotEmpty ? '/ledgers' : '/login';
          },
        ),
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginView(),
        ),
        StatefulShellRoute.indexedStack(
          redirect: (context, state) {
            final auth = context.app.authService;
            if (auth.user.value.isEmpty) {
              return '/login';
            }
            return null;
          },
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
                        final ledgerId = state.pathParameters['ledgerId'];
                        if (ledgerId == null || ledgerId.isEmpty) {
                          return '/ledgers';
                        }
                        return null;
                      },
                      builder: (context, state) {
                        final ledgerId = state.pathParameters['ledgerId']!;
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
                            final ledgerId = state.pathParameters['ledgerId']!;
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
                          path: '/share',
                          builder: (context, state) {
                            final ledgerId = state.pathParameters['ledgerId']!;
                            final ledger = switch (state.extra) {
                              Ledger l => l,
                              _ => null,
                            };
                            return LedgerShareView(
                              ledgerOrId: (ledgerId, ledger),
                            );
                          },
                        ),
                        GoRoute(
                          path: '/transactions/create',
                          builder: (context, state) {
                            final ledgerId = state.pathParameters['ledgerId']!;
                            return TransactionCreateOrEditView(
                              ledgerId: ledgerId,
                            );
                          },
                        ),
                        GoRoute(
                          path: '/transactions/:transactionId/edit',
                          redirect: (context, state) {
                            final ledgerId = state.pathParameters['ledgerId'];

                            final transactionId =
                                state.pathParameters['transactionId'];

                            if (transactionId == null ||
                                transactionId.isEmpty) {
                              return '/ledgers/$ledgerId';
                            }
                            return null;
                          },
                          builder: (context, state) {
                            final ledgerId = state.pathParameters['ledgerId']!;

                            final transaction = state.extra;
                            if (transaction is Transaction) {
                              return TransactionCreateOrEditView(
                                ledgerId: ledgerId,
                                transaction: transaction,
                              );
                            }

                            final transactionId =
                                state.pathParameters['transactionId']!;

                            return Scaffold(
                              body: FutureBuilder(
                                future: context.app.transactionsRepo
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
                        final contactId = state.pathParameters['contactId'];

                        if (contactId == null || contactId.isEmpty) {
                          return '/contacts';
                        }
                        return null;
                      },
                      builder: (context, state) {
                        final contact = state.extra;

                        if (contact is Contact) {
                          return ContactCreateOrEditView(contact: contact);
                        }

                        final contactId = state.pathParameters['contactId']!;

                        return Scaffold(
                          body: FutureBuilder(
                            future:
                                context.app.contactsRepo.getContact(contactId),
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
