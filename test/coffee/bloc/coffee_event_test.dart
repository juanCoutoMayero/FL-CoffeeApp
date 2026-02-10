import 'package:coffee_app/coffee/bloc/bloc.dart';
import 'package:coffee_repository/coffee_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CoffeeEvent', () {
    group('CoffeeFetchRequested', () {
      test('supports value equality', () {
        expect(
          const CoffeeFetchRequested(),
          equals(const CoffeeFetchRequested()),
        );
      });

      test('props are empty', () {
        expect(const CoffeeFetchRequested().props, isEmpty);
      });
    });

    group('CoffeeFavoriteToggled', () {
      const coffee = Coffee(file: 'test.jpg');

      test('supports value equality', () {
        expect(
          const CoffeeFavoriteToggled(coffee),
          equals(const CoffeeFavoriteToggled(coffee)),
        );
      });

      test('props contain coffee', () {
        expect(
          const CoffeeFavoriteToggled(coffee).props,
          equals([coffee]),
        );
      });
    });

    group('CoffeeFavoritesSubscriptionRequested', () {
      test('supports value equality', () {
        expect(
          const CoffeeFavoritesSubscriptionRequested(),
          equals(const CoffeeFavoritesSubscriptionRequested()),
        );
      });

      test('props are empty', () {
        expect(const CoffeeFavoritesSubscriptionRequested().props, isEmpty);
      });
    });

    group('CoffeeSaveStatusReset', () {
      test('supports value equality', () {
        expect(
          const CoffeeSaveStatusReset(),
          equals(const CoffeeSaveStatusReset()),
        );
      });

      test('props are empty', () {
        expect(const CoffeeSaveStatusReset().props, isEmpty);
      });
    });

    group('CoffeeSelected', () {
      const coffee = Coffee(file: 'selected.jpg');

      test('supports value equality', () {
        expect(
          const CoffeeSelected(coffee),
          equals(const CoffeeSelected(coffee)),
        );
      });

      test('props contain coffee', () {
        expect(
          const CoffeeSelected(coffee).props,
          equals([coffee]),
        );
      });
    });
  });
}
