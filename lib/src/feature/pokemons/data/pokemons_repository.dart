import 'package:sizzle_starter/src/feature/pokemons/data/pokemons_network_provider.dart';
import 'package:sizzle_starter/src/feature/pokemons/model/pokemon.dart';

/// Pokemons repository.
abstract interface class PokemonsRepository {
  /// Fetches pokemons from the data source
  Future<List<Pokemon>> fetchPokemons();
}

/// Pokemons repository implementation.
final class PokemonsRepositoryImpl implements PokemonsRepository {
  /// Creates a new pokemons repository.
  const PokemonsRepositoryImpl({
    required this.dataProvider,
  });

  /// The data provider.
  final PokemonsDataProvider dataProvider;

  // Currently, it only fetches pokemons from the data provider, but can save
  // pokemons to the local storage, or cache them.
  @override
  Future<List<Pokemon>> fetchPokemons() => dataProvider.fetchPokemons();
}
