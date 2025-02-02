import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:shared_ledger/models/user_model.dart';
import 'package:shared_ledger/services/auth_service.dart';

enum LoginType { password, magic }

class LoginViewModel {
  static const Duration magicLinkCooldown = Duration(seconds: 60);

  final AuthService _authService;

  ValueNotifier<bool> isLogginIn = ValueNotifier(false);

  ValueNotifier<bool> isMagicCodeSending = ValueNotifier(false);

  ValueNotifier<bool> isPasswordVisible = ValueNotifier(false);

  ValueNotifier<LoginType?> loginType = ValueNotifier(null);

  final formKey = GlobalKey<FormState>();

  final emailKey = GlobalKey<FormFieldState>();
  String email = '';

  String password = '';
  String token = '';
  DateTime? lastSentMagicLink;
  OTPResponse? otpResponse;

  LoginViewModel({required AuthService authService})
      : _authService = authService;
  ValueNotifier<User> get user => _authService.user;

  void dispose() {
    isLogginIn.dispose();
    isMagicCodeSending.dispose();
    isPasswordVisible.dispose();
    loginType.dispose();
  }

  Future<void> login() async {
    if (isLogginIn.value) return;
    if (isMagicCodeSending.value) return;

    if (loginType.value != LoginType.password) {
      loginType.value = LoginType.password;
      return;
    }

    if (formKey.currentState?.validate() == false) return;
    formKey.currentState?.save();

    isLogginIn.value = true;
    await _authService
        .loginWithPassword(email, password)
        .onError((e, _) => onError(e))
        .whenComplete(() => isLogginIn.value = false);
  }

  Future<void> loginWithToken() async {
    if (otpResponse == null) return;
    if (formKey.currentState?.validate() == false) return;
    formKey.currentState?.save();

    isLogginIn.value = true;
    await _authService
        .loginWithToken(otpResponse!.otpId, token)
        .whenComplete(() => isLogginIn.value = false)
        .onError((e, _) => onError(e));
  }

  void onError(Object? e) {
    final context = formKey.currentContext;
    if (context == null || !context.mounted) return;
    final message = switch (e) {
      ClientException(response: {'message': String msg}) => msg,
      _ => tr('generic_error_msg'),
    };
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> sendMagicCode() async {
    if (isLogginIn.value) return;
    if (isMagicCodeSending.value) return;

    if (emailKey.currentState?.validate() == false) return;
    formKey.currentState?.save();

    if (lastSentMagicLink != null &&
        DateTime.now().difference(lastSentMagicLink!) < magicLinkCooldown) {
      return;
    }

    isMagicCodeSending.value = true;
    otpResponse = await _authService.magicLogin(email).then<OTPResponse?>(
      (otp) {
        final context = formKey.currentContext;
        lastSentMagicLink = DateTime.now();
        if (context == null || !context.mounted) return otp;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(tr('login_view.code_sent_msg', args: [email]))),
        );
        return otp;
      },
      onError: (e, _) {
        onError(e);
        return null;
      },
    ).whenComplete(() {
      isMagicCodeSending.value = false;
    });
  }

  void setLoginType(LoginType? type) {
    if (emailKey.currentState?.validate() == false) return;

    loginType.value = type;
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }
}
