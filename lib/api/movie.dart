import 'dart:convert';
import 'dart:developer' as dev;

import 'package:character_squared/api/cast.dart';
import 'package:character_squared/api/crew.dart';
import 'package:character_squared/api/genre.dart';
import 'package:character_squared/api/tmdb.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

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
  List<Cast> cast = [];
  List<Crew> crew = [];

  // Helper for getting the director since that's fairly common
  Crew? get director {
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

    // TODO: Maybe combine the two, but to be honest is not that much duplicated code
    for (Map<String, dynamic> json in json["cast"] ?? []) {
      try {
        final m = Cast(
          id: json["id"],
          name: json["name"],
          originalName: json["original_name"],
          adult: json["adult"],
          gender: fromInt(json["gender"] as int),
          knownForDepartment: json["known_for_department"],
          character: json["character"],
        );
        movie.cast.add(m);
      } catch (e) {
        dev.log("Error Adding Cast Member: $e", name: "_loadCredits");
        rethrow;
      }
    }

    for (Map<String, dynamic> json in json["crew"] ?? []) {
      try {
        final m = Crew(
          id: json["id"],
          name: json["name"],
          originalName: json["original_name"],
          adult: json["adult"],
          gender: fromInt(json["gender"] as int),
          knownForDepartment: json["known_for_department"],
          job: json["job"],
        );
        movie.crew.add(m);
      } catch (e) {
        dev.log("Error Adding Crew Member: $e", name: "_loadCredits");
        rethrow;
      }
    }
  }
}
