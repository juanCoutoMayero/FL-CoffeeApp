import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:monitoring_repository/monitoring_repository.dart';

class MockAnalyticsService extends Mock implements AnalyticsService {}

class MockCrashlyticsService extends Mock implements CrashlyticsService {}

void main() {
  group('MonitoringRepository', () {
    late AnalyticsService analyticsService;
    late CrashlyticsService crashlyticsService;

    setUp(() {
      analyticsService = MockAnalyticsService();
      crashlyticsService = MockCrashlyticsService();
    });

    test('instantiates correctly', () {
      expect(
        MonitoringRepository(
          analyticsService: analyticsService,
          crashlyticsService: crashlyticsService,
        ),
        isNotNull,
      );
    });
  });
}
