import 'package:coffee_data_sources/coffee_data_sources.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CoffeeModel', () {
    const file = 'https://coffee.alexflipnote.dev/random.json';
    const localPath = '/path/to/image.jpg';
    final savedDate = DateTime(2023, 1, 1);

    test('supports value equality', () {
      final coffeeModel1 = CoffeeModel(
        file: file,
        localPath: localPath,
        savedDate: savedDate,
      );
      final coffeeModel2 = CoffeeModel(
        file: file,
        localPath: localPath,
        savedDate: savedDate,
      );

      expect(coffeeModel1, equals(coffeeModel2));
    });

    test('fromJson returns correct CoffeeModel', () {
      final json = {
        'file': file,
        'localPath': localPath,
        'savedDate': savedDate.toIso8601String(),
      };

      final coffeeModel = CoffeeModel.fromJson(json);

      expect(coffeeModel.file, equals(file));
      expect(coffeeModel.localPath, equals(localPath));
      expect(coffeeModel.savedDate, equals(savedDate));
    });

    test('toJson returns correct Map', () {
      final coffeeModel = CoffeeModel(
        file: file,
        localPath: localPath,
        savedDate: savedDate,
      );

      final json = coffeeModel.toJson();

      expect(json['file'], equals(file));
      expect(json['localPath'], equals(localPath));
      expect(json['savedDate'], equals(savedDate.toIso8601String()));
    });
  });
}
