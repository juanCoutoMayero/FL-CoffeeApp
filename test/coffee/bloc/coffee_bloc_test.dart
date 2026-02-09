import 'package:bloc_test/bloc_test.dart';
import 'package:coffee_app/coffee/bloc/bloc.dart';
import 'package:coffee_repository/coffee_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCoffeeRepository extends Mock implements CoffeeRepository {}

void main() {
  group('CoffeeBloc', () {
    late CoffeeRepository coffeeRepository;

    setUpAll(() {
      registerFallbackValue(const Coffee(file: 'fallback'));
    });

    setUp(() {
      coffeeRepository = MockCoffeeRepository();
      when(() => coffeeRepository.getFavorites()).thenReturn([]);
      when(
        () => coffeeRepository.getFavoritesStream(),
      ).thenAnswer((_) => const Stream.empty());
    });

    test('initial state is correct', () {
      expect(
        CoffeeBloc(coffeeRepository: coffeeRepository).state,
        const CoffeeState(),
      );
    });

    test('initial state has favorites from repository', () {
      when(() => coffeeRepository.getFavorites()).thenReturn([
        const Coffee(file: 'url'),
      ]);
      expect(
        CoffeeBloc(coffeeRepository: coffeeRepository).state,
        const CoffeeState(favorites: [Coffee(file: 'url')]),
      );
    });

    blocTest<CoffeeBloc, CoffeeState>(
      'emits [loading, success] with isFavorite false when fetch requested succeeds',
      setUp: () {
        when(
          () => coffeeRepository.getRandomCoffee(),
        ).thenAnswer((_) async => const Coffee(file: 'url'));
        when(() => coffeeRepository.isFavorite(any())).thenReturn(false);
      },
      build: () => CoffeeBloc(coffeeRepository: coffeeRepository),
      act: (bloc) => bloc.add(const CoffeeFetchRequested()),
      expect: () => [
        const CoffeeState(status: CoffeeStatus.loading),
        const CoffeeState(
          status: CoffeeStatus.success,
          coffee: Coffee(file: 'url'),
          isFavorite: false,
        ),
      ],
    );

    blocTest<CoffeeBloc, CoffeeState>(
      'emits [loading, success] with isFavorite true when fetch requested succeeds and is fav',
      setUp: () {
        when(
          () => coffeeRepository.getRandomCoffee(),
        ).thenAnswer((_) async => const Coffee(file: 'url'));
        when(() => coffeeRepository.isFavorite(any())).thenReturn(true);
      },
      build: () => CoffeeBloc(coffeeRepository: coffeeRepository),
      act: (bloc) => bloc.add(const CoffeeFetchRequested()),
      expect: () => [
        const CoffeeState(status: CoffeeStatus.loading),
        const CoffeeState(
          status: CoffeeStatus.success,
          coffee: Coffee(file: 'url'),
          isFavorite: true,
        ),
      ],
    );

    blocTest<CoffeeBloc, CoffeeState>(
      'emits [loading, failure] when fetch requested fails',
      setUp: () {
        when(() => coffeeRepository.getRandomCoffee()).thenThrow(Exception());
      },
      build: () => CoffeeBloc(coffeeRepository: coffeeRepository),
      act: (bloc) => bloc.add(const CoffeeFetchRequested()),
      expect: () => [
        const CoffeeState(status: CoffeeStatus.loading),
        const CoffeeState(status: CoffeeStatus.failure),
      ],
    );

    blocTest<CoffeeBloc, CoffeeState>(
      'calls saveFavorite and emits isFavorite true and saveStatus success',
      setUp: () {
        when(() => coffeeRepository.isFavorite(any())).thenReturn(false);
        when(
          () => coffeeRepository.saveFavorite(any()),
        ).thenAnswer((_) async {});
      },
      build: () => CoffeeBloc(coffeeRepository: coffeeRepository),
      act: (bloc) => bloc.add(const CoffeeFavoriteToggled(Coffee(file: 'url'))),
      expect: () => [
        const CoffeeState(
          isFavorite: true,
          saveStatus: CoffeeRequestStatus.success,
        ),
      ],
      verify: (_) {
        verify(
          () => coffeeRepository.saveFavorite(const Coffee(file: 'url')),
        ).called(1);
      },
    );

    blocTest<CoffeeBloc, CoffeeState>(
      'resets saveStatus when CoffeeSaveStatusReset is added',
      build: () => CoffeeBloc(coffeeRepository: coffeeRepository),
      seed: () => const CoffeeState(saveStatus: CoffeeRequestStatus.success),
      act: (bloc) => bloc.add(const CoffeeSaveStatusReset()),
      expect: () => [
        const CoffeeState(saveStatus: CoffeeRequestStatus.initial),
      ],
    );

    blocTest<CoffeeBloc, CoffeeState>(
      'calls removeFavorite and emits isFavorite false when coffee is favorite',
      setUp: () {
        when(() => coffeeRepository.isFavorite(any())).thenReturn(true);
        when(
          () => coffeeRepository.removeFavorite(any()),
        ).thenAnswer((_) async {});
      },
      build: () => CoffeeBloc(coffeeRepository: coffeeRepository),
      seed: () =>
          const CoffeeState(isFavorite: true), // Seed with initial state
      act: (bloc) => bloc.add(const CoffeeFavoriteToggled(Coffee(file: 'url'))),
      expect: () => [
        const CoffeeState(isFavorite: false),
      ],
      verify: (_) {
        verify(
          () => coffeeRepository.removeFavorite(const Coffee(file: 'url')),
        ).called(1);
      },
    );
    blocTest<CoffeeBloc, CoffeeState>(
      'emits favorites when repository stream emits new favorites',
      setUp: () {
        when(
          () => coffeeRepository.getFavoritesStream(),
        ).thenAnswer(
          (_) => Stream.value([const Coffee(file: 'url')]),
        );
      },
      build: () => CoffeeBloc(coffeeRepository: coffeeRepository),
      expect: () => [
        const CoffeeState(favorites: [Coffee(file: 'url')]),
      ],
    );

    blocTest<CoffeeBloc, CoffeeState>(
      'emits [success] with selected coffee and isFavorite true when CoffeeSelected is added',
      build: () => CoffeeBloc(coffeeRepository: coffeeRepository),
      act: (bloc) => bloc.add(const CoffeeSelected(Coffee(file: 'url'))),
      expect: () => [
        const CoffeeState(
          status: CoffeeStatus.success,
          coffee: Coffee(file: 'url'),
          isFavorite: true,
        ),
      ],
    );
  });
}
