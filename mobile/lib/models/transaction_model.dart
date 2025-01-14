import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_ledger/entities/transaction_entity.dart';
import 'package:shared_ledger/models/contact_model.dart';

part 'transaction_model.freezed.dart';
part 'transaction_model.g.dart';

@freezed
class Transaction with _$Transaction {
  factory Transaction({
    required String id,
    required String ledgerId,
    required Contact? contact,
    required double amount,
    required DateTime created,
    required DateTime transactionAt,
    String? comment,
  }) = _Transaction;

  factory Transaction.fromJson(Map<String, dynamic> json) =>
      _$TransactionFromJson(json);

  factory Transaction.fromEntity(TransactionEntity entity, Contact? contact) {
    return Transaction(
      id: entity.id,
      ledgerId: entity.ledgerId,
      contact: contact,
      amount: entity.amount,
      comment: entity.comment,
      created: entity.created,
      transactionAt: entity.transactionAt,
    );
  }
}
