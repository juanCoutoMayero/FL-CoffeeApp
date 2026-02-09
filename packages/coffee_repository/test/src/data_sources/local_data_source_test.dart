import 'dart:io';

import 'package:coffee_repository/coffee_repository.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:mocktail/mocktail.dart';

class MockCoffeeBox extends Mock implements Box<CoffeeModel> {}

void main() {
  group('CoffeeLocalDataSource', () {
    late Box<CoffeeModel> coffeeBox;
    late CoffeeLocalDataSource localDataSource;

    setUpAll(() {
      registerFallbackValue('fallback');
    });

    setUp(() {
      coffeeBox = MockCoffeeBox();
      localDataSource = CoffeeLocalDataSource(coffeeBox: coffeeBox);
    });

    group('getFavorites', () {
      test('returns favorites sorted by savedDate descending', () {
        final date1 = DateTime(2023, 1, 1);
        final date2 = DateTime(2023, 1, 2);
        final date3 = DateTime(2023, 1, 3);

        final coffee1 = CoffeeModel(file: 'url1', savedDate: date1);
        final coffee2 = CoffeeModel(file: 'url2', savedDate: date2);
        final coffee3 = CoffeeModel(file: 'url3', savedDate: date3);

        // Hive returns values in insertion order usually, or random if Map? Box values is Iterable.
        // Let's assume box returns them in mixed order.
        when(() => coffeeBox.values).thenReturn([coffee1, coffee3, coffee2]);

        final favorites = localDataSource.getFavorites();

        expect(favorites, [coffee3, coffee2, coffee1]);
      });

      test('handles null savedDate (treats as oldest)', () {
        final date1 = DateTime(2023, 1, 1);
        final coffee1 = CoffeeModel(file: 'url1', savedDate: date1);
        final coffee2 = const CoffeeModel(file: 'url2', savedDate: null);

        when(() => coffeeBox.values).thenReturn([coffee2, coffee1]);

        final favorites = localDataSource.getFavorites();

        expect(favorites, [coffee1, coffee2]);
      });
    });

    group('saveFavorite', () {
      test('saves image to disk and puts coffee in box', () async {
        TestWidgetsFlutterBinding.ensureInitialized();
        const channel = MethodChannel('plugins.flutter.io/path_provider');
        channel.setMockMethodCallHandler((MethodCall methodCall) async {
          return '.';
        });

        final coffee = const CoffeeModel(file: 'https://example.com/image.jpg');
        final bytes = Uint8List.fromList([0, 1, 2]);

        final directory = Directory.current;
        final file = File('${directory.path}/image.jpg');
        if (file.existsSync()) {
          file.deleteSync();
        }

        when(() => coffeeBox.put(any(), any())).thenAnswer((_) async {});

        final savedCoffee = await localDataSource.saveFavorite(
          coffee: coffee,
          imageBytes: bytes,
        );

        expect(savedCoffee.localPath, equals('${directory.path}/image.jpg'));
        expect(file.existsSync(), isTrue);
        verify(() => coffeeBox.put('image.jpg', savedCoffee)).called(1);

        if (file.existsSync()) {
          file.deleteSync();
        }
      });
    });

    group('removeFavorite', () {
      test('deletes image from disk and removes coffee from box', () async {
        final directory = Directory.current;
        final file = File('${directory.path}/image.jpg');
        file.writeAsBytesSync([0, 1, 2]);

        final coffee = CoffeeModel(
          file: 'https://example.com/image.jpg',
          localPath: file.path,
        );

        when(() => coffeeBox.delete('image.jpg')).thenAnswer((_) async {});

        await localDataSource.removeFavorite(coffee);

        expect(file.existsSync(), isFalse);
        verify(() => coffeeBox.delete('image.jpg')).called(1);
      });
    });

    group('isFavorite', () {
      test('returns true when coffee is in box', () {
        when(() => coffeeBox.containsKey(any())).thenReturn(true);

        final isFav =
            localDataSource.isFavorite('https://example.com/image.jpg');

        expect(isFav, isTrue);
        verify(() => coffeeBox.containsKey('image.jpg')).called(1);
      });

      test('returns false when coffee is not in box', () {
        when(() => coffeeBox.containsKey(any())).thenReturn(false);

        final isFav =
            localDataSource.isFavorite('https://example.com/image.jpg');

        expect(isFav, isFalse);
        verify(() => coffeeBox.containsKey('image.jpg')).called(1);
      });
    });
  });
}
