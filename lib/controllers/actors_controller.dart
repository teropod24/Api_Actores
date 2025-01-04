import 'package:get/get.dart';
import 'package:movies/api/api_service.dart';
import 'package:movies/models/actors.dart';

class ActorsController extends GetxController {
  var isLoading = true.obs;
  var actorsList = <Actor>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchPopularActors();
  }

  Future<void> fetchPopularActors() async {
    try {
      isLoading(true);
      final actors = await ApiService.getPopularActors();
      actorsList.assignAll(actors);
    } finally {
      isLoading(false);
    }
  }
}
