// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TransactionEntityImpl _$$TransactionEntityImplFromJson(
        Map<String, dynamic> json) =>
    _$TransactionEntityImpl(
      id: (json['id'] as num).toInt(),
      ledgerId: (json['ledger_id'] as num).toInt(),
      contactId: (json['contact_id'] as num?)?.toInt(),
      amount: (json['amount'] as num).toDouble(),
      createdAt: DateTime.parse(json['created_at'] as String),
      transactionAt: DateTime.parse(json['transaction_at'] as String),
      comment: json['comment'] as String?,
    );

Map<String, dynamic> _$$TransactionEntityImplToJson(
        _$TransactionEntityImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'ledger_id': instance.ledgerId,
      'contact_id': instance.contactId,
      'amount': instance.amount,
      'created_at': instance.createdAt.toIso8601String(),
      'transaction_at': instance.transactionAt.toIso8601String(),
      'comment': instance.comment,
    };
