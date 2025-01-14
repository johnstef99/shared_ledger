import 'package:pocketbase/pocketbase.dart';
import 'package:shared_ledger/app/utils.dart';
import 'package:shared_ledger/entities/contact_entity.dart';
import 'package:shared_ledger/entities/transaction_entity.dart';
import 'package:shared_ledger/models/contact_model.dart';
import 'package:shared_ledger/models/transaction_model.dart';

class TransactionsRepository {
  final PocketBase _pb;

  TransactionsRepository({
    required PocketBase pocketbase,
  }) : _pb = pocketbase;

  Future<List<Transaction>> getTransactions(String ledgerId) async {
    return await _pb
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
        );
  }

  Future<void> deleteTransaction(Transaction transaction) async {
    await _pb.collection('transactions').delete(transaction.id);
  }

  Future<Transaction> updateTransaction(Transaction transaction) async {
    return _pb
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
  }

  Future<Transaction> createTransaction({
    required String ledgerId,
    required Contact contact,
    required double amount,
    required String? comment,
    required DateTime transactionAt,
  }) async {
    return await _pb
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
  }

  Future<Transaction> getTransaction(String transactionId) async {
    return _pb
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
            ));
  }
}
