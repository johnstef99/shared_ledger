import 'package:flutter/material.dart';
import 'package:shared_ledger/services/auth_service.dart';

class DeleteAccountViewModel {
  final AuthService _authService;

  DeleteAccountViewModel({required AuthService authService})
      : _authService = authService;

  final ValueNotifier<bool> isDeletingAccount = ValueNotifier(false);

  void dispose() {
    isDeletingAccount.dispose();
  }

  Future<void> deleteAccount() async {
    isDeletingAccount.value = true;
    await _authService.deleteAccount().whenComplete(() {
      isDeletingAccount.value = false;
    });
  }
}
