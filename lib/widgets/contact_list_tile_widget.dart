import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shared_ledger/models/contact_model.dart';

class ContactListTile extends StatelessWidget {
  final Contact contact;

  final void Function()? onDelete;
  final void Function()? onEdit;
  final void Function()? onTap;

  const ContactListTile({
    super.key,
    required this.contact,
    this.onDelete,
    this.onEdit,
    this.onTap,
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
        key: ValueKey(contact.id),
        title: Text(contact.displayName),
        onTap: onTap,
        subtitle: Column(
          children: [
            (contact.phoneNumber ?? '-', Icons.phone_outlined),
            (contact.email ?? '-', Icons.email_outlined)
          ]
              .map((i) => Row(
                    children: [
                      Icon(i.$2, size: 18),
                      SizedBox(width: 8),
                      Text(i.$1),
                    ],
                  ))
              .toList(),
        ),
        trailing: actions.isEmpty
            ? null
            : PopupMenuButton(
                icon: const Icon(Icons.more_vert),
                itemBuilder: (context) => actions,
              ),
      ),
    );
  }
}
