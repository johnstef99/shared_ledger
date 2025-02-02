// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ledger_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Ledger _$LedgerFromJson(Map<String, dynamic> json) {
  return _Ledger.fromJson(json);
}

/// @nodoc
mixin _$Ledger {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  DateTime get created => throw _privateConstructorUsedError;
  bool get isShared => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;

  /// Serializes this Ledger to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Ledger
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LedgerCopyWith<Ledger> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LedgerCopyWith<$Res> {
  factory $LedgerCopyWith(Ledger value, $Res Function(Ledger) then) =
      _$LedgerCopyWithImpl<$Res, Ledger>;
  @useResult
  $Res call(
      {String id,
      String name,
      DateTime created,
      bool isShared,
      String? description});
}

/// @nodoc
class _$LedgerCopyWithImpl<$Res, $Val extends Ledger>
    implements $LedgerCopyWith<$Res> {
  _$LedgerCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Ledger
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? created = null,
    Object? isShared = null,
    Object? description = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      created: null == created
          ? _value.created
          : created // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isShared: null == isShared
          ? _value.isShared
          : isShared // ignore: cast_nullable_to_non_nullable
              as bool,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LedgerImplCopyWith<$Res> implements $LedgerCopyWith<$Res> {
  factory _$$LedgerImplCopyWith(
          _$LedgerImpl value, $Res Function(_$LedgerImpl) then) =
      __$$LedgerImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      DateTime created,
      bool isShared,
      String? description});
}

/// @nodoc
class __$$LedgerImplCopyWithImpl<$Res>
    extends _$LedgerCopyWithImpl<$Res, _$LedgerImpl>
    implements _$$LedgerImplCopyWith<$Res> {
  __$$LedgerImplCopyWithImpl(
      _$LedgerImpl _value, $Res Function(_$LedgerImpl) _then)
      : super(_value, _then);

  /// Create a copy of Ledger
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? created = null,
    Object? isShared = null,
    Object? description = freezed,
  }) {
    return _then(_$LedgerImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      created: null == created
          ? _value.created
          : created // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isShared: null == isShared
          ? _value.isShared
          : isShared // ignore: cast_nullable_to_non_nullable
              as bool,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LedgerImpl implements _Ledger {
  const _$LedgerImpl(
      {required this.id,
      required this.name,
      required this.created,
      required this.isShared,
      required this.description});

  factory _$LedgerImpl.fromJson(Map<String, dynamic> json) =>
      _$$LedgerImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final DateTime created;
  @override
  final bool isShared;
  @override
  final String? description;

  @override
  String toString() {
    return 'Ledger(id: $id, name: $name, created: $created, isShared: $isShared, description: $description)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LedgerImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.created, created) || other.created == created) &&
            (identical(other.isShared, isShared) ||
                other.isShared == isShared) &&
            (identical(other.description, description) ||
                other.description == description));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, name, created, isShared, description);

  /// Create a copy of Ledger
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LedgerImplCopyWith<_$LedgerImpl> get copyWith =>
      __$$LedgerImplCopyWithImpl<_$LedgerImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LedgerImplToJson(
      this,
    );
  }
}

abstract class _Ledger implements Ledger {
  const factory _Ledger(
      {required final String id,
      required final String name,
      required final DateTime created,
      required final bool isShared,
      required final String? description}) = _$LedgerImpl;

  factory _Ledger.fromJson(Map<String, dynamic> json) = _$LedgerImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  DateTime get created;
  @override
  bool get isShared;
  @override
  String? get description;

  /// Create a copy of Ledger
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LedgerImplCopyWith<_$LedgerImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
