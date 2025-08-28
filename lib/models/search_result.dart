enum MediaType { tv, movie, unknown }

MediaType mediaTypeFrom(String value) {
  switch (value) {
    case "tv":
      return MediaType.tv;
    case "movie":
      return MediaType.movie;
    default:
      return MediaType.unknown;
  }
}

class SearchResult {
  late final bool adult;
  late final String? backdropPath;
  late final int id;
  // On TV shows this will be 'name'
  late final String title;
  // On TV shows this will be 'original_name'
  late final String originalTitle;
  late final String overview;
  late final String posterPath;
  late final MediaType mediaType;
  late final String originalLanguage;
  late final List<int> genreIds;
  late final double popularity;
  // On TV shows this will be 'firstAirDate'
  late final DateTime releaseDate;
  late final bool? video;
  late final double voteAverage;
  late final int voteCount;
  late final List<String>? originCountry;

  SearchResult(Map<String, dynamic> json) {
    adult = json["adult"];
    id = json["id"];
    backdropPath = json["backdrop_path"];
    title = json["name"] ?? json["title"];
    mediaType = mediaTypeFrom(json["media_type"]);
    originalTitle = json["original_name"] ?? json["original_title"];
    overview = json["overview"];
    posterPath = json["poster_path"];
    originalLanguage = json["original_language"];
    genreIds = (json["genre_ids"] as List).map((e) => e as int).toList();
    popularity = json["popularity"];
    releaseDate =
        DateTime.tryParse(json["first_air_date"] ?? "") ?? DateTime.parse(json["release_date"]);
    video = json["video"];
    voteAverage = json["vote_average"];
    voteCount = json["vote_count"];
    originCountry = (json["origin_country"] as List?)?.map((e) => e as String).toList();
  }
}
