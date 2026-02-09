import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:monitoring_repository/src/analytics_service.dart';

/// {@template firebase_analytics_service}
/// A Firebase implementation of the AnalyticsService
/// {@endtemplate}
class FirebaseAnalyticsService implements AnalyticsService {
  /// {@macro firebase_analytics_service}
  FirebaseAnalyticsService({
    FirebaseAnalytics? analytics,
  }) : _analytics = analytics ?? FirebaseAnalytics.instance;

  final FirebaseAnalytics _analytics;

  @override
  Future<void> logEvent({
    required String name,
    Map<String, Object>? parameters,
  }) async {
    await _analytics.logEvent(
      name: name,
      parameters: parameters,
    );
  }

  @override
  Future<void> setUserId(String? id) async {
    await _analytics.setUserId(id: id);
  }

  @override
  Future<void> setUserProperty({
    required String name,
    required String? value,
  }) async {
    await _analytics.setUserProperty(name: name, value: value);
  }
}
