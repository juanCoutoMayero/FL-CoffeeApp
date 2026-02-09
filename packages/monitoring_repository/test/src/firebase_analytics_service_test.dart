import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:monitoring_repository/src/firebase_analytics_service.dart';

class MockFirebaseAnalytics extends Mock implements FirebaseAnalytics {}

void main() {
  group('FirebaseAnalyticsService', () {
    late FirebaseAnalytics firebaseAnalytics;
    late FirebaseAnalyticsService service;

    setUp(() {
      firebaseAnalytics = MockFirebaseAnalytics();
      service = FirebaseAnalyticsService(analytics: firebaseAnalytics);
    });

    test('logEvent calls firebaseAnalytics.logEvent', () async {
      when(
        () => firebaseAnalytics.logEvent(
          name: 'test',
          parameters: any(named: 'parameters'),
        ),
      ).thenAnswer((_) async {});

      await service.logEvent(name: 'test', parameters: {'key': 'value'});

      verify(
        () => firebaseAnalytics.logEvent(
          name: 'test',
          parameters: {'key': 'value'},
        ),
      ).called(1);
    });

    test('setUserId calls firebaseAnalytics.setUserId', () async {
      when(
        () => firebaseAnalytics.setUserId(id: any(named: 'id')),
      ).thenAnswer((_) async {});

      await service.setUserId('user-id');

      verify(() => firebaseAnalytics.setUserId(id: 'user-id')).called(1);
    });

    test('setUserProperty calls firebaseAnalytics.setUserProperty', () async {
      when(
        () => firebaseAnalytics.setUserProperty(
          name: any(named: 'name'),
          value: any(named: 'value'),
        ),
      ).thenAnswer((_) async {});

      await service.setUserProperty(name: 'key', value: 'value');

      verify(
        () => firebaseAnalytics.setUserProperty(name: 'key', value: 'value'),
      ).called(1);
    });
  });
}
