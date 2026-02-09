import 'package:coffee_repository/coffee_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Coffee', () {
    test('supports value equality', () {
      const coffee1 = Coffee(
        file: 'url',
        localPath: 'path',
        savedDate: null,
      );
      const coffee2 = Coffee(
        file: 'url',
        localPath: 'path',
        savedDate: null,
      );

      expect(coffee1, equals(coffee2));
    });

    test('isLocal returns true when localPath is not null', () {
      const coffee = Coffee(
        file: 'url',
        localPath: 'path',
      );

      expect(coffee.isLocal, isTrue);
    });

    test('isLocal returns false when localPath is null', () {
      const coffee = Coffee(
        file: 'url',
      );

      expect(coffee.isLocal, isFalse);
    });
  });
}
