// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'contact_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ContactEntity _$ContactEntityFromJson(Map<String, dynamic> json) {
  return _ContactEntity.fromJson(json);
}

/// @nodoc
mixin _$ContactEntity {
  int get id => throw _privateConstructorUsedError;
  String get userUid => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get phoneNumber => throw _privateConstructorUsedError;

  /// Serializes this ContactEntity to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ContactEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ContactEntityCopyWith<ContactEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ContactEntityCopyWith<$Res> {
  factory $ContactEntityCopyWith(
          ContactEntity value, $Res Function(ContactEntity) then) =
      _$ContactEntityCopyWithImpl<$Res, ContactEntity>;
  @useResult
  $Res call(
      {int id,
      String userUid,
      String? email,
      String name,
      String? phoneNumber});
}

/// @nodoc
class _$ContactEntityCopyWithImpl<$Res, $Val extends ContactEntity>
    implements $ContactEntityCopyWith<$Res> {
  _$ContactEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ContactEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userUid = null,
    Object? email = freezed,
    Object? name = null,
    Object? phoneNumber = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      userUid: null == userUid
          ? _value.userUid
          : userUid // ignore: cast_nullable_to_non_nullable
              as String,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      phoneNumber: freezed == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ContactEntityImplCopyWith<$Res>
    implements $ContactEntityCopyWith<$Res> {
  factory _$$ContactEntityImplCopyWith(
          _$ContactEntityImpl value, $Res Function(_$ContactEntityImpl) then) =
      __$$ContactEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String userUid,
      String? email,
      String name,
      String? phoneNumber});
}

/// @nodoc
class __$$ContactEntityImplCopyWithImpl<$Res>
    extends _$ContactEntityCopyWithImpl<$Res, _$ContactEntityImpl>
    implements _$$ContactEntityImplCopyWith<$Res> {
  __$$ContactEntityImplCopyWithImpl(
      _$ContactEntityImpl _value, $Res Function(_$ContactEntityImpl) _then)
      : super(_value, _then);

  /// Create a copy of ContactEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userUid = null,
    Object? email = freezed,
    Object? name = null,
    Object? phoneNumber = freezed,
  }) {
    return _then(_$ContactEntityImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      userUid: null == userUid
          ? _value.userUid
          : userUid // ignore: cast_nullable_to_non_nullable
              as String,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      phoneNumber: freezed == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ContactEntityImpl implements _ContactEntity {
  const _$ContactEntityImpl(
      {required this.id,
      required this.userUid,
      required this.email,
      required this.name,
      required this.phoneNumber});

  factory _$ContactEntityImpl.fromJson(Map<String, dynamic> json) =>
      _$$ContactEntityImplFromJson(json);

  @override
  final int id;
  @override
  final String userUid;
  @override
  final String? email;
  @override
  final String name;
  @override
  final String? phoneNumber;

  @override
  String toString() {
    return 'ContactEntity(id: $id, userUid: $userUid, email: $email, name: $name, phoneNumber: $phoneNumber)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ContactEntityImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userUid, userUid) || other.userUid == userUid) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.phoneNumber, phoneNumber) ||
                other.phoneNumber == phoneNumber));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, userUid, email, name, phoneNumber);

  /// Create a copy of ContactEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ContactEntityImplCopyWith<_$ContactEntityImpl> get copyWith =>
      __$$ContactEntityImplCopyWithImpl<_$ContactEntityImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ContactEntityImplToJson(
      this,
    );
  }
}

abstract class _ContactEntity implements ContactEntity {
  const factory _ContactEntity(
      {required final int id,
      required final String userUid,
      required final String? email,
      required final String name,
      required final String? phoneNumber}) = _$ContactEntityImpl;

  factory _ContactEntity.fromJson(Map<String, dynamic> json) =
      _$ContactEntityImpl.fromJson;

  @override
  int get id;
  @override
  String get userUid;
  @override
  String? get email;
  @override
  String get name;
  @override
  String? get phoneNumber;

  /// Create a copy of ContactEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ContactEntityImplCopyWith<_$ContactEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
