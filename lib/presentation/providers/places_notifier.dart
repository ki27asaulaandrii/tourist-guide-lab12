import 'package:flutter/foundation.dart';

import '../../application/use_cases/get_favorite_ids_use_case.dart';
import '../../application/use_cases/get_places_use_case.dart';
import '../../application/use_cases/toggle_favorite_use_case.dart';
import '../../domain/entities/place.dart';

class PlacesNotifier extends ChangeNotifier {
  final GetPlacesUseCase _getPlaces;
  final GetFavoriteIdsUseCase _getFavoriteIds;
  final ToggleFavoriteUseCase _toggleFavorite;

  PlacesNotifier({
    required GetPlacesUseCase getPlaces,
    required GetFavoriteIdsUseCase getFavoriteIds,
    required ToggleFavoriteUseCase toggleFavorite,
  })  : _getPlaces = getPlaces,
        _getFavoriteIds = getFavoriteIds,
        _toggleFavorite = toggleFavorite;

  List<Place> _places = [];
  Set<String> _favoriteIds = {};
  bool _isLoading = true;

  List<Place> get places => List.unmodifiable(_places);

  List<Place> get favorites =>
      _places.where((place) => _favoriteIds.contains(place.id)).toList();

  bool get isLoading => _isLoading;

  bool isFavorite(String id) => _favoriteIds.contains(id);

  Future<void> load() async {
    _places = await _getPlaces();
    _favoriteIds = await _getFavoriteIds();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> toggleFavorite(String id) async {
    final isNowFavorite = await _toggleFavorite(id);

    if (isNowFavorite) {
      _favoriteIds.add(id);
    } else {
      _favoriteIds.remove(id);
    }
    notifyListeners();
  }
}
