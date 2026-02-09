import 'dart:typed_data';

import 'package:coffee_repository/coffee_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';

class MockCoffeeRemoteDataSource extends Mock
    implements CoffeeRemoteDataSource {}

class MockCoffeeLocalDataSource extends Mock implements CoffeeLocalDataSource {}

class FakeCoffee extends Fake implements Coffee {}

class FakeCoffeeModel extends Fake implements CoffeeModel {}

void main() {
  group('CoffeeRepository', () {
    late CoffeeRemoteDataSource remoteDataSource;
    late CoffeeLocalDataSource localDataSource;
    late CoffeeRepository coffeeRepository;

    setUpAll(() {
      registerFallbackValue(const CoffeeModel(file: 'file'));
      registerFallbackValue(Uint8List(0));
    });

    setUp(() {
      remoteDataSource = MockCoffeeRemoteDataSource();
      localDataSource = MockCoffeeLocalDataSource();
      coffeeRepository = CoffeeRepository(
        remoteDataSource: remoteDataSource,
        localDataSource: localDataSource,
      );
    });

    group('getRandomCoffee', () {
      test('calls getRandomCoffee on remoteDataSource', () async {
        const coffee = CoffeeModel(file: 'file');
        when(() => remoteDataSource.getRandomCoffee())
            .thenAnswer((_) async => coffee);

        expect(await coffeeRepository.getRandomCoffee(), coffee);
        verify(() => remoteDataSource.getRandomCoffee()).called(1);
      });
    });

    group('saveFavorite', () {
      test('downloads image and saves locally', () async {
        const coffee = Coffee(file: 'url');
        final bytes = Uint8List(10);

        when(() => remoteDataSource.downloadImage(any()))
            .thenAnswer((_) async => bytes);
        when(() => localDataSource.saveFavorite(
              coffee: any(named: 'coffee'),
              imageBytes: any(named: 'imageBytes'),
            )).thenAnswer((_) async => const CoffeeModel(file: 'url'));

        await coffeeRepository.saveFavorite(coffee);

        verify(() => remoteDataSource.downloadImage('url')).called(1);
        verify(() => localDataSource.saveFavorite(
              coffee: any(named: 'coffee'),
              imageBytes: bytes,
            )).called(1);
      });
    });

    group('removeFavorite', () {
      test('calls removeFavorite on localDataSource', () async {
        const coffee = Coffee(file: 'url');
        when(() => localDataSource.removeFavorite(any()))
            .thenAnswer((_) async {});

        await coffeeRepository.removeFavorite(coffee);

        verify(() => localDataSource.removeFavorite(any())).called(1);
      });
    });

    group('getFavorites', () {
      test('calls getFavorites on localDataSource and returns sorted list', () {
        final date1 = DateTime(2023, 1, 1);
        final date2 = DateTime(2023, 1, 2);
        final coffee1 = CoffeeModel(file: 'url1', savedDate: date1);
        final coffee2 = CoffeeModel(file: 'url2', savedDate: date2);

        when(() => localDataSource.getFavorites())
            .thenReturn([coffee1, coffee2]);

        // The repository just forwards the call.
        // The sorting logic now resides in LocalDataSource.getFavorites()
        // but since we are mocking LocalDataSource here, we can only verify forwarding.
        // However, if we want to test REPOSITORY, it just returns strict list.
        // The sorting is implemented in LOCAL DATA SOURCE.
        // So this test file tests REPOSITORY component.
        // Verify repository returns what datasource returns.

        expect(coffeeRepository.getFavorites(), [coffee1, coffee2]);
        verify(() => localDataSource.getFavorites()).called(1);
      });
    });

    group('isFavorite', () {
      test('calls isFavorite on localDataSource', () {
        when(() => localDataSource.isFavorite(any())).thenReturn(true);
        expect(coffeeRepository.isFavorite('url'), isTrue);
        verify(() => localDataSource.isFavorite('url')).called(1);
      });
    });
  });
}
