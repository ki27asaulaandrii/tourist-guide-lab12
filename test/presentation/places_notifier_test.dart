import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tourist_guide/application/use_cases/get_favorite_ids_use_case.dart';
import 'package:tourist_guide/application/use_cases/get_places_use_case.dart';
import 'package:tourist_guide/application/use_cases/toggle_favorite_use_case.dart';
import 'package:tourist_guide/domain/entities/place.dart';
import 'package:tourist_guide/domain/repositories/favorites_repository.dart';
import 'package:tourist_guide/domain/repositories/place_repository.dart';
import 'package:tourist_guide/presentation/providers/places_notifier.dart';

class MockPlaceRepository extends Mock implements PlaceRepository {}

class MockFavoritesRepository extends Mock implements FavoritesRepository {}

const _places = [
  Place(id: '1', name: 'Фонтан Рошен', description: 'Опис 1', rating: 4.9),
  Place(id: '2', name: 'Софійський собор', description: 'Опис 2', rating: 4.8),
  Place(id: '3', name: 'Площа Ринок', description: 'Опис 3', rating: 4.7),
];

void main() {
  late MockPlaceRepository placeRepository;
  late MockFavoritesRepository favoritesRepository;
  late PlacesNotifier notifier;
  late Set<String> storedIds;

  setUp(() {
    placeRepository = MockPlaceRepository();
    favoritesRepository = MockFavoritesRepository();
    storedIds = <String>{};

    when(() => placeRepository.getAll()).thenAnswer((_) async => _places);
    when(() => favoritesRepository.getIds())
        .thenAnswer((_) async => Set.of(storedIds));
    when(() => favoritesRepository.add(any())).thenAnswer((inv) async {
      storedIds.add(inv.positionalArguments.first as String);
    });
    when(() => favoritesRepository.remove(any())).thenAnswer((inv) async {
      storedIds.remove(inv.positionalArguments.first as String);
    });

    notifier = PlacesNotifier(
      getPlaces: GetPlacesUseCase(placeRepository),
      getFavoriteIds: GetFavoriteIdsUseCase(favoritesRepository),
      toggleFavorite: ToggleFavoriteUseCase(favoritesRepository),
    );
  });

  group('load', () {
    test('спочатку isLoading = true і список порожній', () {
      expect(notifier.isLoading, isTrue);
      expect(notifier.places, isEmpty);
    });

    test('після завантаження показує місця і вимикає isLoading', () async {
      await notifier.load();

      expect(notifier.isLoading, isFalse);
      expect(notifier.places, _places);
    });

    test('підтягує вже збережені обрані місця', () async {
      storedIds.add('2');

      await notifier.load();

      expect(notifier.isFavorite('2'), isTrue);
      expect(notifier.favorites, [_places[1]]);
    });

    test('сповіщає слухачів один раз', () async {
      var calls = 0;
      notifier.addListener(() => calls++);

      await notifier.load();

      expect(calls, 1);
    });

    test('порожній список місць не ламає стан', () async {
      when(() => placeRepository.getAll()).thenAnswer((_) async => []);

      await notifier.load();

      expect(notifier.places, isEmpty);
      expect(notifier.favorites, isEmpty);
      expect(notifier.isLoading, isFalse);
    });

    test('помилка репозиторію: виняток передається, isLoading лишається true',
        () async {
      when(() => placeRepository.getAll()).thenThrow(Exception('збій'));

      await expectLater(notifier.load(), throwsException);

      // Поточна поведінка: обробки помилки в notifier немає
      expect(notifier.isLoading, isTrue);
    });

    test('places повертає список, який не можна змінити', () async {
      await notifier.load();

      expect(() => notifier.places.add(_places[0]), throwsUnsupportedError);
    });
  });

  group('toggleFavorite', () {
    setUp(() async => notifier.load());

    test('додає місце в обране і сповіщає слухачів', () async {
      var calls = 0;
      notifier.addListener(() => calls++);

      await notifier.toggleFavorite('1');

      expect(notifier.isFavorite('1'), isTrue);
      expect(notifier.favorites, [_places[0]]);
      expect(calls, 1);
      verify(() => favoritesRepository.add('1')).called(1);
    });

    test('повторне натискання прибирає місце з обраного', () async {
      await notifier.toggleFavorite('1');
      await notifier.toggleFavorite('1');

      expect(notifier.isFavorite('1'), isFalse);
      expect(notifier.favorites, isEmpty);
    });

    test('кілька місць зберігають порядок зі списку місць', () async {
      await notifier.toggleFavorite('3');
      await notifier.toggleFavorite('1');

      expect(notifier.favorites, [_places[0], _places[2]]);
    });

    test('усі місця в обраному', () async {
      for (final place in _places) {
        await notifier.toggleFavorite(place.id);
      }

      expect(notifier.favorites.length, _places.length);
    });

    test('помилка репозиторію не змінює стан обраного', () async {
      when(() => favoritesRepository.add(any())).thenThrow(Exception('збій'));

      await expectLater(notifier.toggleFavorite('1'), throwsException);

      expect(notifier.isFavorite('1'), isFalse);
    });
  });
}
