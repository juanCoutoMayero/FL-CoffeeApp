import 'dart:io';
import 'dart:typed_data';

import 'package:coffee_data_sources/src/models/coffee_model.dart';
import 'package:hive/hive.dart';

/// {@template coffee_local_data_source}
/// The local data source for the Coffee Repository.
/// {@endtemplate}
class CoffeeLocalDataSource {
  /// {@macro coffee_local_data_source}
  const CoffeeLocalDataSource({
    required Box<CoffeeModel> coffeeBox,
    required String storagePath,
  }) : _coffeeBox = coffeeBox,
       _storagePath = storagePath;

  final Box<CoffeeModel> _coffeeBox;
  final String _storagePath;

  /// Returns a stream of [CoffeeModel]s.
  List<CoffeeModel> getFavorites() {
    final favorites =
        _coffeeBox.values.map((coffee) {
          // reconstruct absolute path
          if (coffee.localPath != null) {
            final fileName = Uri.parse(coffee.localPath!).pathSegments.last;
            return coffee.copyWith(localPath: '$_storagePath/$fileName');
          }
          return coffee;
        }).toList()..sort((a, b) {
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
    final fileName = Uri.parse(coffee.file).pathSegments.last;
    final filePath = '$_storagePath/$fileName';
    final file = File(filePath);

    await file.writeAsBytes(imageBytes);

    final coffeeToSave = CoffeeModel(
      file: coffee.file,
      localPath: fileName, // Save relative path (filename only)
      savedDate: DateTime.now(),
    );

    await _coffeeBox.put(fileName, coffeeToSave);

    // Return model with absolute path for immediate UI use
    return coffeeToSave.copyWith(localPath: filePath);
  }

  /// Removes a coffee from favorites and deletes the local file.
  Future<void> removeFavorite(CoffeeModel coffee) async {
    final fileName = Uri.parse(coffee.file).pathSegments.last;
    final filePath = '$_storagePath/$fileName';

    final file = File(filePath);
    if (await file.exists()) {
      await file.delete();
    }

    await _coffeeBox.delete(fileName);
  }

  /// Checks if a coffee is already favorite (by URL/filename).
  bool isFavorite(String url) {
    final fileName = Uri.parse(url).pathSegments.last;
    return _coffeeBox.containsKey(fileName);
  }
}
