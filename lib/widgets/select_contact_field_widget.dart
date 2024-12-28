import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shared_ledger/app/app.dart';
import 'package:shared_ledger/models/contact_model.dart';
import 'package:shared_ledger/widgets/contact_list_tile_widget.dart';

class SelectContactField extends StatelessWidget {
  const SelectContactField({
    super.key,
    this.onContactSelected,
    required this.contact,
  });

  final ValueNotifier<Contact?> contact;
  final Function(Contact)? onContactSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          plural('contact', 1),
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        ValueListenableBuilder(
          valueListenable: contact,
          builder: (BuildContext context, Contact? contact, Widget? child) {
            return ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 350),
              child: TextFormField(
                key: ValueKey(contact?.hashCode),
                initialValue: contact?.displayName,
                onTap: () async {
                  final contact = await showSearch(
                      context: context, delegate: ContactSearchDelegate());
                  if (contact == null) return;
                  onContactSelected?.call(contact);
                },
                readOnly: true,
                decoration: InputDecoration(
                  isDense: true,
                  prefixIcon: Icon(Icons.person_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty || contact == null) {
                    return 'Please select a contact';
                  }
                  return null;
                },
              ),
            );
          },
        )
      ],
    );
  }
}

class ContactSearchDelegate extends SearchDelegate<Contact?> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return BackButton(onPressed: () {
      close(context, null);
    });
  }

  @override
  Widget buildResults(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: context.app.contactsService.contacts,
        builder: (context, contacts, child) {
          final results = contacts.where((contact) {
            return contact.displayName
                .toLowerCase()
                .contains(query.toLowerCase());
          }).toList();
          return ListView.builder(
            itemCount: results.length,
            itemBuilder: (context, index) {
              final contact = results[index];
              return ContactListTile(
                contact: contact,
                onTap: () {
                  close(context, contact);
                },
              );
            },
          );
        });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return buildResults(context);
  }
}
