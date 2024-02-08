import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sizzle_starter/src/feature/pokemons/data/pokemons_repository.dart';
import 'package:sizzle_starter/src/feature/pokemons/model/pokemon.dart';

part 'pokemons_bloc.freezed.dart';

/// The event of the [PokemonsBloc].
@freezed
class PokemonsEvent with _$PokemonsEvent {
  /// The event when the pokemons are being fetched.
  const factory PokemonsEvent.fetchPokemons() = _FetchPokemons;
}

/// The state of the [PokemonsBloc].
@freezed
class PokemonsState with _$PokemonsState {
  const PokemonsState._();

  /// The idle state
  const factory PokemonsState.idle({
    @Default(<Pokemon>[]) List<Pokemon> pokemons,
  }) = _Idle;

  /// The state when the pokemons are being fetched.
  const factory PokemonsState.loading({
    @Default(<Pokemon>[]) List<Pokemon> pokemons,
  }) = _Loading;

  /// The state when the pokemons are fetched.
  const factory PokemonsState.loaded({
    required List<Pokemon> pokemons,
  }) = _Loaded;

  /// The state when the pokemons are not fetched.
  const factory PokemonsState.error({
    @Default(<Pokemon>[]) List<Pokemon> pokemons,
    Object? error,
  }) = _Error;

  /// Bloc error
  Object? get error => maybeMap(
        orElse: () => null,
        error: (e) => e.error,
      );
}

/// The pokemons bloc.
final class PokemonsBloc extends Bloc<PokemonsEvent, PokemonsState> {
  /// Creates a new pokemons bloc.
  PokemonsBloc({
    required this.repository,
    PokemonsState initialState = const PokemonsState.idle(),
  }) : super(initialState) {
    on<PokemonsEvent>(
      (event, emit) => event.map(
        fetchPokemons: (e) => _fetchPokemons(e, emit),
      ),
    );
  }

  /// The pokemons repository.
  final PokemonsRepository repository;

  Future<void> _fetchPokemons(
    _FetchPokemons event,
    Emitter<PokemonsState> emit,
  ) async {
    emit(const PokemonsState.loading());
    try {
      final pokemons = await repository.fetchPokemons();
      emit(PokemonsState.loaded(pokemons: pokemons));
    } catch (error) {
      emit(PokemonsState.error(error: error));
      rethrow;
    }
  }
}
