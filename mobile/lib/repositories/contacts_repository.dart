import 'dart:convert';

import 'package:pocketbase/pocketbase.dart';
import 'package:shared_ledger/app/utils.dart';
import 'package:shared_ledger/entities/contact_entity.dart';
import 'package:shared_ledger/models/contact_model.dart';
import 'package:shared_ledger/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ContactsRepository {
  final PocketBase _pb;
  final AuthService _authService;
  final SharedPreferences _prefs;

  ContactsRepository({
    required PocketBase pocketbase,
    required AuthService authService,
    required SharedPreferences prefs,
  })  : _pb = pocketbase,
        _authService = authService,
        _prefs = prefs;

  Future<Contact> createContact({required Contact contact}) async {
    final data = await _pb
        .collection('contacts')
        .create(body: {
          'user_id': _authService.user.value.id,
          'name': contact.name,
          'email': contact.email.orNull,
          'phone_number': contact.phoneNumber.orNull,
        })
        .then((rec) => rec.toJson())
        .then(ContactEntity.fromJson)
        .then(Contact.fromEntity);

    await _prefs.clearCache('getContacts_${_authService.user.value.id}');

    return data;
  }

  Future<List<Contact>> getContacts() async {
    return await _prefs.cached(
      key: 'getContacts_${_authService.user.value.id}',
      fetch: () => _pb
          .collection('contacts')
          .getFullList(
            filter: 'user_id = "${_authService.user.value.id}"',
            sort: '-created',
          )
          .then((list) => list.map((e) => e.toJson()))
          .then((jsons) => jsons.map(ContactEntity.fromJson))
          .then((entities) => entities.map(Contact.fromEntity).toList()),
      encode: (contacts) =>
          jsonEncode(contacts.map((c) => c.toJson()).toList()),
      decode: (json) =>
          (jsonDecode(json) as List).map((c) => Contact.fromJson(c)).toList(),
    );
  }

  Future<void> deleteContact(Contact contact) async {
    await _pb.collection('contacts').delete(contact.id);
    await _prefs.clearCache('getContacts_${_authService.user.value.id}');
    await _prefs
        .clearCache('getContact_${_authService.user.value.id}_${contact.id}');
  }

  Future<void> updateContact(Contact contact) async {
    await _pb.collection('contacts').update(contact.id, body: {
      'name': contact.name,
      'email': contact.email.orNull,
      'phone_number': contact.phoneNumber.orNull,
    });
    await _prefs.clearCache('getContacts_${_authService.user.value.id}');
    await _prefs
        .clearCache('getContact_${_authService.user.value.id}_${contact.id}');
  }

  Future<Contact> getContact(String id) async {
    return await _prefs.cached(
      key: 'getContact_${_authService.user.value.id}_$id',
      fetch: () => _pb
          .collection('contacts')
          .getOne(id)
          .then((rec) => rec.toJson())
          .then(ContactEntity.fromJson)
          .then(Contact.fromEntity),
      encode: (contact) => jsonEncode(contact.toJson()),
      decode: (json) => Contact.fromJson(jsonDecode(json)),
    );
  }
}
