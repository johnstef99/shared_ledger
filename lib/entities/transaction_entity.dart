import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction_entity.freezed.dart';
part 'transaction_entity.g.dart';

@freezed
class TransactionEntity with _$TransactionEntity {
  factory TransactionEntity({
    required int id,
    required int ledgerId,
    required int? contactId,
    required double amount,
    required DateTime createdAt,
    required DateTime transactionAt,
    String? comment,
  }) = _TransactionEntity;

  factory TransactionEntity.fromJson(Map<String, dynamic> json) =>
      _$TransactionEntityFromJson(json);
}
