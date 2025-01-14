// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TransactionEntityImpl _$$TransactionEntityImplFromJson(
        Map<String, dynamic> json) =>
    _$TransactionEntityImpl(
      id: json['id'] as String,
      ledgerId: json['ledger_id'] as String,
      contactId: json['contact_id'] as String?,
      amount: (json['amount'] as num).toDouble(),
      created: DateTime.parse(json['created'] as String),
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
      'created': instance.created.toIso8601String(),
      'transaction_at': instance.transactionAt.toIso8601String(),
      'comment': instance.comment,
    };
