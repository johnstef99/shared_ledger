import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:shared_ledger/models/contact_model.dart';
import 'package:shared_ledger/models/transaction_model.dart';

enum TransactionSort {
  transactionAtAsc,
  transactionAtDesc,
  createdAtAsc,
  createdAtDesc,
}

class TransactionsListState {
  final List<Transaction> transactions;
  final TransactionSort sort;
  final Contact? contactFilter;

  List<Transaction> get filteredTransactions => switch (contactFilter) {
        null => transactions,
        _ => transactions.where((t) => t.contact == contactFilter).toList(),
      };

  const TransactionsListState({
    required this.transactions,
    required this.sort,
    this.contactFilter,
  });
}

class TransactionsListNotifier extends ValueNotifier<TransactionsListState> {
  TransactionsListNotifier(super.state);

  List<Transaction> get transactions => value.transactions;

  TransactionSort get sort => value.sort;

  Contact? get contactFilter => value.contactFilter;

  void updateTransactions(List<Transaction> transactions) {
    value = TransactionsListState(
      transactions: transactions.sorted(value.sort),
      sort: value.sort,
    );
  }

  void updateSort(TransactionSort sort) {
    if (sort == value.sort) return;

    value = TransactionsListState(
      transactions: value.transactions.sorted(sort),
      sort: sort,
    );
  }

  void updateContactFilter(Contact? contact) {
    value = TransactionsListState(
      transactions: value.transactions,
      sort: value.sort,
      contactFilter: contact,
    );
  }
}

extension on List<Transaction> {
  List<Transaction> sorted(TransactionSort sort) {
    return switch (sort) {
      TransactionSort.transactionAtAsc => sortedBy((t) => t.transactionAt),
      TransactionSort.transactionAtDesc =>
        sortedBy((t) => t.transactionAt).reversed.toList(),
      TransactionSort.createdAtAsc => sortedBy((t) => t.createdAt),
      TransactionSort.createdAtDesc =>
        sortedBy((t) => t.createdAt).reversed.toList(),
    };
  }
}
