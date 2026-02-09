import 'package:coffee_repository/coffee_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:mocktail/mocktail.dart';

class MockCoffeeBox extends Mock implements Box<CoffeeModel> {}

void main() {
  group('CoffeeLocalDataSource', () {
    late Box<CoffeeModel> coffeeBox;
    late CoffeeLocalDataSource localDataSource;

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
  });
}
