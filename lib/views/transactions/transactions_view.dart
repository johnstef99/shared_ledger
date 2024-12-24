import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_ledger/app/locator.dart';
import 'package:shared_ledger/app/utils.dart';
import 'package:shared_ledger/models/ledger_model.dart';
import 'package:shared_ledger/repositories/ledger_repository.dart';
import 'package:shared_ledger/repositories/transactions_repository.dart';
import 'package:shared_ledger/services/contacts_service.dart';
import 'package:shared_ledger/views/transactions/transactions_viewmodel.dart';
import 'package:shared_ledger/widgets/transaction_list_tile_widget.dart';
import 'package:shared_ledger/widgets/view_model_provider_widget.dart';

class TransactionsView extends StatefulWidget {
  const TransactionsView({
    super.key,
    required this.ledger,
  });

  final ModelOrId<Ledger> ledger;

  @override
  State<TransactionsView> createState() => _TransactionsViewState();
}

class _TransactionsViewState extends State<TransactionsView> {
  late final TransactionsViewModel model;

  @override
  void initState() {
    super.initState();
    model = TransactionsViewModel(
      ledgerRepo: locator<LedgerRepository>(),
      transactionsRepo: locator<TransactionsRepository>(),
      ledgerOrId: widget.ledger,
      router: GoRouter.of(context),
      contactsService: locator<ContactsService>(),
    );
    model.init();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ViewModelProvider(
        viewModel: model,
        child: ValueListenableBuilder(
          valueListenable: model.isLoading,
          builder: (context, isLoading, child) => Scaffold(
            floatingActionButton: isLoading || model.ledger.isShared
                ? null
                : FloatingActionButton(
                    heroTag: 'add_transaction_button',
                    onPressed: model.newTransactionTapped,
                    child: const Icon(Icons.add),
                  ),
            body: isLoading
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: model.onRefresh,
                    child: CustomScrollView(
                      slivers: [
                        SliverAppBar(
                          title: Text(model.ledger.name),
                          actions: [
                            if (!model.ledger.isShared)
                              ValueListenableBuilder(
                                valueListenable: model.transactionsListNotifier,
                                builder: (context, transactionsList, child) =>
                                    IconButton(
                                  onPressed: () =>
                                      model.filterByContactTapped(context),
                                  icon: Icon(
                                    transactionsList.contactFilter == null
                                        ? Icons.person_outlined
                                        : Icons.person_remove_outlined,
                                  ),
                                ),
                              ),
                            Builder(builder: (context) {
                              return IconButton(
                                icon: const Icon(Icons.sort_outlined),
                                onPressed: () => model.sortByTapped(context),
                              );
                            }),
                          ],
                          expandedHeight: 150,
                          flexibleSpace: const FlexibleSpaceBar(
                            background: Align(
                              alignment: Alignment.bottomCenter,
                              child: _TotalAmount(),
                            ),
                          ),
                        ),
                        _List(),
                        SliverPadding(padding: EdgeInsets.only(bottom: 100)),
                      ],
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

class _List extends StatelessWidget {
  const _List();

  @override
  Widget build(BuildContext context) {
    final model = ViewModelProvider.of<TransactionsViewModel>(context);
    return ValueListenableBuilder(
      valueListenable: model.transactionsListNotifier,
      builder: (context, transactionsList, child) {
        final transactions = transactionsList.filteredTransactions;
        if (transactions.isEmpty) {
          return SliverFillRemaining(
            child: Center(
              child: Text(tr('transactions_view.no_transactions_msg')),
            ),
          );
        }
        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final transaction = transactions[index];
              return TransactionListTile(
                transaction: transaction,
                onDelete: model.ledger.isShared
                    ? null
                    : () => model.deleteTransaction(transaction),
                onEdit: model.ledger.isShared
                    ? null
                    : () => model.editTransaction(transaction),
              );
            },
            childCount: transactions.length,
          ),
        );
      },
    );
  }
}

class _TotalAmount extends StatelessWidget {
  const _TotalAmount();

  @override
  Widget build(BuildContext context) {
    final model = ViewModelProvider.of<TransactionsViewModel>(context);

    return ValueListenableBuilder(
      valueListenable: model.transactionsListNotifier,
      builder: (context, transactionsList, child) {
        final transactions = transactionsList.filteredTransactions;
        final totalIncomes = transactions
            .where((transaction) => transaction.amount > 0)
            .fold<double>(
              0,
              (prev, transaction) => prev + transaction.amount,
            );
        final totalExpenses = transactions
            .where((transaction) => transaction.amount < 0)
            .fold<double>(
              0,
              (prev, transaction) => prev + transaction.amount,
            );
        final total = totalIncomes + totalExpenses;
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: {
              tr('payments'): totalIncomes,
              tr('charges'): totalExpenses,
              total > 0 ? tr('surplus') : tr('balance'): total,
            }
                .entries
                .map(
                  (i) => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        i.key,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Flexible(
                        child: Text(
                          i.value.abs().toCurrency(context.locale),
                          style: TextStyle(
                            color: switch (i.value) {
                              > 0 => Colors.green,
                              < 0 => Colors.red,
                              _ => Colors.grey,
                            },
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
                .toList(),
          ),
        );
      },
    );
  }
}
