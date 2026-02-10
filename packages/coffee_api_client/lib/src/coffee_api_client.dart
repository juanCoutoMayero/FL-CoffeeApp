import 'package:http/http.dart' as http;

/// {@template coffee_api_client}
/// A generic API client for the Coffee App.
/// {@endtemplate}
class CoffeeApiClient {
  /// {@macro coffee_api_client}
  CoffeeApiClient({required String baseUrl, http.Client? client})
    : _baseUrl = baseUrl,
      _client = client ?? http.Client();

  final String _baseUrl;
  final http.Client _client;

  /// Performs a GET request to the specified [path].
  ///
  /// The [path] should be relative to the [baseUrl] provided in the constructor.
  /// If the path starts with `http`, it will be treated as an absolute URL.
  Future<http.Response> get(String path) async {
    final uri = path.startsWith('http')
        ? Uri.parse(path)
        : Uri.parse('$_baseUrl$path');

    return _client.get(uri);
  }
}
