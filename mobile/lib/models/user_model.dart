import 'package:pocketbase/pocketbase.dart';

class User {
  final String id;
  final String email;

  const User({required this.id, required this.email});

  const User.empty()
      : id = '',
        email = '';

  // static User fromSupabaseUser(supa.User user) {
  //   return User(
  //     uid: user.id,
  //     email: user.email!,
  //   );
  // }

  bool get isEmpty => id.isEmpty;

  bool get isNotEmpty => id.isNotEmpty;

  static User fromRecord(RecordModel record, {String? avatar}) {
    return User(
      id: record.id,
      email: record.getStringValue('email'),
    );
  }
}
