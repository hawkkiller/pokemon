import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sizzle_starter/src/core/router/routes.dart';
import 'package:sizzle_starter/src/feature/pokemons/model/pokemon.dart';
import 'package:sizzle_starter/src/feature/pokemons/widget/pokemons_scope.dart';
import 'package:sizzle_starter/src/feature/settings/widget/settings_scope.dart';

enum _ViewType {
  grid,
  list;
}

/// Pokemons list screen.
class PokemonsScreen extends StatefulWidget {
  /// {@macro sample_page}
  const PokemonsScreen({super.key});

  @override
  State<PokemonsScreen> createState() => _PokemonsScreenState();
}

class _PokemonsScreenState extends State<PokemonsScreen> {
  _ViewType _viewType = _ViewType.grid;

  @override
  void initState() {
    super.initState();
    PokemonsScope.of(context, listen: false).fetchPokemons();
  }

  void _onPokemonPressed(Pokemon pokemon) =>
      PokemonRoute(id: pokemon.id).go(context);

  EdgeInsets _getHorizontalPadding(BuildContext context) =>
      EdgeInsets.symmetric(
        horizontal: max(
          16,
          (MediaQuery.of(context).size.width - 1200) / 2,
        ),
      );

  @override
  Widget build(BuildContext context) {
    final pokemonScope = PokemonsScope.of(context);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            actions: [
              IconButton(
                onPressed: () {
                  final theme = SettingsScope.themeOf(context);
                  theme.setThemeMode(
                    theme.theme.computeTheme().brightness == Brightness.light
                        ? ThemeMode.dark
                        : ThemeMode.light,
                  );
                },
                icon: SettingsScope.themeOf(context)
                            .theme
                            .computeTheme()
                            .brightness ==
                        Brightness.light
                    ? const Icon(Icons.dark_mode)
                    : const Icon(Icons.light_mode),
              ),
            ],
            title: Text(
              'Pokemons',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            expandedHeight: 96,
            flexibleSpace: FlexibleSpaceBar(
              background: Padding(
                padding: _getHorizontalPadding(context),
                child: Row(
                  children: [
                    _ViewTypeSwitcher(
                      viewType: _viewType,
                      onChanged: (viewType) {
                        setState(() => _viewType = viewType);
                      },
                    ),
                    const Spacer(),
                    TextButton.icon(
                      icon: const Icon(Icons.view_carousel),
                      label: const Text('Open Carousel'),
                      onPressed: () => PokemonsCarouselRoute().go(context),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: _getHorizontalPadding(context),
            sliver: switch (_viewType) {
              _ViewType.grid => _PokemonsGridList(
                  pokemons: pokemonScope.pokemons,
                  onTap: _onPokemonPressed,
                ),
              _ViewType.list => _PokemonsLinearList(
                  pokemons: pokemonScope.pokemons,
                  onTap: _onPokemonPressed,
                ),
            },
          ),
        ],
      ),
    );
  }
}

/// {@template pokemons_screen}
/// _ViewTypeSwitcher widget
/// {@endtemplate}
class _ViewTypeSwitcher extends StatelessWidget {
  /// {@macro pokemons_screen}
  const _ViewTypeSwitcher({
    required this.viewType,
    required this.onChanged,
  });

  final _ViewType viewType;
  final ValueChanged<_ViewType> onChanged;

  @override
  Widget build(BuildContext context) => Row(
        children: [
          IconButton(
            icon: const Icon(Icons.grid_on),
            onPressed: () => onChanged(_ViewType.grid),
            color: viewType == _ViewType.grid
                ? Theme.of(context).colorScheme.primary
                : null,
          ),
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: () => onChanged(_ViewType.list),
            color: viewType == _ViewType.list
                ? Theme.of(context).colorScheme.primary
                : null,
          ),
        ],
      );
}

/// {@template pokemons_screen}
/// _PokemonsGridList widget
/// {@endtemplate}
class _PokemonsGridList extends StatelessWidget {
  /// {@macro pokemons_screen}
  const _PokemonsGridList({
    required this.pokemons,
    required this.onTap,
  });

  final List<Pokemon> pokemons;
  final ValueChanged<Pokemon> onTap;

  @override
  Widget build(BuildContext context) => SliverGrid.builder(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 300,
          childAspectRatio: 300 / 350,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: pokemons.length,
        itemBuilder: (context, index) => _PokemonGridCard(
          pokemons[index],
          onTap,
        ),
      );
}

class _PokemonGridCard extends StatelessWidget {
  const _PokemonGridCard(this.pokemon, this.onTap);

  final Pokemon pokemon;
  final ValueChanged<Pokemon> onTap;

  @override
  Widget build(BuildContext context) => Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Stack(
          children: [
            Column(
              children: [
                Hero(
                  tag: 'pokemon-${pokemon.id}',
                  child: Image.network(pokemon.image),
                ),
                Text(
                  pokemon.name,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
            Positioned.fill(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => onTap(pokemon),
                ),
              ),
            ),
          ],
        ),
      );
}

/// {@template pokemons_screen}
/// _PokemonsLinearList widget
/// {@endtemplate}
class _PokemonsLinearList extends StatelessWidget {
  /// {@macro pokemons_screen}
  const _PokemonsLinearList({
    required this.pokemons,
    required this.onTap,
  });

  final List<Pokemon> pokemons;
  final ValueChanged<Pokemon> onTap;

  @override
  Widget build(BuildContext context) => SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) => _PokemonLinearTile(
            pokemons[index],
            onTap,
          ),
          childCount: pokemons.length,
        ),
      );
}

class _PokemonLinearTile extends StatelessWidget {
  const _PokemonLinearTile(this.pokemon, this.onTap);

  final Pokemon pokemon;
  final ValueChanged<Pokemon> onTap;

  @override
  Widget build(BuildContext context) => ListTile(
        tileColor: Theme.of(context).colorScheme.surface,
        leading: Hero(
          tag: 'pokemon-${pokemon.id}',
          child: Image.network(pokemon.image),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        title: Text(
          pokemon.name,
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        subtitle: Text(
          '${pokemon.jname} / ${pokemon.cname}',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        onTap: () => onTap(pokemon),
      );
}
