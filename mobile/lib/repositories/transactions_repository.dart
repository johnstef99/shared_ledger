import 'dart:convert';

import 'package:pocketbase/pocketbase.dart';
import 'package:shared_ledger/app/utils.dart';
import 'package:shared_ledger/entities/contact_entity.dart';
import 'package:shared_ledger/entities/transaction_entity.dart';
import 'package:shared_ledger/models/contact_model.dart';
import 'package:shared_ledger/models/transaction_model.dart';
import 'package:shared_ledger/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TransactionsRepository {
  final PocketBase _pb;
  final SharedPreferences _prefs;
  final AuthService _authService;

  TransactionsRepository({
    required PocketBase pocketbase,
    required AuthService authService,
    required SharedPreferences prefs,
  })  : _pb = pocketbase,
        _authService = authService,
        _prefs = prefs;

  Future<List<Transaction>> getTransactions(String ledgerId,
      {bool noCache = false}) async {
    return await _prefs.cached(
      force: noCache,
      key: 'getTransactions_${_authService.user.value.id}_$ledgerId',
      fetch: () => _pb
          .collection('transactions')
          .getFullList(
            filter: 'ledger_id = "$ledgerId"',
            sort: '-transaction_at',
            expand: 'contact_id',
          )
          .then((list) => list.map((i) {
                return (
                  t: i.data,
                  c: i.get<RecordModel>('expand.contact_id').toJson(),
                );
              }))
          .then((jsons) => jsons.map((i) => (
                t: TransactionEntity.fromJson(i.t),
                c: ContactEntity.fromJson(i.c)
              )))
          .then(
            (entities) => entities
                .map((i) => Transaction.fromEntity(
                      i.t,
                      Contact.fromEntity(i.c),
                    ))
                .toList(),
          ),
      encode: (transactions) =>
          jsonEncode(transactions.map((t) => t.toJson()).toList()),
      decode: (json) => (jsonDecode(json) as List)
          .map((t) => Transaction.fromJson(t))
          .toList(),
    );
  }

  Future<void> deleteTransaction(Transaction transaction) async {
    await _pb.collection('transactions').delete(transaction.id);
    await _prefs.clearCache(
        'getTransactions_${_authService.user.value.id}_${transaction.ledgerId}');
    await _prefs.clearCache(
        'getTransaction_${_authService.user.value.id}_${transaction.id}');
  }

  Future<Transaction> updateTransaction(Transaction transaction) async {
    final data = await _pb
        .collection('transactions')
        .update(
          transaction.id,
          body: {
            'contact_id': transaction.contact?.id,
            'amount': transaction.amount,
            'comment': transaction.comment.orNull,
            'transaction_at':
                transaction.transactionAt.toUtc().toIso8601String(),
          },
        )
        .then((rec) => rec.data)
        .then(TransactionEntity.fromJson)
        .then((entity) => Transaction.fromEntity(entity, transaction.contact));

    await _prefs.clearCache(
        'getTransactions_${_authService.user.value.id}_${transaction.ledgerId}');
    await _prefs.clearCache(
        'getTransaction_${_authService.user.value.id}_${transaction.id}');
    return data;
  }

  Future<Transaction> createTransaction({
    required String ledgerId,
    required Contact contact,
    required double amount,
    required String? comment,
    required DateTime transactionAt,
  }) async {
    final data = await _pb
        .collection('transactions')
        .create(body: {
          'ledger_id': ledgerId,
          'contact_id': contact.id,
          'amount': amount,
          'comment': comment.orNull,
          'transaction_at': transactionAt.toUtc().toIso8601String(),
        })
        .then((rec) => TransactionEntity.fromJson(rec.toJson()))
        .then((entity) => Transaction.fromEntity(entity, contact));

    await _prefs
        .clearCache('getTransactions_${_authService.user.value.id}_$ledgerId');
    return data;
  }

  Future<Transaction> getTransaction(String transactionId,
      {bool noCache = false}) async {
    return await _prefs.cached(
      force: noCache,
      key: 'getTransaction_${_authService.user.value.id}_$transactionId',
      fetch: () => _pb
          .collection('transactions')
          .getOne(
            transactionId,
            expand: 'contact_id',
          )
          .then((rec) => (
                t: rec.data,
                c: rec.get<RecordModel>('expand.contact_id').toJson(),
              ))
          .then((jsons) => (
                t: TransactionEntity.fromJson(jsons.t),
                c: ContactEntity.fromJson(jsons.c),
              ))
          .then((entities) => Transaction.fromEntity(
                entities.t,
                Contact.fromEntity(entities.c),
              )),
      encode: (transaction) => jsonEncode(transaction.toJson()),
      decode: (json) => Transaction.fromJson(jsonDecode(json)),
    );
  }
}
