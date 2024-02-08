import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:sizzle_starter/src/core/utils/extensions/context_extension.dart';
import 'package:sizzle_starter/src/feature/initialization/widget/dependencies_scope.dart';
import 'package:sizzle_starter/src/feature/pokemons/bloc/pokemons_bloc.dart';
import 'package:sizzle_starter/src/feature/pokemons/model/pokemon.dart';

/// Scope for pokemons.
class PokemonsScope extends StatefulWidget {
  /// Creates a new pokemons scope.
  const PokemonsScope({
    required this.child,
    super.key,
  });

  /// The child widget.
  final Widget child;

  /// Obtain the scope state from the given [context].
  static PokemonsScopeState of(BuildContext context, {bool listen = true}) =>
      context.inhOf<_PokemonsInherited>(listen: listen).scopeState;

  @override
  State<PokemonsScope> createState() => PokemonsScopeState();
}

/// State for pokemons scope.
class PokemonsScopeState extends State<PokemonsScope> {
  late final PokemonsBloc _pokemonBloc;
  late final StreamSubscription<void> _pokemonBlocSubscription;
  var _pokemonBlocState = const PokemonsState.idle();

  @override
  void initState() {
    super.initState();
    _pokemonBloc = PokemonsBloc(
      repository: DependenciesScope.of(context).pokemonsRepository,
      initialState: _pokemonBlocState,
    );
    _pokemonBlocSubscription = _pokemonBloc.stream.listen(_didStateChanged);
  }

  @override
  void dispose() {
    _pokemonBloc.close();
    _pokemonBlocSubscription.cancel();
    super.dispose();
  }

  void _didStateChanged(PokemonsState state) {
    if (state != _pokemonBlocState) {
      setState(() => _pokemonBlocState = state);
    }
  }

  /// The list of pokemons.
  List<Pokemon> get pokemons => _pokemonBlocState.pokemons;

  /// The error message.
  String? get error {
    final error = _pokemonBlocState.error;

    if (error != null) {
      return error.toString();
    }

    return null;
  }

  /// Fetch pokemons.
  void fetchPokemons() {
    _pokemonBloc.add(const PokemonsEvent.fetchPokemons());
  }

  /// Find pokemon by id.
  Pokemon? findPokemonById(int id) =>
      pokemons.firstWhereOrNull((pokemon) => pokemon.id == id);

  @override
  Widget build(BuildContext context) => _PokemonsInherited(
        state: _pokemonBlocState,
        scopeState: this,
        child: widget.child,
      );
}

class _PokemonsInherited extends InheritedWidget {
  const _PokemonsInherited({
    required super.child,
    required this.state,
    required this.scopeState,
  });

  final PokemonsState state;
  final PokemonsScopeState scopeState;

  @override
  bool updateShouldNotify(_PokemonsInherited oldWidget) =>
      state != oldWidget.state;
}
