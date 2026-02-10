# Coffee Repository

A repository that handles coffee-related requests for the Coffee App.

## Overview

The `coffee_repository` package provides the domain layer interface and implementation for managing coffee data. It follows Clean Architecture principles by separating the domain logic from data sources.

## Architecture

This package contains:

- **Domain Layer**: `CoffeeRepository` abstract class defining the contract
- **Data Layer**: `CoffeeRepositoryImpl` implementing the repository using data sources from `coffee_data_sources`
- **Models**: `Coffee` entity representing a coffee in the domain

## Usage

### Adding to your project

```yaml
dependencies:
  coffee_repository:
    path: packages/coffee_repository
```

### Using the repository

```dart
import 'package:coffee_repository/coffee_repository.dart';

// Instantiate the repository implementation
final repository = CoffeeRepositoryImpl(
  remoteDataSource: remoteDataSource,
  localDataSource: localDataSource,
);

// Fetch a random coffee
try {
  final coffee = await repository.getRandomCoffee();
 print(coffee.file);
} on CoffeeRequestFailure catch (e) {
  // Handle error
}

// Save a coffee as favorite
await repository.saveFavorite(coffee);

// Stream favorites
repository.getFavoritesStream().listen((favorites) {
  print('Favorites count: ${favorites.length}');
});
```

## Error Handling

All async methods may throw `CoffeeRequestFailure`. The repository catches exceptions from data sources and wraps them in this failure type for consistent error handling.

## Dependencies

- `coffee_data_sources`: Provides data sources for remote API and local storage
- `equatable`: For value equality in models
