import 'package:coffee_api_client/coffee_api_client.dart';
import 'package:test/test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';

class MockHttpClient extends Mock implements http.Client {}

class MockResponse extends Mock implements http.Response {}

class FakeUri extends Fake implements Uri {}

void main() {
  group('CoffeeApiClient', () {
    late http.Client httpClient;
    late CoffeeApiClient apiClient;
    const baseUrl = 'https://api.example.com';

    setUpAll(() {
      registerFallbackValue(FakeUri());
    });

    setUp(() {
      httpClient = MockHttpClient();
      apiClient = CoffeeApiClient(baseUrl: baseUrl, client: httpClient);
    });

    group('constructor', () {
      test('creates instance with provided client', () {
        expect(apiClient, isNotNull);
      });

      test('creates instance with default client when not provided', () {
        final client = CoffeeApiClient(baseUrl: baseUrl);
        expect(client, isNotNull);
      });
    });

    group('get', () {
      test('makes GET request with relative path', () async {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(200);
        when(() => httpClient.get(any())).thenAnswer((_) async => response);

        final result = await apiClient.get('/endpoint');

        expect(result, equals(response));
        verify(() => httpClient.get(Uri.parse('$baseUrl/endpoint'))).called(1);
      });

      test('makes GET request with absolute URL', () async {
        const absoluteUrl = 'https://other-api.com/data';
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(200);
        when(() => httpClient.get(any())).thenAnswer((_) async => response);

        final result = await apiClient.get(absoluteUrl);

        expect(result, equals(response));
        verify(() => httpClient.get(Uri.parse(absoluteUrl))).called(1);
      });

      test('returns response from httpClient', () async {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(404);
        when(() => response.body).thenReturn('Not found');
        when(() => httpClient.get(any())).thenAnswer((_) async => response);

        final result = await apiClient.get('/notfound');

        expect(result.statusCode, equals(404));
        expect(result.body, equals('Not found'));
      });
    });
  });
}
