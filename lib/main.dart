import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'application/use_cases/get_favorite_ids_use_case.dart';
import 'application/use_cases/get_places_use_case.dart';
import 'application/use_cases/toggle_favorite_use_case.dart';
import 'config/app_config.dart';
import 'domain/repositories/favorites_repository.dart';
import 'domain/repositories/place_repository.dart';
import 'infrastructure/repositories/in_memory_favorites_repository.dart';
import 'infrastructure/repositories/in_memory_place_repository.dart';
import 'presentation/providers/places_notifier.dart';
import 'presentation/screens/home_screen.dart';

void main() {
  final PlaceRepository placeRepository = InMemoryPlaceRepository();
  final FavoritesRepository favoritesRepository = InMemoryFavoritesRepository();

  runApp(
    ChangeNotifierProvider(
      create: (_) => PlacesNotifier(
        getPlaces: GetPlacesUseCase(placeRepository),
        getFavoriteIds: GetFavoriteIdsUseCase(favoritesRepository),
        toggleFavorite: ToggleFavoriteUseCase(favoritesRepository),
      )..load(),
      child: const TouristGuideApp(),
    ),
  );
}

class TouristGuideApp extends StatelessWidget {
  const TouristGuideApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConfig.appTitle,
      theme: ThemeData(colorSchemeSeed: Colors.teal, useMaterial3: true),
      home: const HomeScreen(),
    );
  }
}
