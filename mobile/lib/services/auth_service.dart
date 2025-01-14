import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:shared_ledger/models/user_model.dart';

class AuthService {
  final PocketBase _pb;

  ValueNotifier<User> user = ValueNotifier<User>(const User.empty());

  AuthService({required PocketBase pocketbase}) : _pb = pocketbase {
    final hasUserStored = _pb.authStore.record != null;
    final isValid = _pb.authStore.isValid;
    if (hasUserStored && isValid) {
      _onUserUpdate(_pb.authStore.record!);
      _pb.collection('users').authRefresh();
    }
    _pb.authStore.onChange.listen(onAuthChange);
  }

  void onAuthChange(event) {
    if (event.record != null) {
      _pb.collection('users').subscribe(event.record!.id, _onUserRecordUpdate);
      _onUserUpdate(event.record!);
    } else {
      _pb.collection('user').unsubscribe();
    }
  }

  void _onUserRecordUpdate(RecordSubscriptionEvent e) {
    if (e.record != null) _onUserUpdate(e.record!);
  }

  void _onUserUpdate(RecordModel record) {
    final avatarUrl = _pb.files.getURL(record, record.getStringValue('avatar'));
    user.value = User.fromRecord(record, avatar: avatarUrl.toString());
  }

  void dispose() {
    user.dispose();
  }

  Future<void> loginWithPassword(String email, String password) async {
    await _pb.collection('users').authWithPassword(email, password).then((rec) {
      _onUserUpdate(rec.record);
    });
  }

  Future<void> logout() async {
    _pb.authStore.clear();
    user.value = User.empty();
  }

  Future<OTPResponse> magicLogin(String email) async {
    return await _pb.collection('users').requestOTP(email);
  }

  Future<void> loginWithToken(String otpId, String password) async {
    await _pb.collection('users').authWithOTP(otpId, password);
  }

  Future<void> changePassword(String password) async {
    await _pb.collection('users').changePassword(password);
  }

  Future<void> deleteAccount() async {
    await _pb.collection('users').delete(user.value.id);
    _pb.authStore.clear();
    user.value = User.empty();
  }
}

extension on RecordService {
  Future<void> changePassword(String password) async {
    final email = client.authStore.record?.getStringValue('email');
    if (email == null) throw Exception('User not logged in');
    await client
        .send("/api/collections/users/change-password", method: 'POST', body: {
      'password': password,
    });
    await authWithPassword(email, password);
  }
}
