# Coffee API Client

A generic HTTP client for the Coffee App API.

## Overview

The `coffee_api_client` package provides a lightweight wrapper around `http.Client` with base URL management. It's designed to be used by data sources rather than containing domain-specific logic.

## Features

- Base URL injection for environment-specific configuration
- Generic HTTP `get` method for flexible usage
- Support for both relative and absolute URLs

## Usage

### Adding to your project

```yaml
dependencies:
  coffee_api_client:
    path: packages/coffee_api_client
```

### Using the client

```dart
import 'package:coffee_api_client/coffee_api_client.dart';

// Create a client with a base URL
final client = CoffeeApiClient(
  baseUrl: 'https://api.example.com',
);

// Make GET requests
final response = await client.get('/endpoint');

// Or use absolute URLs
final response2 = await client.get('https://other-api.com/data');
```

## Design

This package intentionally keeps domain logic out of the API client. Specific endpoints and data parsing should be handled by data sources that consume this client.

## Dependencies

- `http`: For making HTTP requests
