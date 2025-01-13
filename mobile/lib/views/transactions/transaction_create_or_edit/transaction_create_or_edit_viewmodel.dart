import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_ledger/models/contact_model.dart';
import 'package:shared_ledger/models/transaction_model.dart';
import 'package:shared_ledger/repositories/transactions_repository.dart';
import 'package:shared_ledger/services/contacts_service.dart';

class TransactionCreateOrEditViewModel {
  final TransactionsRepository _transactionsRepo;
  final GoRouter _router;
  final ContactsService _contactsService;

  final int ledgerId;
  final Transaction? transaction;

  double? amount;

  String? comment;

  ValueNotifier<Contact?> contact = ValueNotifier(null);

  ValueNotifier<bool> isLoading = ValueNotifier(false);

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  ValueNotifier<bool> isIncome = ValueNotifier(true);

  ValueNotifier<DateTime> dateTime = ValueNotifier(DateTime.now());

  TransactionCreateOrEditViewModel({
    required TransactionsRepository transactionsRepo,
    required GoRouter router,
    required ContactsService contactsService,
    required this.ledgerId,
    this.transaction,
  })  : _transactionsRepo = transactionsRepo,
        _contactsService = contactsService,
        _router = router;

  void init() {
    if (transaction != null) {
      amount = transaction!.amount;
      if (amount != null && amount! >= 0) {
        isIncome.value = true;
      } else if (amount != null && amount! < 0) {
        isIncome.value = false;
      }

      comment = transaction!.comment ?? '';
      contact.value = transaction!.contact;
      dateTime.value = transaction!.transactionAt.toLocal();
    }
    _contactsService.contacts.addListener(_onContactsUpdated);
  }

  void dispose() {
    _contactsService.contacts.removeListener(_onContactsUpdated);
    isLoading.dispose();
  }

  void _onContactsUpdated() {
    if (contact.value == null) return;
    contact.value = _contactsService.contacts.value.firstWhereOrNull(
      (c) => c.id == contact.value!.id,
    );
  }

  Future<void> save() async {
    if (!formKey.currentState!.validate()) return;
    formKey.currentState!.save();

    final calcAmount = isIncome.value ? amount : -amount!;

    isLoading.value = true;
    final saveAction = switch (transaction) {
      Transaction t => _transactionsRepo.updateTransaction(
          t.copyWith(
            contact: contact.value!,
            amount: calcAmount!,
            comment: comment,
            transactionAt: dateTime.value,
          ),
        ),
      _ => _transactionsRepo.createTransaction(
          ledgerId: ledgerId,
          contact: contact.value!,
          amount: calcAmount!,
          comment: comment,
          transactionAt: dateTime.value,
        )
    };

    final newTrans =
        await saveAction.whenComplete(() => isLoading.value = false);

    _router.pop(newTrans);
  }

  void onDateTimeSelected(DateTime newDateTime) {
    dateTime.value = newDateTime;
  }
}
