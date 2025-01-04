class Actor {
  final int id;
  final String name;
  final String profilePath;
  final String? biography;
  final String? dateOfBirth;
  final String? placeOfBirth;
  final String? gender;
  final String? knownForDepartment;
  final List<String>? movieTitles; // Puedes agregar una lista de títulos de películas
  final String? deathDay; // Para manejar actores que ya no están vivos

  Actor({
    required this.id,
    required this.name,
    required this.profilePath,
    this.biography,
    this.dateOfBirth,
    this.placeOfBirth,
    this.gender,
    this.knownForDepartment,
    this.movieTitles,
    this.deathDay,
  });

  factory Actor.fromJson(Map<String, dynamic> json) {
    return Actor(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'Unknown',
      profilePath: json['profile_path'] ?? '',
      biography: json['biography'] ?? '',
      dateOfBirth: json['birthday'] ?? '',
      placeOfBirth: json['place_of_birth'] ?? '',
      gender: _getGender(json['gender']), // Usamos una función para convertir el número a texto
      knownForDepartment: json['known_for_department'] ?? '',
      movieTitles: json['known_for'] != null
          ? List<String>.from(json['known_for'].map((movie) => movie['title'] ?? ''))
          : null,
      deathDay: json['deathday'] ?? '',
    );
  }

  // Función para convertir el número de género a texto (1 = mujer, 2 = hombre)
  static String? _getGender(int? gender) {
    if (gender == null) return null;
    if (gender == 1) return 'Female';
    if (gender == 2) return 'Male';
    return 'Unknown';
  }
}
