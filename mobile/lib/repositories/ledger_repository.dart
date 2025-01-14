import 'package:pocketbase/pocketbase.dart';
import 'package:shared_ledger/app/utils.dart';
import 'package:shared_ledger/entities/ledger_entity.dart';
import 'package:shared_ledger/models/ledger_model.dart';
import 'package:shared_ledger/services/auth_service.dart';

class LedgerRepository {
  final PocketBase _pb;
  final AuthService _authService;

  LedgerRepository({
    required PocketBase pocketbase,
    required AuthService authService,
  })  : _pb = pocketbase,
        _authService = authService;

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

  Future<List<Ledger>> getLedgers() async {
    return await _pb
        .collection('ledgers')
        .getFullList(
          sort: '-created',
          filter: 'user_id = "${_authService.user.value.id}"',
        )
        .then((list) => list
            .map((led) => Ledger.fromEntity(LedgerEntity.fromJson(led.toJson()),
                _authService.user.value.id))
            .toList());
  }

  Future<void> deleteLedger(Ledger ledger) async {
    await _pb.collection('ledgers').delete(ledger.id);
  }

  Future<List<Ledger>> getSharedWithMeLedgers() async {
    return await _pb
        .collection('ledgers')
        .getFullList(
          filter: 'user_id != "${_authService.user.value.id}"',
        )
        .then((list) => list
            .map((led) => Ledger.fromEntity(LedgerEntity.fromJson(led.toJson()),
                _authService.user.value.id))
            .toList());
  }

  Future<Ledger> getLedger(String id) async {
    return await _pb.collection('ledgers').getOne(id).then(
          (led) => Ledger.fromEntity(
              LedgerEntity.fromJson(led.toJson()), _authService.user.value.id),
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
