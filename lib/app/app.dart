import 'package:flutter/material.dart';
import 'package:shared_ledger/app/theme.dart';
import 'package:shared_ledger/repositories/contacts_repository.dart';
import 'package:shared_ledger/repositories/ledger_repository.dart';
import 'package:shared_ledger/repositories/transactions_repository.dart';
import 'package:shared_ledger/services/auth_service.dart';
import 'package:shared_ledger/services/contacts_service.dart';

class App extends InheritedWidget {
  final AuthService authService;
  final LedgerRepository ledgerRepo;
  final ContactsRepository contactsRepo;
  final ContactsService contactsService;
  final TransactionsRepository transactionsRepo;
  final ThemeModeNotifier themeModeNotifier;

  const App({
    super.key,
    required super.child,
    required this.authService,
    required this.ledgerRepo,
    required this.contactsRepo,
    required this.contactsService,
    required this.transactionsRepo,
    required this.themeModeNotifier,
  });

  static App of(BuildContext context) {
    final app = context.dependOnInheritedWidgetOfExactType<App>();
    if (app == null) {
      throw FlutterError('App not found in context');
    }
    return app;
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    switch (oldWidget) {
      case App() when oldWidget.authService != authService:
      case App() when oldWidget.ledgerRepo != ledgerRepo:
      case App() when oldWidget.contactsRepo != contactsRepo:
      case App() when oldWidget.contactsService != contactsService:
      case App() when oldWidget.transactionsRepo != transactionsRepo:
      case App() when oldWidget.themeModeNotifier != themeModeNotifier:
        return true;
      default:
        return false;
    }
  }
}

extension BuildContextApp on BuildContext {
  App get app => App.of(this);
}
