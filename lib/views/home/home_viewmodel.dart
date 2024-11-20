import 'package:flutter/material.dart';
import 'package:shared_ledger/models/user_model.dart';
import 'package:shared_ledger/services/auth_service.dart';

class HomeViewModel {
  final AuthService _authService;

  HomeViewModel({required AuthService authService})
      : _authService = authService;

  ValueNotifier<User> get user => _authService.user;
}
