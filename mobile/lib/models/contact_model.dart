import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_ledger/entities/contact_entity.dart';

part 'contact_model.freezed.dart';
part 'contact_model.g.dart';

@freezed
class Contact with _$Contact {
  const Contact._();

  const factory Contact({
    required String id,
    required String? email,
    required String name,
    required String? phoneNumber,
  }) = _Contact;

  factory Contact.fromJson(Map<String, dynamic> json) =>
      _$ContactFromJson(json);

  factory Contact.fromEntity(ContactEntity entity) {
    return Contact(
      id: entity.id,
      email: entity.email,
      name: entity.name,
      phoneNumber: entity.phoneNumber,
    );
  }

  String get displayName => switch (this) {
        _ => name,
      };
}
