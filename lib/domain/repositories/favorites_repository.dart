abstract class FavoritesRepository {
  Future<Set<String>> getIds();

  Future<void> add(String placeId);

  Future<void> remove(String placeId);
}
