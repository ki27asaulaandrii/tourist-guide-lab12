import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tourist_guide/application/use_cases/toggle_favorite_use_case.dart';
import 'package:tourist_guide/domain/repositories/favorites_repository.dart';

class MockFavoritesRepository extends Mock implements FavoritesRepository {}

void main() {
  late MockFavoritesRepository repository;
  late ToggleFavoriteUseCase useCase;

  setUp(() {
    repository = MockFavoritesRepository();
    useCase = ToggleFavoriteUseCase(repository);
    when(() => repository.add(any())).thenAnswer((_) async {});
    when(() => repository.remove(any())).thenAnswer((_) async {});
  });

  test('додає місце, якого немає в обраному, і повертає true', () async {
    when(() => repository.getIds()).thenAnswer((_) async => <String>{});

    final result = await useCase('1');

    expect(result, isTrue);
    verify(() => repository.add('1')).called(1);
    verifyNever(() => repository.remove(any()));
  });

  test('прибирає місце, яке вже в обраному, і повертає false', () async {
    when(() => repository.getIds()).thenAnswer((_) async => {'1', '2'});

    final result = await useCase('1');

    expect(result, isFalse);
    verify(() => repository.remove('1')).called(1);
    verifyNever(() => repository.add(any()));
  });

  test('не чіпає інші місця в обраному', () async {
    when(() => repository.getIds()).thenAnswer((_) async => {'2'});

    await useCase('1');

    verify(() => repository.add('1')).called(1);
    verifyNever(() => repository.remove('2'));
  });

  test('передає помилку репозиторію далі', () async {
    when(() => repository.getIds()).thenThrow(Exception('збій'));

    expect(() => useCase('1'), throwsException);
  });
}
