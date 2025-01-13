import 'package:easy_localization/easy_localization.dart' as ez;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_ledger/app/app.dart';
import 'package:shared_ledger/views/contacts/contacts_viewmodel.dart';
import 'package:shared_ledger/widgets/contact_list_tile_widget.dart';
import 'package:shared_ledger/widgets/view_model_provider_widget.dart';

class ContactsView extends StatefulWidget {
  const ContactsView({super.key});

  @override
  State<ContactsView> createState() => _ContactsViewState();
}

class _ContactsViewState extends State<ContactsView> {
  late ContactsViewModel model;

  static String tr(String key) => ez.tr('contacts_view.$key');

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    model = ContactsViewModel(
      contactsService: context.app.contactsService,
      router: GoRouter.of(context),
    );
    model.init();
  }

  @override
  Widget build(BuildContext context) {
    context.locale;
    return ViewModelProvider(
      viewModel: model,
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          heroTag: 'add_contact_button',
          onPressed: () {
            context.go('/contacts/create');
          },
          child: Icon(Icons.person_add),
        ),
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              title: Text(tr('appbar_title')),
            ),
            ValueListenableBuilder(
              valueListenable: model.isLoading,
              builder: (context, isLoading, child) {
                if (isLoading) {
                  return const SliverFillRemaining(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                return _List();
              },
            ),
            SliverPadding(padding: EdgeInsets.only(bottom: 100)),
          ],
        ),
      ),
    );
  }
}

class _List extends StatelessWidget {
  const _List();

  @override
  Widget build(BuildContext context) {
    final model = ViewModelProvider.of<ContactsViewModel>(context);
    return ValueListenableBuilder(
      valueListenable: model.contacts,
      builder: (context, contacts, child) {
        if (contacts.isEmpty) {
          return SliverFillRemaining(
            child: Center(
              child: Text(ez.tr('contacts_view.no_contacts_msg')),
            ),
          );
        }
        return SliverList.builder(
          itemCount: contacts.length,
          itemBuilder: (context, index) {
            final contact = contacts[index];
            return ContactListTile(
              contact: contact,
              onDelete: () {
                model.deleteContact(contact);
              },
              onEdit: () {
                model.editContact(contact);
              },
            );
          },
        );
      },
    );
  }
}
