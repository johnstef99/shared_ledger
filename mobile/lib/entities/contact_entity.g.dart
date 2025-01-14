// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ContactEntityImpl _$$ContactEntityImplFromJson(Map<String, dynamic> json) =>
    _$ContactEntityImpl(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      email: json['email'] as String?,
      name: json['name'] as String,
      phoneNumber: json['phone_number'] as String?,
    );

Map<String, dynamic> _$$ContactEntityImplToJson(_$ContactEntityImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'email': instance.email,
      'name': instance.name,
      'phone_number': instance.phoneNumber,
    };
