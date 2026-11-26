import 'package:flutter_test/flutter_test.dart';
import 'package:tourist_guide/domain/entities/place.dart';

Place _place({String id = '1', double rating = 4.5}) =>
    Place(id: id, name: 'Назва', description: 'Опис', rating: rating);

void main() {
  group('Place', () {
    test('приймає граничні значення рейтингу 0 і 5', () {
      expect(_place(rating: 0).rating, 0);
      expect(_place(rating: 5).rating, 5);
    });

    test('відхиляє рейтинг нижче 0', () {
      expect(() => _place(rating: -0.1), throwsA(isA<AssertionError>()));
    });

    test('відхиляє рейтинг вище 5', () {
      expect(() => _place(rating: 5.1), throwsA(isA<AssertionError>()));
    });

    test('місця з однаковим id рівні, з різним id ні', () {
      expect(_place(id: '1'), _place(id: '1', rating: 3));
      expect(_place(id: '1') == _place(id: '2'), isFalse);
    });
  });
}
