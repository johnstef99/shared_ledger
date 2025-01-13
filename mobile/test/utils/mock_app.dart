import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_ledger/app/app.dart';
import 'package:shared_ledger/app/theme.dart';
import 'package:shared_ledger/services/auth_service.dart';
import 'package:shared_ledger/repositories/contacts_repository.dart';
import 'package:shared_ledger/repositories/ledger_repository.dart';
import 'package:shared_ledger/repositories/transactions_repository.dart';
import 'package:shared_ledger/services/contacts_service.dart';

class MockAuthService extends Mock implements AuthService {}

class MockLedgerRepo extends Mock implements LedgerRepository {}

class MockContactsRepo extends Mock implements ContactsRepository {}

class MockTransactionsRepo extends Mock implements TransactionsRepository {}

class MockContactsService extends Mock implements ContactsService {}

class MockThemeModeNotifier extends Mock implements ThemeModeNotifier {
  @override
  ThemeMode get value => ThemeMode.light;
}

final mockAuth = MockAuthService();
final mockLedgerRepo = MockLedgerRepo();
final mockContactsRepo = MockContactsRepo();
final mockTransactionsRepo = MockTransactionsRepo();
final mockContactsService = MockContactsService();
final mockThemeModeNotifier = MockThemeModeNotifier();

void resetAllMocks() {
  reset(mockAuth);
  reset(mockLedgerRepo);
  reset(mockContactsRepo);
  reset(mockTransactionsRepo);
  reset(mockContactsService);
}

extension MockTester on WidgetTester {
  Future<void> pumpMockApp(Widget widget) async {
    await pumpWidget(
      App(
        authService: mockAuth,
        ledgerRepo: mockLedgerRepo,
        contactsRepo: mockContactsRepo,
        contactsService: mockContactsService,
        transactionsRepo: mockTransactionsRepo,
        themeModeNotifier: mockThemeModeNotifier,
        child: widget,
      ),
    );
  }
}
