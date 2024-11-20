import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shared_ledger/app/utils.dart';
import 'package:shared_ledger/models/transaction_model.dart';

class TransactionListTile extends StatelessWidget {
  final Transaction transaction;

  final void Function()? onDelete;
  final void Function()? onEdit;

  const TransactionListTile({
    super.key,
    required this.transaction,
    this.onDelete,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final actions = [
      if (onEdit != null)
        PopupMenuItem(
          onTap: onEdit,
          child: Text(tr('edit')),
        ),
      if (onDelete != null)
        PopupMenuItem(
          onTap: onDelete,
          child: Text(tr('delete')),
        ),
    ];

    return Card(
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        contentPadding:
            EdgeInsets.only(left: 16, right: actions.isEmpty ? 16 : 0),
        key: ValueKey('transaction_${transaction.id}'),
        title: Text(
          transaction.contact?.displayName ?? tr('deleted_contact'),
          style: TextStyle(
            color: transaction.contact == null ? Colors.grey : Colors.black,
          ),
        ),
        subtitle: Text(
          DateFormat('d MMM yyyy HH:mm', context.locale.toLanguageTag()).format(
            transaction.transactionAt.toLocal(),
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              transaction.amount.toCurrency(context.locale),
              style: TextStyle(
                color: switch (transaction.amount) {
                  > 0 => Colors.green,
                  < 0 => Colors.red,
                  _ => Colors.grey,
                },
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            if (actions.isNotEmpty)
              PopupMenuButton(
                  icon: const Icon(Icons.more_vert),
                  itemBuilder: (context) => actions),
          ],
        ),
      ),
    );
  }
}
