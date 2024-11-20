import 'package:shared_ledger/app/utils.dart';
import 'package:shared_ledger/entities/ledger_entity.dart';
import 'package:shared_ledger/models/ledger_model.dart';
import 'package:shared_ledger/services/auth_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supa;

class LedgerRepository {
  final supa.SupabaseClient _supabase;
  final AuthService _authService;

  LedgerRepository({
    required supa.SupabaseClient supabase,
    required AuthService authService,
  })  : _supabase = supabase,
        _authService = authService;

  Future<Ledger> createLedger(String name, String? description) async {
    final data = await _supabase
        .from('ledgers')
        .insert({
          'name': name,
          'description': description.orNull,
        })
        .select()
        .then((data) => LedgerEntity.fromJson(data.first));

    return Ledger.fromEntity(data, _authService.user.value.uid);
  }

  Future<Ledger> updateLedger(Ledger ledger) async {
    return await _supabase
        .from('ledgers')
        .update({
          'name': ledger.name,
          'description': ledger.description.orNull,
        })
        .eq('id', ledger.id)
        .select()
        .then((data) => LedgerEntity.fromJson(data.first))
        .then((data) => Ledger.fromEntity(data, _authService.user.value.uid));
  }

  Future<List<Ledger>> getLedgers() async {
    final data = await _supabase
        .from('ledgers')
        .select()
        .eq('user_uid', _authService.user.value.uid)
        .order('created_at', ascending: false)
        .then((data) => data.map(LedgerEntity.fromJson));

    return data
        .map((l) => Ledger.fromEntity(l, _authService.user.value.uid))
        .toList();
  }

  Future<void> deleteLedger(Ledger ledger) async {
    await _supabase.from('ledgers').delete().eq('id', ledger.id);
  }

  Future<List<Ledger>> getSharedWithMeLedgers() async {
    final data = await _supabase
        .rpc('get_ledgers_by_email', params: {
          'email_address': _authService.user.value.email,
        })
        .select()
        .then((data) => data.map(LedgerEntity.fromJson));

    return data
        .map((l) => Ledger.fromEntity(l, _authService.user.value.uid))
        .toList();
  }

  Future<Ledger> getLedger(int id) async {
    final data = await _supabase
        .from('ledgers')
        .select()
        .eq('id', id)
        .then((data) => LedgerEntity.fromJson(data.first));

    return Ledger.fromEntity(data, _authService.user.value.uid);
  }
}
