import 'package:flutter/material.dart';
import 'package:shared_ledger/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supa;

class AuthService {
  final supa.SupabaseClient _supabase;

  ValueNotifier<User> user = ValueNotifier<User>(const User.empty());

  AuthService({required supa.SupabaseClient supabase}) : _supabase = supabase {
    _supabase.auth.onAuthStateChange.listen((event) {
      switch (event.event) {
        case supa.AuthChangeEvent.signedIn:
          final user = _supabase.auth.currentUser;
          if (user == null) return;
          this.user.value = User.fromSupabaseUser(user);
        case supa.AuthChangeEvent.signedOut:
          this.user.value = const User.empty();
        default:
          return;
      }
    });
    final user = _supabase.auth.currentUser;
    if (user == null) return;
    this.user.value = User.fromSupabaseUser(user);
  }

  void dispose() {
    user.dispose();
  }

  Future<void> loginWithPassword(String email, String password) async {
    await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Future<void> logout() async {
    await _supabase.auth.signOut();
  }

  Future<void> magicLogin(String email) async {
    await _supabase.auth.signInWithOtp(email: email);
  }

  Future<void> loginWithToken(String email, String token) async {
    await _supabase.auth.verifyOTP(
      type: supa.OtpType.email,
      email: email,
      token: token,
    );
  }

  Future<void> changePassword(String password) async {
    await _supabase.auth.updateUser(
      supa.UserAttributes(password: password),
    );
  }
}
