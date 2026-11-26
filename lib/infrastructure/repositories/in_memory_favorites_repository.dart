import '../../domain/repositories/favorites_repository.dart';

class InMemoryFavoritesRepository implements FavoritesRepository {
  final Set<String> _ids = {};

  @override
  Future<Set<String>> getIds() async {
    return Set.of(_ids);
  }

  @override
  Future<void> add(String placeId) async {
    _ids.add(placeId);
  }

  @override
  Future<void> remove(String placeId) async {
    _ids.remove(placeId);
  }
}
