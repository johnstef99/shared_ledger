import 'package:shared_ledger/entities/contact_entity.dart';
import 'package:shared_ledger/models/contact_model.dart';
import 'package:shared_ledger/services/auth_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supa;
import 'package:shared_ledger/app/utils.dart';

class ContactsRepository {
  final supa.SupabaseClient _supabase;
  final AuthService _authService;

  ContactsRepository({
    required supa.SupabaseClient supabase,
    required AuthService authService,
  })  : _supabase = supabase,
        _authService = authService;

  Future<Contact> createContact({required Contact contact}) async {
    final data = await _supabase
        .from('contacts')
        .insert({
          'name': contact.name,
          if (contact.email != null && contact.email!.isNotEmpty)
            'email': contact.email,
          if (contact.phoneNumber != null && contact.phoneNumber!.isNotEmpty)
            'phone_number': contact.phoneNumber,
        })
        .select()
        .then((data) => ContactEntity.fromJson(data.first));

    return Contact.fromEntity(data);
  }

  Future<List<Contact>> getContacts() async {
    final data = await _supabase
        .from('contacts')
        .select()
        .eq('user_uid', _authService.user.value.uid)
        .order('created_at', ascending: false)
        .then((data) => data.map(ContactEntity.fromJson));

    return data.map(Contact.fromEntity).toList();
  }

  Future<void> deleteContact(Contact contact) async {
    await _supabase.from('contacts').delete().eq('id', contact.id);
  }

  Future<void> updateContact(Contact contact) async {
    await _supabase.from('contacts').update({
      'name': contact.name,
      'email': contact.email.orNull,
      'phone_number': contact.phoneNumber.orNull,
    }).eq('id', contact.id);
  }

  Future<Contact> getContact(int id) {
    return _supabase
        .from('contacts')
        .select()
        .eq('id', id)
        .then((data) => ContactEntity.fromJson(data.first))
        .then(Contact.fromEntity);
  }
}
