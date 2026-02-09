import 'package:monitoring_repository/src/analytics_service.dart';
import 'package:monitoring_repository/src/crashlytics_service.dart';

/// {@template monitoring_repository}
/// A repository that handles monitoring and analytics
/// {@endtemplate}
class MonitoringRepository {
  /// {@macro monitoring_repository}
  const MonitoringRepository({
    required AnalyticsService analyticsService,
    required CrashlyticsService crashlyticsService,
  }) : _analyticsService = analyticsService,
       _crashlyticsService = crashlyticsService;

  final AnalyticsService _analyticsService;
  final CrashlyticsService _crashlyticsService;

  /// Returns the current analytics service
  AnalyticsService get analytics => _analyticsService;

  /// Returns the current crashlytics service
  CrashlyticsService get crashlytics => _crashlyticsService;
}
