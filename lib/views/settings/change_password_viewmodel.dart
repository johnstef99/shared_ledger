import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shared_ledger/services/auth_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supa;

class ChangePasswordViewModel {
  final AuthService _authService;

  ChangePasswordViewModel({required AuthService authService})
      : _authService = authService;

  String password = '';

  final formKey = GlobalKey<FormState>();

  ValueNotifier<bool> isChangingPassword = ValueNotifier(false);

  void dispose() {
    isChangingPassword.dispose();
  }

  Future<void> changePassword() async {
    if (isChangingPassword.value) return;
    if (!formKey.currentState!.validate()) return;
    formKey.currentState!.save();

    isChangingPassword.value = true;
    await _authService.changePassword(password).then((_) {
      final context = formKey.currentContext;
      if (context == null || !context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(tr('change_password_view.password_changed_msg'))),
      );
      Navigator.of(context).pop();
    }).onError((e, _) {
      final context = formKey.currentContext;
      if (context == null || !context.mounted) return;
      final message = switch (e) {
        supa.AuthException e => e.message,
        _ => tr('generic_error_msg'),
      };
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }).whenComplete(() => isChangingPassword.value = false);
  }
}
