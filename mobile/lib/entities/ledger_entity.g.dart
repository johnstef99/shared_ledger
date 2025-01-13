// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ledger_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LedgerEntityImpl _$$LedgerEntityImplFromJson(Map<String, dynamic> json) =>
    _$LedgerEntityImpl(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      userUid: json['user_uid'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      description: json['description'] as String?,
    );

Map<String, dynamic> _$$LedgerEntityImplToJson(_$LedgerEntityImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'user_uid': instance.userUid,
      'created_at': instance.createdAt.toIso8601String(),
      'description': instance.description,
    };
