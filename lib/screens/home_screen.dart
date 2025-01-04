import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movies/api/api.dart';
import 'package:movies/api/api_service.dart';
import 'package:movies/controllers/bottom_navigator_controller.dart';
import 'package:movies/controllers/movies_controller.dart';
import 'package:movies/controllers/search_controller.dart';
import 'package:movies/widgets/search_box.dart';
import 'package:movies/widgets/tab_builder.dart';
import '../screens/popular_actors_screen.dart';
import 'package:movies/controllers/actors_controller.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final MoviesController controller = Get.put(MoviesController());
  final SearchController1 searchController = Get.put(SearchController1());
  final ActorsController actorsController = Get.put(ActorsController());
  final ScrollController _scrollController =
      ScrollController(); // Controlador para el desplazamiento

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'What do you want to watch?',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 24),
            ),
            const SizedBox(height: 16),
            SearchBox(
              onSumbit: () {
                String search =
                    Get.find<SearchController1>().searchController.text;
                Get.find<SearchController1>().searchController.text = '';
                Get.find<SearchController1>().search(search);
                Get.find<BottomNavigatorController>().setIndex(1);
                FocusManager.instance.primaryFocus?.unfocus();
              },
            ),
            const SizedBox(height: 24),
            // Lista de actores gestionada por ActorsController
            Obx(() {
              if (actorsController.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              if (actorsController.actorsList.isEmpty) {
                return const Center(child: Text('No actors available'));
              }

              return SizedBox(
                height: 300, // Espacio suficiente para la lista de actores
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios),
                      onPressed: () {
                        _scrollController.animateTo(
                          _scrollController.position.pixels - 200,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        controller: _scrollController,
                        scrollDirection:
                            Axis.horizontal, // Desplazamiento horizontal
                        child: Row(
                          children: actorsController.actorsList.map((actor) {
                            return GestureDetector(
                              onTap: () {
                                // Navega a la pantalla de detalles del actor
                                Get.to(() =>
                                    PopularActorsScreen(actorId: actor.id));
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    right: 16), // Espaciado entre los actores
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(16),
                                      child: Image.network(
                                        actor.profilePath.isNotEmpty
                                            ? Api.imageBaseUrl +
                                                actor.profilePath
                                            : 'https://via.placeholder.com/150',
                                        height: 200,
                                        width: 140,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) =>
                                            const Icon(Icons.broken_image),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    SizedBox(
                                      width: 140,
                                      child: Text(
                                        actor.name,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_forward_ios),
                      onPressed: () {
                        _scrollController.animateTo(
                          _scrollController.position.pixels + 200,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 16),
            DefaultTabController(
              length: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const TabBar(
                    indicatorWeight: 3,
                    indicatorColor: Color(0xFF3A3F47),
                    labelStyle: TextStyle(fontSize: 11.0),
                    tabs: [
                      Tab(text: 'Now playing'),
                      Tab(text: 'Upcoming'),
                      Tab(text: 'Top rated'),
                      Tab(text: 'Popular'),
                    ],
                  ),
                  SizedBox(
                    height: 400,
                    child: TabBarView(
                      children: [
                        TabBuilder(
                          future: ApiService.getCustomMovies(
                              'now_playing?api_key=${Api.apiKey}&language=en-US&page=1'),
                        ),
                        TabBuilder(
                          future: ApiService.getCustomMovies(
                              'upcoming?api_key=${Api.apiKey}&language=en-US&page=1'),
                        ),
                        TabBuilder(
                          future: ApiService.getCustomMovies(
                              'top_rated?api_key=${Api.apiKey}&language=en-US&page=1'),
                        ),
                        TabBuilder(
                          future: ApiService.getCustomMovies(
                              'popular?api_key=${Api.apiKey}&language=en-US&page=1'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
