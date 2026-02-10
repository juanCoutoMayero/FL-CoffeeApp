import 'package:coffee_repository/src/models/models.dart';

/// {@template coffee_repository}
/// A repository that handles coffee related requests.
/// {@endtemplate}
abstract class CoffeeRepository {
  /// Fetches a random coffee.
  Future<Coffee> getRandomCoffee();

  /// Downloads and saves a coffee as favorite.
  Future<void> saveFavorite(Coffee coffee);

  /// Removes a coffee from favorites.
  Future<void> removeFavorite(Coffee coffee);

  /// Returns a stream of favorites.
  Stream<List<Coffee>> getFavoritesStream();

  /// items.
  List<Coffee> getFavorites();

  /// Checks if a coffee is favorite.
  bool isFavorite(String url);
}
