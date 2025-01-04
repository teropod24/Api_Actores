import 'package:get/get.dart';
import 'package:movies/models/actors.dart';
import 'package:movies/models/movie.dart';

class MoviesController extends GetxController {
  var isLoading = true.obs;
  var watchListMovies = <Movie>[].obs;
  var watchListActors = <Actor>[].obs; // Nueva lista para actores

  @override
  void onInit() {
    super.onInit();
  }

  // Método para agregar una película a la lista de seguimiento
  void addToWatchList(Movie movie) {
    if (!watchListMovies.contains(movie)) {
      watchListMovies.add(movie);
    }
  }

  // Método para agregar un actor a la lista de seguimiento
  void addToActorList(Actor actor) {
    if (!watchListActors.contains(actor)) {
      watchListActors.add(actor);
    }
  }

  // Verificar si una película ya está en la lista
  bool isInWatchList(Movie movie) {
    return watchListMovies.contains(movie);
  }

  // Verificar si un actor ya está en la lista
  bool isActorInList(Actor actor) {
    return watchListActors.contains(actor);
  }

  // Eliminar una película de la lista de seguimiento
  void removeFromWatchList(Movie movie) {
    watchListMovies.remove(movie);
  }

  // Eliminar un actor de la lista de seguimiento
  void removeFromActorList(Actor actor) {
    watchListActors.remove(actor);
  }
}
