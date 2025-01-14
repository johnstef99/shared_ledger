// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TransactionImpl _$$TransactionImplFromJson(Map<String, dynamic> json) =>
    _$TransactionImpl(
      id: json['id'] as String,
      ledgerId: json['ledger_id'] as String,
      contact: json['contact'] == null
          ? null
          : Contact.fromJson(json['contact'] as Map<String, dynamic>),
      amount: (json['amount'] as num).toDouble(),
      created: DateTime.parse(json['created'] as String),
      transactionAt: DateTime.parse(json['transaction_at'] as String),
      comment: json['comment'] as String?,
    );

Map<String, dynamic> _$$TransactionImplToJson(_$TransactionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'ledger_id': instance.ledgerId,
      'contact': instance.contact,
      'amount': instance.amount,
      'created': instance.created.toIso8601String(),
      'transaction_at': instance.transactionAt.toIso8601String(),
      'comment': instance.comment,
    };
