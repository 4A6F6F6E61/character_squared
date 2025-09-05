import 'dart:convert';
import 'dart:developer' as dev;

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

enum ImageQuality { high, low }

enum Gender { male, female, other }

Gender fromInt(int g) {
  if (g == 0) return Gender.male;
  if (g == 1) return Gender.female;
  return Gender.other;
}

class MyTmdb {
  const MyTmdb._();

  static String? imageUrl(String? path, {ImageQuality quality = ImageQuality.low}) {
    if (path == null || path.isEmpty) {
      return null;
    }
    return switch (quality) {
      ImageQuality.high => "https://media.themoviedb.org/t/p/w220_and_h330_face$path",
      ImageQuality.low => "https://media.themoviedb.org/t/p/w300_and_h450_bestv2$path",
    };
  }
}

class Genre {
  // TODO:
}

class CastOrCrew {
  final int id;
  final String name;
  final String originalName;
  final String? _posterPath;
  final String? character;
  String? get posterUrl => MyTmdb.imageUrl(_posterPath);
  final bool adult;
  final Gender gender;
  final String knownForDepartment;
  final String? job;

  const CastOrCrew({
    required this.id,
    required this.name,
    required this.originalName,
    String? posterPath,
    this.character,
    required this.adult,
    required this.gender,
    required this.knownForDepartment,
    this.job,
  }) : _posterPath = posterPath;
}

class Movie {
  late final int id;
  late final bool adult;
  late final String title;
  late final String originalTitle;
  late final String overview;
  late final String? backdropUrl;
  late final String? _posterPath;
  String? get posterUrlHigh => MyTmdb.imageUrl(_posterPath, quality: ImageQuality.high);
  String? get posterUrlLow => MyTmdb.imageUrl(_posterPath, quality: ImageQuality.low);
  late final List<Genre> genre;
  late final String language;
  late final DateTime release;
  late final double voteAverage;
  late final int voteCount;
  List<CastOrCrew> cast = [];
  List<CastOrCrew> crew = [];

  // Helper for getting the director since that's fairly common
  CastOrCrew? get director {
    try {
      return crew.firstWhere((person) => person.job == 'Director');
    } catch (_) {
      return null;
    }
  }

  Movie._();

  static Future<Movie> fromId(int id) async {
    final movie = Movie._();

    movie.id = id;

    await Future.wait({_loadDetails(movie), _loadCredits(movie)});

    return movie;
  }

  static Future<void> _loadDetails(Movie movie) async {
    final url = Uri.parse('https://api.themoviedb.org/3/movie/${movie.id}');

    final response = await http.get(
      url,
      headers: {
        "accept": 'application/json',
        "Authorization": 'Bearer ${dotenv.env["TMDB_READ_ACCESS_TOKEN"]}',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to load details: ${response.statusCode}');
    }
    final Map<String, dynamic> json = jsonDecode(response.body);
    movie.backdropUrl = MyTmdb.imageUrl(json["backdrop_path"], quality: ImageQuality.high);

    movie.adult = json["adult"];
    movie.title = json["title"];

    movie.originalTitle = json["original_title"];
    movie.overview = json["overview"];
    movie._posterPath = json["poster_path"];
    movie.language = json["original_language"];

    final _ = (json["genre_ids"] as List?)?.map((e) => e as int).toList();
    // TODO: Load the genres

    movie.release = DateTime.parse(json["release_date"]);
    movie.voteAverage = json["vote_average"];
    movie.voteCount = json["vote_count"];

    //TODO: maybe add origin countries
  }

  static Future<void> _loadCredits(Movie movie) async {
    final url = Uri.parse('https://api.themoviedb.org/3/movie/${movie.id}/credits');

    final response = await http.get(
      url,
      headers: {
        "accept": 'application/json',
        "Authorization": 'Bearer ${dotenv.env["TMDB_READ_ACCESS_TOKEN"]}',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to load credits: ${response.statusCode}');
    }
    final Map<String, dynamic> json = jsonDecode(response.body);

    final cast = (json["cast"] ?? []) as List;
    final crew = (json["crew"] ?? []) as List;

    _generateCastOrCrew(movie.cast, cast);
    _generateCastOrCrew(movie.crew, crew);
  }

  static void _generateCastOrCrew(List<CastOrCrew> destList, List jsonList) {
    for (Map<String, dynamic> json in jsonList) {
      try {
        final m = CastOrCrew(
          id: json["id"],
          name: json["name"],
          originalName: json["original_name"],
          adult: json["adult"],
          gender: fromInt(json["gender"] as int),
          knownForDepartment: json["known_for_department"],
          job: json["job"],
        );
        // TODO: Not sure if this even works
        destList.add(m);
      } catch (e) {
        dev.log("Error Adding Cast/Crew Member: $e", name: "GenerateCastOrCrew");
        rethrow;
      }
    }
  }
}
