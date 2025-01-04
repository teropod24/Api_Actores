import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:movies/api/api.dart';
import 'package:movies/models/actors.dart';
import 'package:movies/models/movie.dart';
import 'package:movies/models/review.dart';
import 'package:movies/api/api_end_points.dart';

class ApiService {
  // En ApiService
  static Future<List<Actor>> getPopularActors() async {
    final url = Uri.parse(
        '${Api.baseUrl}${ApiEndPoints.getActors}?api_key=${Api.apiKey}&language=en-US&page=1');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data == null || data['results'] == null) {
        throw Exception('Empty or invalid data received');
      }
      final actors = (data['results'] as List)
          .map((actor) => Actor.fromJson(actor))
          .toList();
      return actors;
    } else {
      throw Exception(
          'Failed to load data. Status code: ${response.statusCode}');
    }
  }

  static Future<List<Actor>> getMovieCast(int movieId) async {
    try {
      final url = Uri.parse(
          '${Api.baseUrl}movie/$movieId/credits?api_key=${Api.apiKey}');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final cast = (data['cast'] as List)
            .map((actor) => Actor.fromJson(actor))
            .toList();
        return cast;
      } else {
        throw Exception('Failed to load movie cast');
      }
    } catch (e) {
      print('Error while fetching cast: $e');
      throw Exception('Failed to load movie cast');
    }
  }

  static Future<Actor> getActorDetailsById(int actorId) async {
    final url =
        "${Api.baseUrl}person/$actorId?api_key=${Api.apiKey}&language=en-US";

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Actor.fromJson(data);
      } else {
        throw Exception("Failed to load actor details");
      }
    } catch (e) {
      print("Error: $e");
      throw Exception("Failed to fetch actor details");
    }
  }

  static Future<List<Movie>> getTopRatedMovies() async {
    try {
      final response = await http.get(Uri.parse(
          '${Api.baseUrl}${ApiEndPoints.popularMovies}?api_key=${Api.apiKey}&language=en-US&page=1'));
      final res = json.decode(response.body);
      return (res['results'] as List)
          .map((movie) => Movie.fromMap(movie))
          .toList();
    } catch (e) {
      print("Error: $e");
      return []; // Devuelve una lista vacía en lugar de null
    }
  }

  static Future<List<Movie>?> getCustomMovies(String url) async {
    try {
      final response = await http
          .get(Uri.parse('${Api.baseUrl}movie/$url?api_key=${Api.apiKey}'));
      final res = json.decode(response.body);
      return (res['results'] as List)
          .map((movie) => Movie.fromMap(movie))
          .toList();
    } catch (e) {
      print("Error: $e");
      return null;
    }
  }

  static Future<List<Movie>?> getSearchedMovies(String query) async {
    try {
      final response = await http.get(Uri.parse(
          '${Api.baseUrl}search/movie?api_key=${Api.apiKey}&language=en-US&query=$query&page=1&include_adult=false'));
      final res = json.decode(response.body);
      return (res['results'] as List)
          .map((movie) => Movie.fromMap(movie))
          .toList();
    } catch (e) {
      print("Error: $e");
      return null;
    }
  }

  static Future<List<Review>> getMovieReviews(int movieId) async {
    try {
      final response = await http.get(Uri.parse(
          '${Api.baseUrl}movie/$movieId/reviews?api_key=${Api.apiKey}&language=en-US&page=1'));
      final res = json.decode(response.body);
      return (res['results'] as List)
          .map((review) => Review(
                author: review['author'],
                comment: review['content'],
                rating: review['author_details']['rating'],
              ))
          .toList();
    } catch (e) {
      print("Error: $e");
      return []; // Devolver lista vacía en lugar de null
    }
  }

  static Future<List<Movie>> getActorMovies(int actorId) async {
    final url =
        "${Api.baseUrl}person/$actorId/movie_credits?api_key=${Api.apiKey}&language=en-US";

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final movies = (data['cast'] as List)
            .map((movie) => Movie.fromMap(movie))
            .toList();
        return movies;
      } else {
        throw Exception("Failed to load actor movies");
      }
    } catch (e) {
      print("Error: $e");
      throw Exception("Failed to load actor movies");
    }
  }
}
