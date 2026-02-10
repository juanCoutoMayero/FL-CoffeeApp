import 'dart:convert';
import 'dart:typed_data';

import 'package:coffee_api_client/coffee_api_client.dart';
import 'package:coffee_data_sources/src/models/coffee_model.dart';

/// {@template coffee_remote_data_source}
/// The remote data source for the Coffee Repository.
/// {@endtemplate}
class CoffeeRemoteDataSource {
  /// {@macro coffee_remote_data_source}
  CoffeeRemoteDataSource({required CoffeeApiClient client}) : _client = client;

  final CoffeeApiClient _client;

  /// Fetches a random coffee image URL.
  Future<CoffeeModel> getRandomCoffee() async {
    final response = await _client.get(
      'https://coffee.alexflipnote.dev/random.json',
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch random coffee');
    }

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    return CoffeeModel.fromJson(body);
  }

  /// Downloads the image from the given [url].
  Future<Uint8List> downloadImage(String url) async {
    final response = await _client.get(url);

    if (response.statusCode != 200) {
      throw Exception('Failed to download image');
    }

    return response.bodyBytes;
  }
}
