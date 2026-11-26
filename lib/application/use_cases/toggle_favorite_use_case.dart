import '../../domain/repositories/favorites_repository.dart';

class ToggleFavoriteUseCase {
  final FavoritesRepository _repository;

  ToggleFavoriteUseCase(this._repository);

  Future<bool> call(String placeId) async {
    final ids = await _repository.getIds();

    if (ids.contains(placeId)) {
      await _repository.remove(placeId);
      return false;
    }

    await _repository.add(placeId);
    return true;
  }
}
