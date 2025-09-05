import 'dart:convert';
import 'package:character_squared/api/tmdb.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tmdb_api/tmdb_api.dart';
import 'package:tmdb_api_kit/tmdb_api_kit.dart';

final supabase = Supabase.instance.client;
final auth = supabase.auth;

final tmdbKit = Tmdb(dotenv.env["TMDB_READ_ACCESS_TOKEN"]!);

final tmdbBackup = TMDB(
  ApiKeys(dotenv.env["TMDB_KEY"]!, dotenv.env["TMDB_READ_ACCESS_TOKEN"]!),
  logConfig: ConfigLogger(showLogs: true, showErrorLogs: true),
);

final AuthListener authListener = AuthListener._();

class AuthListener extends ChangeNotifier {
  AuthListener._() {
    auth.onAuthStateChange.listen((_) {
      notifyListeners();
    });
  }
}
