import 'dart:convert';

import 'package:pocketbase/pocketbase.dart';
import 'package:shared_ledger/app/utils.dart';
import 'package:shared_ledger/entities/ledger_entity.dart';
import 'package:shared_ledger/models/ledger_model.dart';
import 'package:shared_ledger/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LedgerRepository {
  final PocketBase _pb;
  final AuthService _authService;
  final SharedPreferences _prefs;

  LedgerRepository({
    required PocketBase pocketbase,
    required AuthService authService,
    required SharedPreferences prefs,
  })  : _pb = pocketbase,
        _authService = authService,
        _prefs = prefs;

  Future<Ledger> createLedger(String name, String? description) async {
    final data = await _pb.collection('ledgers').create(body: {
      'name': name,
      'description': description.orNull,
      'user_id': _authService.user.value.id,
    }).then((rec) => LedgerEntity.fromJson(rec.toJson()));

    return Ledger.fromEntity(data, _authService.user.value.id);
  }

  Future<Ledger> updateLedger(Ledger ledger) async {
    return await _pb
        .collection('ledgers')
        .update(ledger.id, body: {
          'name': ledger.name,
          'description': ledger.description.orNull,
        })
        .then((rec) => LedgerEntity.fromJson(rec.toJson()))
        .then((data) => Ledger.fromEntity(data, _authService.user.value.id));
  }

  Future<List<Ledger>> getLedgers({bool noCache = false}) async {
    return _prefs.cached(
      key: 'getLedgers_${_authService.user.value.id}',
      force: noCache,
      fetch: () => _pb
          .collection('ledgers')
          .getFullList(
            sort: '-created',
            filter: 'user_id = "${_authService.user.value.id}"',
          )
          .then((list) => list
              .map((led) => Ledger.fromEntity(
                  LedgerEntity.fromJson(led.toJson()),
                  _authService.user.value.id))
              .toList()),
      encode: (list) => jsonEncode(list.map((e) => e.toJson()).toList()),
      decode: (json) =>
          (jsonDecode(json) as List).map((e) => Ledger.fromJson(e)).toList(),
    );
  }

  Future<void> deleteLedger(Ledger ledger) async {
    await _pb.collection('ledgers').delete(ledger.id);
  }

  Future<List<Ledger>> getSharedWithMeLedgers({bool noCache = false}) async {
    return await _prefs.cached(
      key: 'getSharedWithMeLedgers_${_authService.user.value.id}',
      force: noCache,
      fetch: () => _pb
          .collection('ledgers')
          .getFullList(
            sort: '-created',
            filter: 'user_id != "${_authService.user.value.id}"',
          )
          .then((list) => list
              .map((led) => Ledger.fromEntity(
                  LedgerEntity.fromJson(led.toJson()),
                  _authService.user.value.id))
              .toList()),
      encode: (list) => jsonEncode(list.map((e) => e.toJson()).toList()),
      decode: (json) =>
          (jsonDecode(json) as List).map((e) => Ledger.fromJson(e)).toList(),
    );
  }

  Future<Ledger> getLedger(String id, {bool noCache = false}) async {
    return await _prefs.cached(
      key: 'getLedger_${_authService.user.value.id}_$id',
      fetch: () => _pb.collection('ledgers').getOne(id).then(
            (led) => Ledger.fromEntity(LedgerEntity.fromJson(led.toJson()),
                _authService.user.value.id),
          ),
      encode: (data) => jsonEncode(data.toJson()),
      decode: (json) => Ledger.fromJson(jsonDecode(json)),
    );
  }

  Future<List<String>> getSharedEmails(String ledgerId) async {
    return await _pb
        .collection('ledgers_users')
        .getFullList(
          filter: 'ledger_id = "$ledgerId"',
        )
        .then(
            (list) => list.map((e) => e.getStringValue('user_email')).toList());
  }

  Future<void> addSharedEmail(String id, String email) async {
    await _pb.collection('ledgers_users').create(body: {
      'ledger_id': id,
      'user_email': email,
    });
  }

  Future<void> removeSharedEmail(String ledgerId, String email) async {
    final id = await _pb
        .collection('ledgers_users')
        .getFirstListItem(
          'ledger_id = "$ledgerId" && user_email = "$email"',
        )
        .then((e) => e.id);

    await _pb.collection('ledgers_users').delete(id);
  }
}
