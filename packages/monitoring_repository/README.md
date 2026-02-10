# Monitoring Repository

A repository for analytics and crashlytics services in the Coffee App.

## Overview

The `monitoring_repository` package provides abstractions for monitoring services like Firebase Analytics and Crashlytics. It follows the dependency inversion principle by defining interfaces that can be implemented by different providers.

## Architecture

This package contains:

- **Interfaces**: `AnalyticsService` and `CrashlyticsService` abstract classes
- **Firebase Implementations**: `FirebaseAnalyticsService` and `FirebaseCrashlyticsService`
- **Repository**: `MonitoringRepository` that aggregates both services

## Features

- **Analytics**: Track custom events, user properties, and user IDs
- **Crashlytics**: Record errors, log messages, and set custom keys
- **Decoupled Design**: Easy to swap implementations or add new providers

## Usage

### Adding to your project

```yaml
dependencies:
  monitoring_repository:
    path: packages/monitoring_repository
```

### Using the repository

```dart
import 'package:monitoring_repository/monitoring_repository.dart';

// Create service implementations
final analyticsService = FirebaseAnalyticsService();
final crashlyticsService = FirebaseCrashlyticsService();

// Create repository
final monitoringRepo = MonitoringRepository(
  analyticsService: analyticsService,
  crashlyticsService: crashlyticsService,
);

// Log analytics events
await monitoringRepo.analytics.logEvent(
  name: 'button_clicked',
  parameters: {'button_id': 'submit'},
);

// Record errors
await monitoringRepo.crashlytics.recordError(
  error,
  stackTrace,
  reason: 'User action failed',
);
```

## Extending

To add a new analytics or crashlytics provider:

1. Implement the `AnalyticsService` or `CrashlyticsService` interface
2. Pass your implementation to `MonitoringRepository`

## Dependencies

- `firebase_analytics`: Firebase Analytics SDK
- `firebase_crashlytics`: Firebase Crashlytics SDK
