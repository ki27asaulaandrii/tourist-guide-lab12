import '../entities/place.dart';

abstract class PlaceRepository {
  Future<List<Place>> getAll();
}
