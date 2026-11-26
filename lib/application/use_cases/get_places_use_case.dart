import '../../domain/entities/place.dart';
import '../../domain/repositories/place_repository.dart';

class GetPlacesUseCase {
  final PlaceRepository _repository;

  GetPlacesUseCase(this._repository);

  Future<List<Place>> call() {
    return _repository.getAll();
  }
}
