/// Interface for Crashlytics Service
abstract class CrashlyticsService {
  /// Logs a non-fatal error.
  Future<void> recordError(
    dynamic exception,
    StackTrace? stack, {
    dynamic reason,
    bool fatal = false,
  });

  /// Logs a custom message to the crash report.
  Future<void> log(String message);

  /// Sets a custom key-value pair to be associated with crash reports.
  Future<void> setCustomKey(String key, Object value);

  /// Sets the user identifier to be associated with crash reports.
  Future<void> setUserIdentifier(String identifier);
}
