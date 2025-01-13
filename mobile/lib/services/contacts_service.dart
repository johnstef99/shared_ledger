import 'package:flutter/material.dart';
import 'package:shared_ledger/models/contact_model.dart';
import 'package:shared_ledger/repositories/contacts_repository.dart';
import 'package:shared_ledger/services/auth_service.dart';

class ContactsService {
  final ContactsRepository _contactsRepository;
  final AuthService _authService;

  ContactsService({
    required ContactsRepository contactsRepository,
    required AuthService authService,
  })  : _contactsRepository = contactsRepository,
        _authService = authService {
    _authService.user.addListener(_onUserChanged);
    if (_authService.user.value.isEmpty) return;
    loadContacts();
  }

  final ValueNotifier<List<Contact>> contacts = ValueNotifier([]);

  void _onUserChanged() {
    if (_authService.user.value.isEmpty) {
      contacts.value = [];
      return;
    }
    loadContacts();
  }

  void dispose() {
    contacts.dispose();
  }

  Future<void> loadContacts() async {
    final data = await _contactsRepository.getContacts();
    contacts.value = data;
  }

  Future<void> createContact({required Contact contact}) async {
    await _contactsRepository.createContact(contact: contact);
    await loadContacts();
  }

  Future<void> updateContact(Contact contact) async {
    await _contactsRepository.updateContact(contact);
    await loadContacts();
  }

  Future<void> deleteContact(Contact contact) async {
    await _contactsRepository.deleteContact(contact);
    await loadContacts();
  }

  Future<Contact> getContact(int id) {
    return _contactsRepository.getContact(id);
  }
}
