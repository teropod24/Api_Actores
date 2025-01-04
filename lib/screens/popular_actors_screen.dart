import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movies/api/api.dart';
import 'package:movies/api/api_service.dart';
import 'package:movies/models/actors.dart';
import 'package:movies/screens/details_screen.dart';
import 'package:movies/models/movie.dart';
import 'package:movies/controllers/movies_controller.dart';

class PopularActorsScreen extends StatelessWidget {
  final int actorId;

  const PopularActorsScreen({
    Key? key,
    required this.actorId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              // Header con botón de volver y título
              Padding(
                padding: const EdgeInsets.only(left: 24, right: 24, top: 34),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      tooltip: 'Back to home',
                      onPressed: () => Get.back(),
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                      ),
                    ),
                    const Text(
                      'Actor Detail',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 24,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              // Imagen y nombre del actor
              SizedBox(
                height: 330,
                child: Stack(
                  children: [
                    FutureBuilder<Actor?>(
                      future: ApiService.getActorDetailsById(actorId),
                      builder: (_, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }

                        if (snapshot.hasData) {
                          final actor = snapshot.data!; // Obtener el actor
                          return SizedBox(
                            height: 330,
                            child: Stack(
                              children: [
                                // Contenedor para la imagen de fondo o cualquier otro contenido
                                ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(16),
                                    bottomRight: Radius.circular(16),
                                  ),
                                  child: Image.network(
                                    Api.imageBaseUrl + actor.profilePath,
                                    width: Get.width,
                                    height: 250,
                                    fit: BoxFit.cover,
                                    loadingBuilder: (_, __, ___) {
                                      if (___ == null) return __;
                                      return FadeShimmer(
                                        width: Get.width,
                                        height: 250,
                                        highlightColor: const Color(0xff22272f),
                                        baseColor: const Color(0xff20252d),
                                      );
                                    },
                                    errorBuilder: (_, __, ___) => const Align(
                                      alignment: Alignment.center,
                                      child: Icon(
                                        Icons.broken_image,
                                        size: 250,
                                      ),
                                    ),
                                  ),
                                ),
                                // Aquí colocamos el IconButton en la parte superior derecha
                                Positioned(
                                  top:
                                      30, // Ajusta esta posición según sea necesario
                                  right:
                                      24, // Ajusta el margen para alejar el botón de los bordes
                                  child: IconButton(
                                    tooltip: 'Save this actor to your list',
                                    onPressed: () {
                                      // Llamar al controlador para guardar al actor
                                      Get.find<MoviesController>()
                                          .addToActorList(actor);
                                    },
                                    icon: Obx(() {
                                      // Aquí verificamos si el actor está en la lista
                                      final isSaved =
                                          Get.find<MoviesController>()
                                              .isActorInList(actor);
                                      return Icon(
                                        isSaved
                                            ? Icons.bookmark
                                            : Icons
                                                .bookmark_outline, // Cambiar el icono dependiendo del estado
                                        color: Colors.white,
                                        size: 33,
                                      );
                                    }),
                                  ),
                                ),
                                // Aquí puedes agregar más elementos encima de la imagen o en la parte inferior
                                Positioned(
                                  top:
                                      255, // Ajusta la posición para el nombre del actor
                                  left: 155,
                                  child: SizedBox(
                                    width: 230,
                                    child: Text(
                                      actor.name,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }

                        return const SizedBox(); // Si no se ha cargado el actor, no mostramos nada
                      },
                    ),
                    Positioned(
                      top: 255,
                      left: 155,
                      child: SizedBox(
                        width: 230,
                        child: FutureBuilder<Actor?>(
                          future: ApiService.getActorDetailsById(actorId),
                          builder: (_, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }

                            if (snapshot.hasData) {
                              final actor = snapshot.data!;
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    actor.name,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  // Mostrar rating si está disponible
                                  if (actor.knownForDepartment != null)
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 3),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(16),
                                        color: const Color.fromRGBO(
                                            37, 40, 54, 0.52),
                                      ),
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                            size: 18,
                                          ),
                                          const SizedBox(width: 5),
                                          Text(
                                            actor.knownForDepartment ??
                                                'No rating',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w400,
                                              color: Color(0xFFFF8700),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                ],
                              );
                            }
                            return const Text('No name available');
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),
              Padding(
                padding: const EdgeInsets.all(24),
                child: DefaultTabController(
                  length: 3,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const TabBar(
                        indicatorWeight: 4,
                        indicatorSize: TabBarIndicatorSize.label,
                        indicatorColor: Color.fromARGB(255, 255, 255, 255),
                        tabs: [
                          Tab(text: 'About Actor'),
                          Tab(text: 'Movies'),
                        ],
                      ),
                      SizedBox(
                        height: 400,
                        child: TabBarView(
                          children: [
                            // About Actor Tab
                            FutureBuilder<Actor?>(
                              future: ApiService.getActorDetailsById(actorId),
                              builder: (_, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                }

                                if (snapshot.hasData) {
                                  final actor = snapshot.data!;
                                  return SingleChildScrollView(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Nombre
                                        Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Text(
                                            'Nombre: ${actor.name}',
                                            style: const TextStyle(
                                              fontSize: 24,
                                            ),
                                          ),
                                        ),
                                        const Divider(
                                            color: Colors.grey, thickness: 1),
                                        Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Text(
                                            'Date: ${actor.dateOfBirth?.isEmpty ?? true ? 'No biography available' : actor.dateOfBirth!}',
                                            style: const TextStyle(
                                              fontSize: 24,
                                            ),
                                          ),
                                        ),
                                        const Divider(
                                            color: Colors.grey, thickness: 1),
                                        Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Text(
                                            'Gender: ${actor.gender}',
                                            style: const TextStyle(
                                              fontSize: 24,
                                            ),
                                          ),
                                        ),
                                        const Divider(
                                            color: Colors.grey, thickness: 1),
                                        Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Text(
                                            'Department: ${actor.knownForDepartment}',
                                            style: const TextStyle(
                                              fontSize: 24,
                                            ),
                                          ),
                                        ),
                                        const Divider(
                                            color: Colors.grey, thickness: 1),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16.0, vertical: 8.0),
                                          child: Text(
                                            'Biography: ${actor.biography?.isEmpty ?? true ? 'No biography available' : actor.biography!}',
                                            style: const TextStyle(
                                              fontSize: 24,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }

                                return const Center(
                                    child: Text('Error loading actor details'));
                              },
                            ),

                            FutureBuilder<List<Movie>?>(
                              future: ApiService.getActorMovies(actorId),
                              builder: (_, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                }

                                if (snapshot.hasData) {
                                  return snapshot.data!.isEmpty
                                      ? const Center(
                                          child: Text('No movies found'))
                                      : ListView.builder(
                                          itemCount: snapshot.data!.length,
                                          itemBuilder: (_, index) {
                                            final movie = snapshot.data![index];
                                            return ListTile(
                                              leading: movie.posterPath !=
                                                          null &&
                                                      movie.posterPath!
                                                          .isNotEmpty
                                                  ? ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                      child: Image.network(
                                                        Api.imageBaseUrl +
                                                            movie.posterPath!,
                                                        width:
                                                            50, // Ajusta el tamaño de la imagen según tu preferencia
                                                        height: 75,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    )
                                                  : const Icon(Icons.movie,
                                                      size:
                                                          50), // Icono en caso de no tener imagen
                                              title: Text(
                                                movie.title.isNotEmpty
                                                    ? movie.title
                                                    : 'No title available', // Si no hay título, muestra un texto por defecto
                                                style: const TextStyle(
                                                    color: Colors
                                                        .white), // Para que el texto sea blanco
                                              ),
                                              subtitle: Text(
                                                movie.releaseDate ??
                                                    'No release date available', // Si no hay fecha, muestra un texto por defecto
                                                style: const TextStyle(
                                                    color: Colors
                                                        .white), // Para que el texto sea blanco
                                              ),
                                              onTap: () {
                                                Get.to(() => DetailsScreen(
                                                    movie:
                                                        movie)); // Navega a la pantalla de detalles de la película
                                              },
                                            );
                                          },
                                        );
                                }

                                return const Center(
                                    child: Text('Error loading movies'));
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
