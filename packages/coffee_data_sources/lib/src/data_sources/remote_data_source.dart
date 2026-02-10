import 'dart:convert';
import 'dart:typed_data';

import 'package:coffee_data_sources/src/models/coffee_model.dart';
import 'package:http/http.dart' as http;

/// {@template coffee_remote_data_source}
/// The remote data source for the Coffee Repository.
/// {@endtemplate}
class CoffeeRemoteDataSource {
  /// {@macro coffee_remote_data_source}
  CoffeeRemoteDataSource({http.Client? client})
    : _client = client ?? http.Client();

  final http.Client _client;

  /// Fetches a random coffee image URL.
  Future<CoffeeModel> getRandomCoffee() async {
    final response = await _client
        .get(Uri.parse('https://coffee.alexflipnote.dev/random.json'))
        .timeout(const Duration(seconds: 15));

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch random coffee');
    }

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    return CoffeeModel.fromJson(body);
  }

  /// Downloads the image from the given [url].
  Future<Uint8List> downloadImage(String url) async {
    final response = await _client
        .get(Uri.parse(url))
        .timeout(const Duration(seconds: 15));

    if (response.statusCode != 200) {
      throw Exception('Failed to download image');
    }

    return response.bodyBytes;
  }
}
