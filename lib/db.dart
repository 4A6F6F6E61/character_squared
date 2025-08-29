import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tmdb_api/tmdb_api.dart';
import 'package:tmdb_api_kit/tmdb_api_kit.dart';

final supabase = Supabase.instance.client;
final auth = supabase.auth;

final tmdb = Tmdb(dotenv.env["TMDB_READ_ACCESS_TOKEN"]!);

final tmdbBackup = TMDB(
  ApiKeys(dotenv.env["TMDB_KEY"]!, dotenv.env["TMDB_READ_ACCESS_TOKEN"]!),
  logConfig: ConfigLogger(showLogs: true, showErrorLogs: true),
);

enum ImageQuality { high, low }

String imageUrl(String path, {ImageQuality quality = ImageQuality.low}) => switch (quality) {
  ImageQuality.high => "https://media.themoviedb.org/t/p/w220_and_h330_face$path",
  ImageQuality.low => "https://media.themoviedb.org/t/p/w300_and_h450_bestv2$path",
};

final AuthListener authListener = AuthListener._();

class AuthListener extends ChangeNotifier {
  AuthListener._() {
    auth.onAuthStateChange.listen((_) {
      notifyListeners();
    });
  }
}
