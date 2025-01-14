import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction_entity.freezed.dart';
part 'transaction_entity.g.dart';

@freezed
class TransactionEntity with _$TransactionEntity {
  factory TransactionEntity({
    required String id,
    required String ledgerId,
    required String? contactId,
    required double amount,
    required DateTime created,
    required DateTime transactionAt,
    String? comment,
  }) = _TransactionEntity;

  factory TransactionEntity.fromJson(Map<String, dynamic> json) =>
      _$TransactionEntityFromJson(json);
}
