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
    try {
      return await _remoteDataSource.getRandomCoffee();
    } catch (error, stackTrace) {
      throw CoffeeRequestFailure(error, stackTrace);
    }
  }

  /// Downloads and saves a coffee as favorite.
  Future<void> saveFavorite(Coffee coffee) async {
    try {
      final imageBytes = await _remoteDataSource.downloadImage(coffee.file);
      final coffeeModel = CoffeeModel.fromEntity(coffee);
      await _localDataSource.saveFavorite(
        coffee: coffeeModel,
        imageBytes: imageBytes,
      );
    } catch (error, stackTrace) {
      throw CoffeeRequestFailure(error, stackTrace);
    }
  }

  /// Removes a coffee from favorites.
  Future<void> removeFavorite(Coffee coffee) async {
    try {
      final coffeeModel = CoffeeModel.fromEntity(coffee);
      await _localDataSource.removeFavorite(coffeeModel);
    } catch (error, stackTrace) {
      throw CoffeeRequestFailure(error, stackTrace);
    }
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
