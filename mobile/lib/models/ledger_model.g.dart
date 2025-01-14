// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ledger_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LedgerImpl _$$LedgerImplFromJson(Map<String, dynamic> json) => _$LedgerImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      created: DateTime.parse(json['created'] as String),
      isShared: json['is_shared'] as bool,
      description: json['description'] as String?,
    );

Map<String, dynamic> _$$LedgerImplToJson(_$LedgerImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'created': instance.created.toIso8601String(),
      'is_shared': instance.isShared,
      'description': instance.description,
    };
