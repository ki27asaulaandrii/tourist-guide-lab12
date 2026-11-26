import '../../config/app_config.dart';
import '../../domain/entities/place.dart';
import '../../domain/repositories/place_repository.dart';

class InMemoryPlaceRepository implements PlaceRepository {
  static const List<Place> _places = [
    Place(
      id: '1',
      name: 'Фонтан Рошен',
      description: 'Плавучий фонтан на річці Південний Буг у Вінниці зі світломузичним шоу.',
      rating: 4.9,
    ),
    Place(
      id: '2',
      name: 'Кам\'янець-Подільська фортеця',
      description: 'Середньовічна фортеця на високому березі річки Смотрич.',
      rating: 4.9,
    ),
    Place(
      id: '3',
      name: 'Софійський собор',
      description: 'Православний собор XI століття в центрі Києва, пам\'ятка ЮНЕСКО.',
      rating: 4.8,
    ),
    Place(
      id: '4',
      name: 'Площа Ринок',
      description: 'Історична площа у центрі Львова з ратушею.',
      rating: 4.7,
    ),
    Place(
      id: '5',
      name: 'Дендропарк Софіївка',
      description: 'Дендрологічний парк в Умані з озерами, фонтанами і скульптурами.',
      rating: 4.9,
    ),
  ];

  @override
  Future<List<Place>> getAll() async {
    await Future.delayed(const Duration(milliseconds: AppConfig.loadDelayMs));
    return List.of(_places);
  }
}
