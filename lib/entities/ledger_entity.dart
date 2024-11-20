import 'package:freezed_annotation/freezed_annotation.dart';

part 'ledger_entity.freezed.dart';
part 'ledger_entity.g.dart';

@freezed
class LedgerEntity with _$LedgerEntity {
  const factory LedgerEntity({
    required int id,
    required String name,
    required String userUid,
    required DateTime createdAt,
    required String? description,
  }) = _LedgerEntity;

  factory LedgerEntity.fromJson(Map<String, Object?> json) =>
      _$LedgerEntityFromJson(json);
}
