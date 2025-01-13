import 'package:supabase_flutter/supabase_flutter.dart' as supa;

class User {
  final String uid;
  final String email;

  const User({required this.uid, required this.email});

  const User.empty()
      : uid = '',
        email = '';

  static User fromSupabaseUser(supa.User user) {
    return User(
      uid: user.id,
      email: user.email!,
    );
  }

  bool get isEmpty => uid.isEmpty;

  bool get isNotEmpty => uid.isNotEmpty;
}
