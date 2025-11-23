// ignore_for_file: implementation_imports

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:tmdb_api_kit/tmdb_api_kit.dart';

export 'package:tmdb_api_kit/src/models/movie_summary_model.dart';
export 'package:tmdb_api_kit/src/models/popular_movie_response.dart';

enum ImageQuality { high, low }

enum Gender { male, female, other }

Gender fromInt(int g) {
  if (g == 0) return Gender.male;
  if (g == 1) return Gender.female;
  return Gender.other;
}

class MyTmdb {
  const MyTmdb._();
  static final _backup = Tmdb(dotenv.env["TMDB_READ_ACCESS_TOKEN"]!);

  static String? imageUrl(String? path, {ImageQuality quality = ImageQuality.low}) {
    if (path == null || path.isEmpty) {
      return null;
    }
    return switch (quality) {
      ImageQuality.high => "https://media.themoviedb.org/t/p/w220_and_h330_face$path",
      ImageQuality.low => "https://media.themoviedb.org/t/p/w300_and_h450_bestv2$path",
    };
  }

  // TODO: Implement my own logic instead of using this
  static final searchMovies = _backup.searchMovies;
}
