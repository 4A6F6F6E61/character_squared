import 'package:flutter/widgets.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;
final auth = supabase.auth;

final AuthListener authListener = AuthListener._();

class AuthListener extends ChangeNotifier {
  AuthListener._() {
    auth.onAuthStateChange.listen((_) {
      notifyListeners();
    });
  }
}
