import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_ledger/app/utils.dart';
import 'package:shared_ledger/models/ledger_model.dart';
import 'package:shared_ledger/models/transaction_list_model.dart';
import 'package:shared_ledger/models/transaction_model.dart';
import 'package:shared_ledger/repositories/ledger_repository.dart';
import 'package:shared_ledger/repositories/transactions_repository.dart';
import 'package:shared_ledger/services/contacts_service.dart';
import 'package:shared_ledger/widgets/select_contact_field_widget.dart';

class TransactionsViewModel {
  final LedgerRepository _ledgerRepo;
  final TransactionsRepository _transactionsRepo;
  final ModelOrId<Ledger> _ledgerOrId;
  final GoRouter _router;
  final ContactsService _contactsService;

  late final Ledger ledger;

  TransactionsViewModel({
    required LedgerRepository ledgerRepo,
    required TransactionsRepository transactionsRepo,
    required GoRouter router,
    required ContactsService contactsService,
    required ModelOrId<Ledger> ledgerOrId,
  })  : _ledgerRepo = ledgerRepo,
        _router = router,
        _contactsService = contactsService,
        _transactionsRepo = transactionsRepo,
        _ledgerOrId = ledgerOrId;

  final ValueNotifier<bool> isLoading = ValueNotifier(true);

  final TransactionsListNotifier transactionsListNotifier =
      TransactionsListNotifier(
    TransactionsListState(
      transactions: [],
      sort: TransactionSort.transactionAtDesc,
    ),
  );

  Future<void> init() async {
    isLoading.value = true;

    ledger = switch (_ledgerOrId.hasModel) {
      true => _ledgerOrId.model!,
      false => await _ledgerRepo.getLedger(_ledgerOrId.id),
    };

    transactionsListNotifier.updateTransactions(await _transactionsRepo
        .getTransactions(ledger.id)
        .whenComplete(() => isLoading.value = false));

    _contactsService.contacts.addListener(_onContactsUpdated);
  }

  void dispose() {
    _contactsService.contacts.removeListener(_onContactsUpdated);
    isLoading.dispose();
    transactionsListNotifier.dispose();
  }

  Future<void> _onContactsUpdated() async {
    isLoading.value = true;
    transactionsListNotifier.updateTransactions(await _transactionsRepo
        .getTransactions(ledger.id)
        .whenComplete(() => isLoading.value = false));
  }

  Future<void> newTransactionTapped() async {
    final transaction =
        await _router.push('/ledgers/${ledger.id}/transactions/create');
    if (transaction is Transaction) {
      final transactions = transactionsListNotifier.transactions;
      transactionsListNotifier
          .updateTransactions([...transactions..insert(0, transaction)]);
    }
  }

  Future<void> deleteTransaction(Transaction transaction) async {
    await _transactionsRepo.deleteTransaction(transaction);
    final transactions = transactionsListNotifier.transactions;
    transactionsListNotifier
        .updateTransactions([...transactions..remove(transaction)]);
  }

  Future<void> editTransaction(Transaction transaction) async {
    final newTrans = await _router.push(
      '/ledgers/${ledger.id}/transactions/${transaction.id}/edit',
      extra: transaction,
    );
    if (newTrans is! Transaction) return;
    final transactions = transactionsListNotifier.transactions;
    final index = transactions.indexWhere((t) => t.id == transaction.id);
    transactionsListNotifier.updateTransactions([
      ...transactions
        ..removeAt(index)
        ..insert(index, newTrans)
    ]);
  }

  Future<void> onRefresh() async {
    transactionsListNotifier.updateTransactions(await _transactionsRepo
        .getTransactions(ledger.id)
        .whenComplete(() => isLoading.value = false));
  }

  Future<void> filterByContactTapped(BuildContext context) async {
    if (transactionsListNotifier.contactFilter != null) {
      transactionsListNotifier.updateContactFilter(null);
      return;
    }

    final contact =
        await showSearch(context: context, delegate: ContactSearchDelegate());
    if (contact == null) return;
    transactionsListNotifier.updateContactFilter(contact);
  }

  Future<void> sortByTapped(BuildContext context) async {
    final box = context.findRenderObject() as RenderBox;
    final offset = box.localToGlobal(Offset.zero);
    final pos = RelativeRect.fromLTRB(
      offset.dx,
      offset.dy,
      MediaQuery.of(context).size.width - offset.dx,
      MediaQuery.of(context).size.height - offset.dy,
    );

    final action = await showMenu(
      initialValue: transactionsListNotifier.sort,
      context: context,
      position: pos,
      items: [
        PopupMenuItem(
          value: TransactionSort.transactionAtAsc,
          child: Text(tr('transactions_view.sort_by.transaction_at_asc')),
        ),
        PopupMenuItem(
          value: TransactionSort.transactionAtDesc,
          child: Text(tr('transactions_view.sort_by.transaction_at_desc')),
        ),
        PopupMenuItem(
          value: TransactionSort.createdAtAsc,
          child: Text(tr('transactions_view.sort_by.created_at_asc')),
        ),
        PopupMenuItem(
          value: TransactionSort.createdAtDesc,
          child: Text(tr('transactions_view.sort_by.created_at_desc')),
        ),
      ],
    );
    if (action == null) return;
    transactionsListNotifier.updateSort(action);
  }

  void shareLedger() {
    _router.go('/ledgers/${ledger.id}/share', extra: ledger);
  }
}
