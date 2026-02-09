import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:monitoring_repository/src/firebase_crashlytics_service.dart';

class MockFirebaseCrashlytics extends Mock implements FirebaseCrashlytics {}

void main() {
  group('FirebaseCrashlyticsService', () {
    late FirebaseCrashlytics firebaseCrashlytics;
    late FirebaseCrashlyticsService service;

    setUpAll(() {
      registerFallbackValue('fallback');
      registerFallbackValue(StackTrace.empty);
    });

    setUp(() {
      firebaseCrashlytics = MockFirebaseCrashlytics();
      service = FirebaseCrashlyticsService(crashlytics: firebaseCrashlytics);
    });

    test('recordError calls firebaseCrashlytics.recordError', () async {
      final exception = Exception('oops');
      final stack = StackTrace.empty;

      when(
        () => firebaseCrashlytics.recordError(
          any<dynamic>(),
          any<StackTrace>(),
          reason: any<dynamic>(named: 'reason'),
          fatal: any<bool>(named: 'fatal'),
        ),
      ).thenAnswer((_) async {});

      await service.recordError(
        exception,
        stack,
        reason: 'reason',
        fatal: true,
      );

      verify(
        () => firebaseCrashlytics.recordError(
          exception,
          stack,
          reason: 'reason',
          fatal: true,
        ),
      ).called(1);
    });

    test('log calls firebaseCrashlytics.log', () async {
      when(() => firebaseCrashlytics.log('message')).thenAnswer((_) async {});

      await service.log('message');

      verify(() => firebaseCrashlytics.log('message')).called(1);
    });

    test('setCustomKey calls firebaseCrashlytics.setCustomKey', () async {
      when(
        () => firebaseCrashlytics.setCustomKey('key', 'value'),
      ).thenAnswer((_) async {});

      await service.setCustomKey('key', 'value');

      verify(() => firebaseCrashlytics.setCustomKey('key', 'value')).called(1);
    });

    test(
      'setUserIdentifier calls firebaseCrashlytics.setUserIdentifier',
      () async {
        when(
          () => firebaseCrashlytics.setUserIdentifier(any()),
        ).thenAnswer((_) async {});

        await service.setUserIdentifier('id');

        verify(() => firebaseCrashlytics.setUserIdentifier('id')).called(1);
      },
    );
  });
}
