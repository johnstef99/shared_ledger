// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ledger_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

LedgerEntity _$LedgerEntityFromJson(Map<String, dynamic> json) {
  return _LedgerEntity.fromJson(json);
}

/// @nodoc
mixin _$LedgerEntity {
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get userUid => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;

  /// Serializes this LedgerEntity to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LedgerEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LedgerEntityCopyWith<LedgerEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LedgerEntityCopyWith<$Res> {
  factory $LedgerEntityCopyWith(
          LedgerEntity value, $Res Function(LedgerEntity) then) =
      _$LedgerEntityCopyWithImpl<$Res, LedgerEntity>;
  @useResult
  $Res call(
      {int id,
      String name,
      String userUid,
      DateTime createdAt,
      String? description});
}

/// @nodoc
class _$LedgerEntityCopyWithImpl<$Res, $Val extends LedgerEntity>
    implements $LedgerEntityCopyWith<$Res> {
  _$LedgerEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LedgerEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? userUid = null,
    Object? createdAt = null,
    Object? description = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      userUid: null == userUid
          ? _value.userUid
          : userUid // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LedgerEntityImplCopyWith<$Res>
    implements $LedgerEntityCopyWith<$Res> {
  factory _$$LedgerEntityImplCopyWith(
          _$LedgerEntityImpl value, $Res Function(_$LedgerEntityImpl) then) =
      __$$LedgerEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String name,
      String userUid,
      DateTime createdAt,
      String? description});
}

/// @nodoc
class __$$LedgerEntityImplCopyWithImpl<$Res>
    extends _$LedgerEntityCopyWithImpl<$Res, _$LedgerEntityImpl>
    implements _$$LedgerEntityImplCopyWith<$Res> {
  __$$LedgerEntityImplCopyWithImpl(
      _$LedgerEntityImpl _value, $Res Function(_$LedgerEntityImpl) _then)
      : super(_value, _then);

  /// Create a copy of LedgerEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? userUid = null,
    Object? createdAt = null,
    Object? description = freezed,
  }) {
    return _then(_$LedgerEntityImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      userUid: null == userUid
          ? _value.userUid
          : userUid // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LedgerEntityImpl implements _LedgerEntity {
  const _$LedgerEntityImpl(
      {required this.id,
      required this.name,
      required this.userUid,
      required this.createdAt,
      required this.description});

  factory _$LedgerEntityImpl.fromJson(Map<String, dynamic> json) =>
      _$$LedgerEntityImplFromJson(json);

  @override
  final int id;
  @override
  final String name;
  @override
  final String userUid;
  @override
  final DateTime createdAt;
  @override
  final String? description;

  @override
  String toString() {
    return 'LedgerEntity(id: $id, name: $name, userUid: $userUid, createdAt: $createdAt, description: $description)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LedgerEntityImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.userUid, userUid) || other.userUid == userUid) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.description, description) ||
                other.description == description));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, name, userUid, createdAt, description);

  /// Create a copy of LedgerEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LedgerEntityImplCopyWith<_$LedgerEntityImpl> get copyWith =>
      __$$LedgerEntityImplCopyWithImpl<_$LedgerEntityImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LedgerEntityImplToJson(
      this,
    );
  }
}

abstract class _LedgerEntity implements LedgerEntity {
  const factory _LedgerEntity(
      {required final int id,
      required final String name,
      required final String userUid,
      required final DateTime createdAt,
      required final String? description}) = _$LedgerEntityImpl;

  factory _LedgerEntity.fromJson(Map<String, dynamic> json) =
      _$LedgerEntityImpl.fromJson;

  @override
  int get id;
  @override
  String get name;
  @override
  String get userUid;
  @override
  DateTime get createdAt;
  @override
  String? get description;

  /// Create a copy of LedgerEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LedgerEntityImplCopyWith<_$LedgerEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
