import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_ledger/models/contact_model.dart';
import 'package:shared_ledger/services/contacts_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CreateOrEditContactViewModel {
  final ContactsService _contactsService;
  final GoRouter _router;
  final Contact? contact;

  CreateOrEditContactViewModel({
    required ContactsService contactsService,
    required GoRouter router,
    this.contact,
  })  : _contactsService = contactsService,
        _router = router {
    if (contact != null) {
      email = contact!.email ?? '';
      name = contact!.name;
      phoneNumber = contact!.phoneNumber ?? '';
    }
  }

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  ValueNotifier<bool> isLoading = ValueNotifier(false);

  String email = '';
  String name = '';
  String phoneNumber = '';

  Future<void> saveContact() async {
    if (formKey.currentState?.validate() != true) return;
    formKey.currentState?.save();

    isLoading.value = true;

    final createOrUpdate = switch (contact == null) {
      true => _contactsService.createContact(
          contact: Contact(
            id: 0,
            email: email,
            name: name,
            phoneNumber: phoneNumber,
          ),
        ),
      false => _contactsService.updateContact(
          contact!.copyWith(
            email: email,
            name: name,
            phoneNumber: phoneNumber,
          ),
        ),
    };

    await createOrUpdate
        .whenComplete(() => isLoading.value = false)
        .then((_) => _router.pop())
        .onError((error, stackTrace) {
      final context = formKey.currentContext;
      if (context == null || !context.mounted) return;
      final message = switch (error) {
        PostgrestException(message: final message)
            when message.contains('contacts_unique_email_per_user_uid') =>
          'Contact with this email already exists',
        _ => 'Failed to save contact',
      };
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
        ),
      );
    });
  }
}
