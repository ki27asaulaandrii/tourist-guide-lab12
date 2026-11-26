import '../../domain/repositories/favorites_repository.dart';

class GetFavoriteIdsUseCase {
  final FavoritesRepository _repository;

  GetFavoriteIdsUseCase(this._repository);

  Future<Set<String>> call() {
    return _repository.getIds();
  }
}
