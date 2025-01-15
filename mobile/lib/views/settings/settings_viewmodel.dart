import 'package:flutter/material.dart';
import 'package:shared_ledger/services/auth_service.dart';

class SettingsViewModel {
  final AuthService _authService;

  SettingsViewModel({required AuthService authService})
      : _authService = authService;

  ValueNotifier<bool> isLoggingOut = ValueNotifier(false);

  Future<void> logout() async {
    if (isLoggingOut.value) return;
    isLoggingOut.value = true;
    _authService.logout();
    isLoggingOut.value = false;
  }
}
