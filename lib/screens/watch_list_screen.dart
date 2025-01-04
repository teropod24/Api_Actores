import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movies/api/api.dart';
import 'package:movies/widgets/infos.dart';
import 'package:movies/controllers/bottom_navigator_controller.dart';
import 'package:movies/controllers/movies_controller.dart';
import 'package:movies/screens/details_screen.dart';
import 'package:movies/screens/popular_actors_screen.dart'; // Asegúrate de importar la pantalla para detalles del actor

class WatchList extends StatelessWidget {
  const WatchList({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(34.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      tooltip: 'Back to home',
                      onPressed: () =>
                          Get.find<BottomNavigatorController>().setIndex(0),
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                      ),
                    ),
                    const Text(
                      'Watch list',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 24,
                      ),
                    ),
                    const SizedBox(
                      width: 33,
                      height: 33,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                // Mostrar las películas de la lista de seguimiento
                if (Get.find<MoviesController>().watchListMovies.isNotEmpty)
                  ...Get.find<MoviesController>().watchListMovies.map(
                        (movie) => Column(
                          children: [
                            GestureDetector(
                              onTap: () => Get.to(DetailsScreen(movie: movie)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: Image.network(
                                      Api.imageBaseUrl + movie.posterPath,
                                      height: 180, // Tamaño uniforme
                                      width: 100, // Tamaño uniforme
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) => const Icon(
                                        Icons.broken_image,
                                        size: 180,
                                      ),
                                      loadingBuilder: (_, __, ___) {
                                        if (___ == null) return __;
                                        return const FadeShimmer(
                                          width: 150,
                                          height: 150,
                                          highlightColor: Color(0xff22272f),
                                          baseColor: Color(0xff20252d),
                                        );
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Infos(movie: movie),
                                  IconButton(
                                    icon: const Icon(Icons.remove_circle),
                                    onPressed: () {
                                      Get.find<MoviesController>().removeFromWatchList(movie);
                                    },
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                // Si la lista de películas está vacía, mostrar mensaje
                if (Get.find<MoviesController>().watchListMovies.isEmpty)
                  const Column(
                    children: [
                      SizedBox(height: 200),
                      Text(
                        'No movies in your watch list',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w200,
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 30),
                // Mostrar los actores de la lista de seguimiento
                if (Get.find<MoviesController>().watchListActors.isNotEmpty)
                  ...Get.find<MoviesController>().watchListActors.map(
                        (actor) => Column(
                          children: [
                            GestureDetector(
                              onTap: () => Get.to(PopularActorsScreen(actorId: actor.id)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: Image.network(
                                      Api.imageBaseUrl + actor.profilePath,
                                      height: 180, // Tamaño uniforme
                                      width: 100, // Tamaño uniforme
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) => const Icon(
                                        Icons.broken_image,
                                        size: 180,
                                      ),
                                      loadingBuilder: (_, __, ___) {
                                        if (___ == null) return __;
                                        return const FadeShimmer(
                                          width: 100,
                                          height: 180,
                                          highlightColor: Color(0xff22272f),
                                          baseColor: Color(0xff20252d),
                                        );
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        actor.name,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      Text(
                                        'Department: ${actor.knownForDepartment}',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w300,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.remove_circle),
                                    onPressed: () {
                                      Get.find<MoviesController>().removeFromActorList(actor);
                                    },
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                // Si la lista de actores está vacía, mostrar mensaje
                if (Get.find<MoviesController>().watchListActors.isEmpty)
                  const Column(
                    children: [
                      SizedBox(height: 200),
                      Text(
                        'No actors in your watch list',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w200,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ));
  }
}