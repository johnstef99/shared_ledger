// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TransactionImpl _$$TransactionImplFromJson(Map<String, dynamic> json) =>
    _$TransactionImpl(
      id: (json['id'] as num).toInt(),
      ledgerId: (json['ledger_id'] as num).toInt(),
      contact: json['contact'] == null
          ? null
          : Contact.fromJson(json['contact'] as Map<String, dynamic>),
      amount: (json['amount'] as num).toDouble(),
      createdAt: DateTime.parse(json['created_at'] as String),
      transactionAt: DateTime.parse(json['transaction_at'] as String),
      comment: json['comment'] as String?,
    );

Map<String, dynamic> _$$TransactionImplToJson(_$TransactionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'ledger_id': instance.ledgerId,
      'contact': instance.contact,
      'amount': instance.amount,
      'created_at': instance.createdAt.toIso8601String(),
      'transaction_at': instance.transactionAt.toIso8601String(),
      'comment': instance.comment,
    };
