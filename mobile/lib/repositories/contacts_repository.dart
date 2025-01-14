import 'package:pocketbase/pocketbase.dart';
import 'package:shared_ledger/app/utils.dart';
import 'package:shared_ledger/entities/contact_entity.dart';
import 'package:shared_ledger/models/contact_model.dart';
import 'package:shared_ledger/services/auth_service.dart';

class ContactsRepository {
  final PocketBase _pb;
  final AuthService _authService;

  ContactsRepository({
    required PocketBase pocketbase,
    required AuthService authService,
  })  : _pb = pocketbase,
        _authService = authService;

  Future<Contact> createContact({required Contact contact}) async {
    return await _pb
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
  }

  Future<List<Contact>> getContacts() async {
    return await _pb
        .collection('contacts')
        .getFullList(
          filter: 'user_id = "${_authService.user.value.id}"',
          sort: '-created',
        )
        .then((list) => list.map((e) => e.toJson()))
        .then((jsons) => jsons.map(ContactEntity.fromJson))
        .then((entities) => entities.map(Contact.fromEntity).toList());
  }

  Future<void> deleteContact(Contact contact) async {
    await _pb.collection('contacts').delete(contact.id);
  }

  Future<void> updateContact(Contact contact) async {
    await _pb.collection('contacts').update(contact.id, body: {
      'name': contact.name,
      'email': contact.email.orNull,
      'phone_number': contact.phoneNumber.orNull,
    });
  }

  Future<Contact> getContact(String id) async {
    return await _pb
        .collection('contacts')
        .getOne(id)
        .then((rec) => rec.toJson())
        .then(ContactEntity.fromJson)
        .then(Contact.fromEntity);
  }
}
