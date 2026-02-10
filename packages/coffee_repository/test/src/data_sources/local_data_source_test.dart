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
      registerFallbackValue(const CoffeeModel(file: 'fallback'));
      registerFallbackValue('fallback');
    });

    setUp(() {
      coffeeBox = MockCoffeeBox();
      localDataSource = CoffeeLocalDataSource(
        coffeeBox: coffeeBox,
        storagePath: '/tmp',
      );
    });

    group('getFavorites', () {
      test(
          'returns favorites sorted by savedDate descending with reconstructed paths',
          () {
        final date1 = DateTime(2023, 1, 1);
        final date2 = DateTime(2023, 1, 2);
        final date3 = DateTime(2023, 1, 3);

        final coffee1 = CoffeeModel(
          file: 'url1',
          savedDate: date1,
          localPath: 'image1.jpg',
        );
        final coffee2 = CoffeeModel(
          file: 'url2',
          savedDate: date2,
          localPath: 'image2.jpg',
        );
        final coffee3 = CoffeeModel(
          file: 'url3',
          savedDate: date3,
          localPath: '/old/absolute/path/image3.jpg',
        );

        when(() => coffeeBox.values).thenReturn([coffee1, coffee3, coffee2]);

        final favorites = localDataSource.getFavorites();

        expect(favorites.length, 3);
        expect(favorites[0].localPath, '/tmp/image3.jpg');
        expect(favorites[1].localPath, '/tmp/image2.jpg');
        expect(favorites[2].localPath, '/tmp/image1.jpg');
        expect(favorites[0].savedDate, date3);
      });

      test('handles null savedDate (treats as oldest)', () {
        final date1 = DateTime(2023, 1, 1);
        final coffee1 = CoffeeModel(file: 'url1', savedDate: date1);
        final coffee2 = const CoffeeModel(file: 'url2', savedDate: null);

        when(() => coffeeBox.values).thenReturn([coffee2, coffee1]);

        final favorites = localDataSource.getFavorites();

        expect(favorites, [
          coffee1,
          coffee2,
        ]);
      });
    });

    group('saveFavorite', () {
      test('saves image to disk and puts coffee in box', () async {
        TestWidgetsFlutterBinding.ensureInitialized();
        // Removed path_provider mock as it is no longer used internally

        final coffee = const CoffeeModel(file: 'https://example.com/image.jpg');
        final bytes = Uint8List.fromList([0, 1, 2]);

        // We use a real temporary directory for the file operation test if possible,
        // or mock the file system. But Dart IO File uses real FS.
        // Let's use Directory.systemTemp for the test storage path.
        final tempDir = Directory.systemTemp.createTempSync();
        localDataSource = CoffeeLocalDataSource(
          coffeeBox: coffeeBox,
          storagePath: tempDir.path,
        );

        final file = File('${tempDir.path}/image.jpg');
        if (file.existsSync()) {
          file.deleteSync();
        }

        when(() => coffeeBox.put(any(), any<CoffeeModel>()))
            .thenAnswer((_) async {});

        final savedCoffee = await localDataSource.saveFavorite(
          coffee: coffee,
          imageBytes: bytes,
        );

        // Expect return value to have absolute path
        expect(savedCoffee.localPath, equals('${tempDir.path}/image.jpg'));
        expect(file.existsSync(), isTrue);

        // Expect Hive to receive relative path (filename)
        final captured =
            verify(() => coffeeBox.put('image.jpg', captureAny())).captured;
        final savedToBox = captured.first as CoffeeModel;
        expect(savedToBox.localPath, 'image.jpg');

        if (file.existsSync()) {
          file.deleteSync();
        }
      });
    });

    group('removeFavorite', () {
      test('deletes image from disk and removes coffee from box', () async {
        final tempDir = Directory.systemTemp.createTempSync();
        localDataSource = CoffeeLocalDataSource(
          coffeeBox: coffeeBox,
          storagePath: tempDir.path,
        );

        final file = File('${tempDir.path}/image.jpg');
        file.writeAsBytesSync([0, 1, 2]);

        final coffee = CoffeeModel(
          file: 'https://example.com/image.jpg',
          localPath: 'image.jpg', // Relative path in model
        );

        when(() => coffeeBox.delete('image.jpg')).thenAnswer((_) async {});

        await localDataSource.removeFavorite(coffee);

        expect(file.existsSync(), isFalse);
        verify(() => coffeeBox.delete('image.jpg')).called(1);
      });
    });

    group('isFavorite', () {
      test('returns true when coffee is in box', () {
        when(() => coffeeBox.containsKey(any<String>())).thenReturn(true);

        final isFav =
            localDataSource.isFavorite('https://example.com/image.jpg');

        expect(isFav, isTrue);
        verify(() => coffeeBox.containsKey('image.jpg')).called(1);
      });

      test('returns false when coffee is not in box', () {
        when(() => coffeeBox.containsKey(any<String>())).thenReturn(false);

        final isFav =
            localDataSource.isFavorite('https://example.com/image.jpg');

        expect(isFav, isFalse);
        verify(() => coffeeBox.containsKey('image.jpg')).called(1);
      });
    });
  });
}
