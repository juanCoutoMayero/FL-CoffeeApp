import 'package:coffee_data_sources/coffee_data_sources.dart';
import 'package:coffee_repository/coffee_repository.dart';

/// {@template coffee_repository_impl}
/// Implementation of [CoffeeRepository].
/// {@endtemplate}
class CoffeeRepositoryImpl implements CoffeeRepository {
  /// {@macro coffee_repository_impl}
  const CoffeeRepositoryImpl({
    required CoffeeLocalDataSource localDataSource,
    required CoffeeRemoteDataSource remoteDataSource,
  })  : _localDataSource = localDataSource,
        _remoteDataSource = remoteDataSource;

  final CoffeeLocalDataSource _localDataSource;
  final CoffeeRemoteDataSource _remoteDataSource;

  @override
  Future<Coffee> getRandomCoffee() async {
    try {
      final coffeeModel = await _remoteDataSource.getRandomCoffee();
      return _toEntity(coffeeModel);
    } catch (error, stackTrace) {
      throw CoffeeRequestFailure(error, stackTrace);
    }
  }

  @override
  Future<void> saveFavorite(Coffee coffee) async {
    try {
      final imageBytes = await _remoteDataSource.downloadImage(coffee.file);
      final coffeeModel = _toModel(coffee);
      await _localDataSource.saveFavorite(
        coffee: coffeeModel,
        imageBytes: imageBytes,
      );
    } catch (error, stackTrace) {
      throw CoffeeRequestFailure(error, stackTrace);
    }
  }

  @override
  Future<void> removeFavorite(Coffee coffee) async {
    try {
      final coffeeModel = _toModel(coffee);
      await _localDataSource.removeFavorite(coffeeModel);
    } catch (error, stackTrace) {
      throw CoffeeRequestFailure(error, stackTrace);
    }
  }

  @override
  List<Coffee> getFavorites() {
    return _localDataSource.getFavorites().map(_toEntity).toList();
  }

  @override
  Stream<List<Coffee>> getFavoritesStream() {
    return _localDataSource.getFavoritesStream().map(
          (models) => models.map(_toEntity).toList(),
        );
  }

  @override
  bool isFavorite(String url) {
    return _localDataSource.isFavorite(url);
  }

  Coffee _toEntity(CoffeeModel model) {
    return Coffee(
      file: model.file,
      localPath: model.localPath,
      savedDate: model.savedDate,
    );
  }

  CoffeeModel _toModel(Coffee entity) {
    return CoffeeModel(
      file: entity.file,
      localPath: entity.localPath,
      savedDate: entity.savedDate,
    );
  }
}
