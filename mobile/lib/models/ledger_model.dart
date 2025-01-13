import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_ledger/entities/ledger_entity.dart';

part 'ledger_model.freezed.dart';
part 'ledger_model.g.dart';

@freezed
class Ledger with _$Ledger {

  const factory Ledger({
    required int id,
    required String name,
    required DateTime createdAt,
    required bool isShared,
    required String? description,
  }) = _Ledger;

  factory Ledger.fromJson(Map<String, Object?> json) => _$LedgerFromJson(json);

  factory Ledger.fromEntity(LedgerEntity entity, String userUid) {
    return Ledger(
      id: entity.id,
      name: entity.name,
      createdAt: entity.createdAt,
      isShared: entity.userUid != userUid,
      description: entity.description,
    );
  }
}
