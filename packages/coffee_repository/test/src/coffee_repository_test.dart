import 'dart:typed_data';

import 'package:coffee_data_sources/coffee_data_sources.dart';
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
      registerFallbackValue(const Coffee(file: 'file'));
      registerFallbackValue(Uint8List(0));
    });

    setUp(() {
      remoteDataSource = MockCoffeeRemoteDataSource();
      localDataSource = MockCoffeeLocalDataSource();
      coffeeRepository = CoffeeRepositoryImpl(
        remoteDataSource: remoteDataSource,
        localDataSource: localDataSource,
      );
    });

    group('getRandomCoffee', () {
      test('calls getRandomCoffee on remoteDataSource', () async {
        const coffeeModel = CoffeeModel(file: 'file');
        const coffee = Coffee(file: 'file');
        when(() => remoteDataSource.getRandomCoffee())
            .thenAnswer((_) async => coffeeModel);

        expect(await coffeeRepository.getRandomCoffee(), coffee);
        verify(() => remoteDataSource.getRandomCoffee()).called(1);
      });

      test('throws CoffeeRequestFailure when remoteDataSource throws',
          () async {
        final exception = Exception('oops');
        when(() => remoteDataSource.getRandomCoffee()).thenThrow(exception);

        expect(
          () => coffeeRepository.getRandomCoffee(),
          throwsA(isA<CoffeeRequestFailure>()),
        );
      });
    });

    group('saveFavorite', () {
      test('downloads image and saves locally', () async {
        const coffee = Coffee(file: 'url');
        final bytes = Uint8List(10);
        const coffeeModel = CoffeeModel(file: 'url', savedDate: null);

        when(() => remoteDataSource.downloadImage(any()))
            .thenAnswer((_) async => bytes);
        when(() => localDataSource.saveFavorite(
              coffee: any(named: 'coffee'),
              imageBytes: any(named: 'imageBytes'),
            )).thenAnswer((_) async => coffeeModel);

        await coffeeRepository.saveFavorite(coffee);

        verify(() => remoteDataSource.downloadImage('url')).called(1);
        verify(() => localDataSource.saveFavorite(
              coffee: any(named: 'coffee'),
              imageBytes: bytes,
            )).called(1);
      });

      test('throws CoffeeRequestFailure when remoteDataSource throws',
          () async {
        const coffee = Coffee(file: 'url');
        final exception = Exception('oops');
        when(() => remoteDataSource.downloadImage(any())).thenThrow(exception);

        expect(
          () => coffeeRepository.saveFavorite(coffee),
          throwsA(isA<CoffeeRequestFailure>()),
        );
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
      test('calls getFavorites on localDataSource and returns entities', () {
        final date1 = DateTime(2023, 1, 1);
        final date2 = DateTime(2023, 1, 2);
        final coffeeModel1 = CoffeeModel(file: 'url1', savedDate: date1);
        final coffeeModel2 = CoffeeModel(file: 'url2', savedDate: date2);

        final coffee1 = Coffee(file: 'url1', savedDate: date1);
        final coffee2 = Coffee(file: 'url2', savedDate: date2);

        when(() => localDataSource.getFavorites())
            .thenReturn([coffeeModel1, coffeeModel2]);

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
