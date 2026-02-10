# Coffee Data Sources

Data sources for the Coffee App, providing remote API access and local storage.

## Overview

The `coffee_data_sources` package contains the data layer implementation for coffee-related data. It manages both remote API calls and local persistence using Hive.

## Architecture

This package contains:

- **Remote Data Source**: `CoffeeRemoteDataSource` for fetching coffee data from an external API
- **Local Data Source**: `CoffeeLocalDataSource` for persisting favorites in local storage
- **Models**: `CoffeeModel` with JSON serialization and Hive adapters

## Features

- Fetch random coffee images from external API
- Download and cache coffee images locally
- Persist favorites using Hive database
- Stream-based favorites updates

## Usage

### Adding to your project

```yaml
dependencies:
  coffee_data_sources:
    path: packages/coffee_data_sources
```

### Using the data sources

```dart
import 'package:coffee_api_client/coffee_api_client.dart';
import 'package:coffee_data_sources/coffee_data_sources.dart';
import 'package:hive/hive.dart';

// Initialize Hive and register adapters
await Hive.initFlutter();
Hive.registerAdapter(CoffeeModelAdapter());
final box = await Hive.openBox<CoffeeModel>('coffee_box');

// Create API client
final apiClient = CoffeeApiClient(
  baseUrl: 'https://coffee.alexflipnote.dev',
);

// Create remote data source
final remoteDataSource = CoffeeRemoteDataSource(client: apiClient);

// Create local data source
final localDataSource = CoffeeLocalDataSource(
  coffeeBox: box,
  storagePath: '/path/to/storage',
);

// Fetch random coffee
final coffee = await remoteDataSource.getRandomCoffee();

// Download and save favorite
final bytes = await remoteDataSource.downloadImage(coffee.file);
await localDataSource.saveFavorite(
  coffee: coffee,
  imageBytes: bytes,
);

// Stream favorites
localDataSource.getFavoritesStream().listen((favorites) {
  print('Favorites: $favorites');
});
```

## Dependencies

- `coffee_api_client`: Generic HTTP client
- `hive`: Local NoSQL database
- `path_provider`: For determining storage paths
- `equatable`: For value equality
- `json_annotation`: For JSON serialization
