import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tmdb_api/tmdb_api.dart';

final supabase = Supabase.instance.client;
final auth = supabase.auth;

final tmdb = TMDB(
  ApiKeys(dotenv.env["TMDB_KEY"]!, dotenv.env["TMDB_READ_ACCESS_TOKEN"]!),
  logConfig: ConfigLogger(
    showLogs: true, //must be true than only all other logs will be shown
    showErrorLogs: true,
  ),
);

final AuthListener authListener = AuthListener._();

class AuthListener extends ChangeNotifier {
  AuthListener._() {
    auth.onAuthStateChange.listen((_) {
      notifyListeners();
    });
  }
}
