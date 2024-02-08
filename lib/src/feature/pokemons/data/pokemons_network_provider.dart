import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:sizzle_starter/src/feature/pokemons/model/pokemon.dart';

/// Pokemons data provider.
abstract interface class PokemonsDataProvider {
  /// Fetches pokemons from the data source
  Future<List<Pokemon>> fetchPokemons();
}

/// Pokemons network provider.
final class PokemonsNetworkProvider implements PokemonsDataProvider {
  /// Creates a new pokemons network provider.
  const PokemonsNetworkProvider({
    required this.client,
    required this.baseUrl,
  });

  /// The HTTP client.
  final http.Client client;

  /// The base URL.
  final String baseUrl;

  @override
  Future<List<Pokemon>> fetchPokemons() async {
    // japanese language
    final response = await client.get(
      Uri.parse('$baseUrl/pokemon.json'),
    );
    response.headers['content-type'] = 'application/json; charset=utf-8';

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as List<Object?>;
      return json
          .whereType<Map<String, Object?>>()
          .map(Pokemon.fromJson)
          .toList(growable: false);
    } else {
      throw Exception('Failed to load pokemons');
    }
  }
}
