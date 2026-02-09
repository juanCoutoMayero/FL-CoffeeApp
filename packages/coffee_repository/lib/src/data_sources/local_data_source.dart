import 'dart:io';
import 'dart:typed_data';

import 'package:coffee_repository/src/models/models.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

/// {@template coffee_local_data_source}
/// The local data source for the Coffee Repository.
/// {@endtemplate}
class CoffeeLocalDataSource {
  /// {@macro coffee_local_data_source}
  const CoffeeLocalDataSource({
    required Box<CoffeeModel> coffeeBox,
  }) : _coffeeBox = coffeeBox;

  final Box<CoffeeModel> _coffeeBox;

  /// Returns a stream of [CoffeeModel]s.
  List<CoffeeModel> getFavorites() {
    final favorites = _coffeeBox.values.toList();
    favorites.sort((a, b) {
      if (a.savedDate == null && b.savedDate == null) return 0;
      if (a.savedDate == null) return 1;
      if (b.savedDate == null) return -1;
      return b.savedDate!.compareTo(a.savedDate!);
    });
    return favorites;
  }

  /// Returns a stream of favorites.
  Stream<List<CoffeeModel>> getFavoritesStream() {
    return _coffeeBox.watch().map((_) {
      return getFavorites();
    });
  }

  /// Saves the coffee image locally and adds it to favorites.
  Future<CoffeeModel> saveFavorite({
    required CoffeeModel coffee,
    required Uint8List imageBytes,
  }) async {
    final directory = await getApplicationDocumentsDirectory();
    final fileName = Uri.parse(coffee.file).pathSegments.last;
    final filePath = '${directory.path}/$fileName';
    final file = File(filePath);

    await file.writeAsBytes(imageBytes);

    final updatedCoffee = CoffeeModel(
      file: coffee.file,
      localPath: filePath,
      savedDate: DateTime.now(),
    );

    await _coffeeBox.put(fileName, updatedCoffee);
    return updatedCoffee;
  }

  /// Removes a coffee from favorites and deletes the local file.
  Future<void> removeFavorite(CoffeeModel coffee) async {
    final fileName = Uri.parse(coffee.file).pathSegments.last;

    if (coffee.localPath != null) {
      final file = File(coffee.localPath!);
      if (await file.exists()) {
        await file.delete();
      }
    }

    await _coffeeBox.delete(fileName);
  }

  /// Checks if a coffee is already favorite (by URL/filename).
  bool isFavorite(String url) {
    final fileName = Uri.parse(url).pathSegments.last;
    return _coffeeBox.containsKey(fileName);
  }
}
