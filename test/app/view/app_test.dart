import 'package:coffee_repository/coffee_repository.dart';
import 'package:coffee_app/app/app.dart';
import 'package:coffee_app/coffee/view/coffee_page.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCoffeeRepository extends Mock implements CoffeeRepository {}

void main() {
  group('App', () {
    late CoffeeRepository coffeeRepository;

    setUp(() {
      coffeeRepository = MockCoffeeRepository();
      when(() => coffeeRepository.getRandomCoffee()).thenAnswer(
        (_) async =>
            const Coffee(file: 'https://coffee.alexflipnote.dev/random.json'),
      );
      when(
        () => coffeeRepository.getFavoritesStream(),
      ).thenAnswer((_) => Stream.value([]));
      when(() => coffeeRepository.getFavorites()).thenReturn([]);
    });

    testWidgets('renders CoffeePage', (tester) async {
      await tester.pumpWidget(App(coffeeRepository: coffeeRepository));
      expect(find.byType(CoffeePage), findsOneWidget);
    });
  });
}
