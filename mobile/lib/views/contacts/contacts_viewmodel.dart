import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_ledger/models/contact_model.dart';
import 'package:shared_ledger/services/contacts_service.dart';

class ContactsViewModel {
  final ContactsService _contactsService;
  final GoRouter _router;

  ContactsViewModel({
    required ContactsService contactsService,
    required GoRouter router,
  })  : _contactsService = contactsService,
        _router = router;

  ValueNotifier<List<Contact>> get contacts => _contactsService.contacts;

  ValueNotifier<bool> isLoading = ValueNotifier(false);

  Future<void> init() async {
    isLoading.value = true;
    await _contactsService
        .loadContacts()
        .whenComplete(() => isLoading.value = false);
  }

  Future<void> deleteContact(Contact contact) async {
    await _contactsService.deleteContact(contact);
  }

  void editContact(Contact contact) {
    _router.go('/contacts/${contact.id}/edit', extra: contact);
  }

  Future<void> onRefresh() async {
    await _contactsService.onRefresh();
  }
}
