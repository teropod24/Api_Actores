import 'dart:convert';

class Movie {
  int id;
  String title;
  String posterPath;
  String backdropPath;
  String overview;
  String releaseDate;
  double voteAverage;
  List<int> genreIds;
  Movie({
    required this.id,
    required this.title,
    required this.posterPath,
    required this.backdropPath,
    required this.overview,
    required this.releaseDate,
    required this.voteAverage,
    required this.genreIds,
  });

  factory Movie.fromMap(Map<String, dynamic> map) {
    if (!map.containsKey('id') || !map.containsKey('title')) {
      throw Exception("Invalid movie data");
    }
    return Movie(
      id: map['id'] ?? 0,
      title: map['title'] ?? 'Unknown',
      posterPath: map['poster_path'] ?? '',
      backdropPath: map['backdrop_path'] ?? '',
      overview: map['overview'] ?? 'No overview available.',
      releaseDate: map['release_date'] ?? 'Unknown',
      voteAverage: map['vote_average']?.toDouble() ?? 0.0,
      genreIds:
          map['genre_ids'] != null ? List<int>.from(map['genre_ids']) : [],
    );
  }

  factory Movie.fromJson(String source) => Movie.fromMap(json.decode(source));
}
