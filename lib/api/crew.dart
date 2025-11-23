import 'package:character_squared/api/tmdb.dart';

class Crew {
  final int id;
  final String name;
  final String originalName;
  final String? _posterPath;
  final String job;
  String? get posterUrl => MyTmdb.imageUrl(_posterPath);
  final bool adult;
  final Gender gender;
  final String knownForDepartment;

  const Crew({
    required this.id,
    required this.name,
    required this.originalName,
    String? posterPath,
    required this.job,
    required this.adult,
    required this.gender,
    required this.knownForDepartment,
  }) : _posterPath = posterPath;
}
