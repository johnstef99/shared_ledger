// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ledger_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LedgerImpl _$$LedgerImplFromJson(Map<String, dynamic> json) => _$LedgerImpl(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      isShared: json['is_shared'] as bool,
      description: json['description'] as String?,
    );

Map<String, dynamic> _$$LedgerImplToJson(_$LedgerImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'created_at': instance.createdAt.toIso8601String(),
      'is_shared': instance.isShared,
      'description': instance.description,
    };
