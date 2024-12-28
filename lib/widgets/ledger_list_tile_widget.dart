import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shared_ledger/models/ledger_model.dart';

class LedgerListTile extends StatelessWidget {
  final Ledger ledger;

  final Animation<double> animation;

  final void Function()? onDelete;
  final void Function()? onEdit;
  final void Function()? onTap;
  final void Function()? onShare;

  const LedgerListTile({
    super.key,
    required this.ledger,
    required this.animation,
    this.onDelete,
    this.onEdit,
    this.onTap,
    this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    final actions = <PopupMenuEntry>[
      if (onEdit != null)
        PopupMenuItem(
          onTap: onShare,
          child: Text(tr('share')),
        ),
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

    return SizeTransition(
      sizeFactor: animation,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: ListTile(
          key: ValueKey(ledger.id),
          title: Text(ledger.name),
          subtitle: Text(
            ledger.description ??
                DateFormat('d MMM yyyy HH:mm', context.locale.toLanguageTag())
                    .format(
                  ledger.createdAt.toLocal(),
                ),
          ),
          onTap: onTap,
          trailing: actions.isEmpty
              ? null
              : PopupMenuButton(
                  icon: const Icon(Icons.more_vert),
                  itemBuilder: (context) => actions,
                ),
        ),
      ),
    );
  }
}
