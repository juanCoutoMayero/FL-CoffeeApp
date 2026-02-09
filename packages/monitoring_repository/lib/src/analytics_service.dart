/// Interface for Analytics Service
abstract class AnalyticsService {
  /// Logs a custom event with optional parameters.
  Future<void> logEvent({
    required String name,
    Map<String, Object>? parameters,
  });

  /// Sets the user ID.
  Future<void> setUserId(String? id);

  /// Sets a user property.
  Future<void> setUserProperty({
    required String name,
    required String? value,
  });
}
