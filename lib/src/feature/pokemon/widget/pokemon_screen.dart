import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sizzle_starter/src/feature/pokemons/model/pokemon.dart';
import 'package:sizzle_starter/src/feature/pokemons/widget/pokemons_scope.dart';

/// {@template pokemon_screen}
/// PokemonScreen widget
/// {@endtemplate}
class PokemonScreen extends StatefulWidget {
  /// {@macro pokemon_screen}
  const PokemonScreen({
    required this.id,
    super.key,
  });

  /// Pokemon id
  final int id;

  @override
  State<PokemonScreen> createState() => _PokemonScreenState();
}

class _PokemonScreenState extends State<PokemonScreen> {
  @override
  Widget build(BuildContext context) {
    final pokemon = PokemonsScope.of(context).findPokemonById(widget.id);

    if (pokemon == null) {
      return _PokemonNotFound(widget.id);
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: Text(pokemon.name),
            centerTitle: false,
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(
              horizontal: max(
                16,
                (MediaQuery.of(context).size.width - 1200) / 2,
              ),
            ),
            sliver: SliverToBoxAdapter(
              child: _PokemonProperties(pokemon: pokemon),
            ),
          ),
        ],
      ),
    );
  }
}

class _PokemonProperties extends StatelessWidget {
  const _PokemonProperties({
    required this.pokemon,
  });

  final Pokemon pokemon;

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Hero(
            tag: 'pokemon-${pokemon.id}',
            child: Image.network(
              pokemon.image,
            ),
          ),
          Text(
            pokemon.name,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          Text(
            '${pokemon.cname} / ${pokemon.jname}',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 24),
            child: Table(
              defaultColumnWidth: FixedColumnWidth(
                min(400, MediaQuery.of(context).size.width / 2.2),
              ),
              border: TableBorder.all(
                borderRadius: BorderRadius.circular(8),
                color: Theme.of(context).colorScheme.primary,
              ),
              children: [
                _TableRow(
                  title: 'Pokemon ID',
                  value: pokemon.id.toString(),
                ),
                _TableRow(title: 'English Name', value: pokemon.name),
                _TableRow(title: 'Chinese Name', value: pokemon.jname),
                _TableRow(title: 'Japanese Name', value: pokemon.jname),
                _TableRow(
                  title: 'Eggs',
                  value: pokemon.skills.egg.toString(),
                ),
                _TableRow(
                  title: 'Abilities',
                  value: pokemon.skills.levelUp.toString(),
                ),
                _TableRow(
                  title: 'TM',
                  value: pokemon.skills.tm.toString(),
                ),
                _TableRow(
                  title: 'Transfer',
                  value: pokemon.skills.transfer.toString(),
                ),
                _TableRow(
                  title: 'Tutor',
                  value: pokemon.skills.tutor.toString(),
                ),
              ],
            ),
          ),
        ],
      );
}

class _TableRow extends TableRow {
  const _TableRow({
    required this.title,
    required this.value,
  });

  final String title;
  final String value;

  @override
  List<Widget> get children => [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(title),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(value),
        ),
      ];
}

class _PokemonNotFound extends StatelessWidget {
  const _PokemonNotFound(this.id);

  final int id;

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Pokemon with id $id not found.',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: ElevatedButton(
                  onPressed: () {
                    GoRouter.of(context).pop();
                  },
                  child: const Text('Go Back'),
                ),
              ),
            ],
          ),
        ),
      );
}
