import 'package:get_it/get_it.dart';
import 'package:shared_ledger/repositories/contacts_repository.dart';
import 'package:shared_ledger/repositories/ledger_repository.dart';
import 'package:shared_ledger/repositories/transactions_repository.dart';
import 'package:shared_ledger/services/auth_service.dart';
import 'package:shared_ledger/services/contacts_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final locator = GetIt.instance;

void setupLocator() {
  final supabase = Supabase.instance.client;

  final authService = locator.registerSingleton(
    AuthService(supabase: supabase),
    dispose: (service) => service.dispose(),
  );

  locator.registerSingleton(
    LedgerRepository(
      supabase: supabase,
      authService: authService,
    ),
  );

  final contactsRepo = locator.registerSingleton(
    ContactsRepository(
      supabase: supabase,
      authService: authService,
    ),
  );

  locator.registerSingleton(
    ContactsService(
      contactsRepository: contactsRepo,
      authService: authService,
    ),
    dispose: (service) => service.dispose(),
  );

  locator.registerSingleton(
    TransactionsRepository(
      supabase: supabase,
    ),
  );
}
