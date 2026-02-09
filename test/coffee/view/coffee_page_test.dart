import 'package:bloc_test/bloc_test.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:coffee_app/coffee/bloc/bloc.dart';
import 'package:coffee_app/coffee/view/coffee_page.dart';
import 'package:coffee_app/coffee/widgets/coffee_controls.dart';
import 'package:coffee_app/coffee/widgets/custom_shimmer.dart';
import 'package:coffee_app/coffee/widgets/favorite_item.dart';
import 'package:coffee_app/coffee/widgets/favorites_list.dart';
import 'package:coffee_repository/coffee_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

class MockCoffeeRepository extends Mock implements CoffeeRepository {}

class MockCoffeeBloc extends MockBloc<CoffeeEvent, CoffeeState>
    implements CoffeeBloc {}

void main() {
  group('CoffeePage', () {
    late CoffeeRepository coffeeRepository;

    setUp(() {
      coffeeRepository = MockCoffeeRepository();
      when(() => coffeeRepository.getFavorites()).thenReturn([]);
      when(
        () => coffeeRepository.getFavoritesStream(),
      ).thenAnswer((_) => const Stream.empty());
    });

    testWidgets('renders CoffeeView', (tester) async {
      when(() => coffeeRepository.getRandomCoffee()).thenAnswer(
        (_) async => const Coffee(file: 'https://example.com/coffee.jpg'),
      );
      when(() => coffeeRepository.isFavorite(any())).thenReturn(false);

      await tester.pumpApp(
        RepositoryProvider.value(
          value: coffeeRepository,
          child: const CoffeePage(),
        ),
      );

      expect(find.byType(CoffeeView), findsOneWidget);
    });
  });

  group('CoffeeView', () {
    late CoffeeBloc coffeeBloc;

    setUp(() {
      coffeeBloc = MockCoffeeBloc();
      when(() => coffeeBloc.state).thenReturn(const CoffeeState());
    });

    testWidgets('renders CoffeeDisplay, CoffeeControls, and FavoritesList', (
      tester,
    ) async {
      await tester.pumpApp(
        BlocProvider.value(
          value: coffeeBloc,
          child: const CoffeeView(),
        ),
      );

      expect(find.byType(CoffeeDisplay), findsOneWidget);
      expect(find.byType(CoffeeControls), findsOneWidget);
      expect(find.byType(FavoritesList), findsOneWidget);
    });
  });

  group('CoffeeDisplay', () {
    late CoffeeBloc coffeeBloc;

    setUp(() {
      coffeeBloc = MockCoffeeBloc();
    });

    testWidgets('renders CustomShimmer when status is loading', (tester) async {
      when(() => coffeeBloc.state).thenReturn(
        const CoffeeState(status: CoffeeStatus.loading),
      );

      await tester.pumpApp(
        BlocProvider.value(
          value: coffeeBloc,
          child: const CoffeeDisplay(),
        ),
      );

      expect(find.byType(CustomShimmer), findsOneWidget);
    });

    testWidgets('renders CachedNetworkImage when status is success', (
      tester,
    ) async {
      when(() => coffeeBloc.state).thenReturn(
        const CoffeeState(
          status: CoffeeStatus.success,
          coffee: Coffee(file: 'https://example.com/coffee.jpg'),
        ),
      );

      await tester.pumpApp(
        BlocProvider.value(
          value: coffeeBloc,
          child: const CoffeeDisplay(),
        ),
      );

      expect(find.byType(CachedNetworkImage), findsOneWidget);
    });

    testWidgets('renders error text when status is failure', (tester) async {
      when(() => coffeeBloc.state).thenReturn(
        const CoffeeState(status: CoffeeStatus.failure),
      );

      await tester.pumpApp(
        BlocProvider.value(
          value: coffeeBloc,
          child: const CoffeeDisplay(),
        ),
      );

      expect(find.text('Something went wrong!'), findsOneWidget);
    });
  });

  group('FavoritesList', () {
    late CoffeeBloc coffeeBloc;

    setUp(() {
      coffeeBloc = MockCoffeeBloc();
    });

    testWidgets('renders empty state when favorites is empty', (tester) async {
      when(() => coffeeBloc.state).thenReturn(
        const CoffeeState(favorites: []),
      );

      await tester.pumpApp(
        BlocProvider.value(
          value: coffeeBloc,
          child: const FavoritesList(),
        ),
      );

      expect(
        find.text(
          "Hey, you haven't saved any coffee yet. Don't be bitter, give it a like!",
        ),
        findsOneWidget,
      );
    });

    testWidgets('renders list of favorites when favorites is not empty', (
      tester,
    ) async {
      final favorites = [
        const Coffee(file: 'https://example.com/1.jpg'),
        const Coffee(file: 'https://example.com/2.jpg'),
      ];
      when(() => coffeeBloc.state).thenReturn(
        CoffeeState(favorites: favorites),
      );

      await tester.pumpApp(
        BlocProvider.value(
          value: coffeeBloc,
          child: const FavoritesList(),
        ),
      );

      expect(find.byType(ListView), findsOneWidget);
      expect(find.byType(FavoriteItem), findsNWidgets(2));
    });
  });

  group('FavoriteItem', () {
    late CoffeeBloc coffeeBloc;

    setUp(() {
      coffeeBloc = MockCoffeeBloc();
    });

    testWidgets('renders CachedNetworkImageProvider when coffee is remote', (
      tester,
    ) async {
      const coffee = Coffee(file: 'https://example.com/coffee.jpg');

      await tester.pumpApp(
        BlocProvider.value(
          value: coffeeBloc,
          child: const FavoriteItem(coffee: coffee),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container));
      final decoration = container.decoration as BoxDecoration;
      final image = decoration.image!.image as CachedNetworkImageProvider;

      expect(image.url, coffee.file);
    });

    testWidgets('renders FileImage when coffee is local', (tester) async {
      const coffee = Coffee(
        file: 'local/path',
        localPath: 'local/path',
      );

      await tester.pumpApp(
        BlocProvider.value(
          value: coffeeBloc,
          child: const FavoriteItem(coffee: coffee),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container));
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.image!.image, isA<FileImage>());
    });

    testWidgets('adds CoffeeSelected event when tapped', (tester) async {
      const coffee = Coffee(file: 'https://example.com/coffee.jpg');

      await tester.pumpApp(
        BlocProvider.value(
          value: coffeeBloc,
          child: const FavoriteItem(coffee: coffee),
        ),
      );

      await tester.tap(find.byType(FavoriteItem));
      verify(() => coffeeBloc.add(const CoffeeSelected(coffee))).called(1);
    });
  });
}
