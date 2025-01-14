// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ledger_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LedgerEntityImpl _$$LedgerEntityImplFromJson(Map<String, dynamic> json) =>
    _$LedgerEntityImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      userId: json['user_id'] as String,
      created: DateTime.parse(json['created'] as String),
      description: json['description'] as String?,
    );

Map<String, dynamic> _$$LedgerEntityImplToJson(_$LedgerEntityImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'user_id': instance.userId,
      'created': instance.created.toIso8601String(),
      'description': instance.description,
    };
