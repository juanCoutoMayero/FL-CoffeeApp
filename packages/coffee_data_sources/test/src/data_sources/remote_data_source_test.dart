import 'dart:convert';
import 'dart:typed_data';

import 'package:coffee_api_client/coffee_api_client.dart';
import 'package:coffee_data_sources/coffee_data_sources.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';

class MockCoffeeApiClient extends Mock implements CoffeeApiClient {}

class MockResponse extends Mock implements http.Response {}

void main() {
  group('CoffeeRemoteDataSource', () {
    late CoffeeApiClient apiClient;
    late CoffeeRemoteDataSource remoteDataSource;

    setUp(() {
      apiClient = MockCoffeeApiClient();
      remoteDataSource = CoffeeRemoteDataSource(client: apiClient);
    });

    group('getRandomCoffee', () {
      test('returns CoffeeModel when response is 200', () async {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(200);
        when(() => response.body).thenReturn(
          jsonEncode({'file': 'https://coffee.alexflipnote.dev/random.json'}),
        );
        when(() => apiClient.get(any())).thenAnswer((_) async => response);

        final coffee = await remoteDataSource.getRandomCoffee();

        expect(
          coffee,
          isA<CoffeeModel>().having(
            (c) => c.file,
            'file',
            'https://coffee.alexflipnote.dev/random.json',
          ),
        );
      });

      test('throws Exception when response is not 200', () async {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(404);
        when(() => apiClient.get(any())).thenAnswer((_) async => response);

        expect(
          () => remoteDataSource.getRandomCoffee(),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('downloadImage', () {
      test('returns Uint8List when response is 200', () async {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(200);
        when(
          () => response.bodyBytes,
        ).thenReturn(Uint8List.fromList([0, 1, 2]));
        when(() => apiClient.get(any())).thenAnswer((_) async => response);

        final bytes = await remoteDataSource.downloadImage(
          'https://example.com/image.jpg',
        );

        expect(bytes, equals([0, 1, 2]));
      });

      test('throws Exception when response is not 200', () async {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(404);
        when(() => apiClient.get(any())).thenAnswer((_) async => response);

        expect(
          () => remoteDataSource.downloadImage('https://example.com/image.jpg'),
          throwsA(isA<Exception>()),
        );
      });
    });
  });
}
