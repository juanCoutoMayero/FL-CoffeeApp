import 'package:coffee_repository/src/data_sources/local_data_source.dart';
import 'package:coffee_repository/src/data_sources/remote_data_source.dart';
import 'package:coffee_repository/src/models/models.dart';

export 'data_sources/local_data_source.dart';
export 'data_sources/remote_data_source.dart';

/// {@template coffee_repository}
/// A repository that handles coffee related requests.
/// {@endtemplate}
class CoffeeRepository {
  /// {@macro coffee_repository}
  const CoffeeRepository({
    required CoffeeLocalDataSource localDataSource,
    required CoffeeRemoteDataSource remoteDataSource,
  })  : _localDataSource = localDataSource,
        _remoteDataSource = remoteDataSource;

  final CoffeeLocalDataSource _localDataSource;
  final CoffeeRemoteDataSource _remoteDataSource;

  /// Fetches a random coffee.
  Future<Coffee> getRandomCoffee() async {
    return _remoteDataSource.getRandomCoffee();
  }

  /// Downloads and saves a coffee as favorite.
  Future<void> saveFavorite(Coffee coffee) async {
    final imageBytes = await _remoteDataSource.downloadImage(coffee.file);
    final coffeeModel = CoffeeModel.fromEntity(coffee);
    await _localDataSource.saveFavorite(
      coffee: coffeeModel,
      imageBytes: imageBytes,
    );
  }

  /// Removes a coffee from favorites.
  Future<void> removeFavorite(Coffee coffee) async {
    final coffeeModel = CoffeeModel.fromEntity(coffee);
    await _localDataSource.removeFavorite(coffeeModel);
  }

  /// items.
  List<Coffee> getFavorites() {
    return _localDataSource.getFavorites();
  }

  /// Returns a stream of favorites.
  Stream<List<Coffee>> getFavoritesStream() {
    return _localDataSource.getFavoritesStream();
  }

  /// Checks if a coffee is favorite.
  bool isFavorite(String url) {
    return _localDataSource.isFavorite(url);
  }
}
