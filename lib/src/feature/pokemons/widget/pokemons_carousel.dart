import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizzle_starter/src/feature/pokemons/model/pokemon.dart';
import 'package:sizzle_starter/src/feature/pokemons/widget/pokemons_scope.dart';

/// {@template pokemons_carousel}
/// PokemonsCarousel widget
/// {@endtemplate}
class PokemonsCarousel extends StatefulWidget {
  /// {@macro pokemons_carousel}
  const PokemonsCarousel({super.key});

  @override
  State<PokemonsCarousel> createState() => _PokemonsCarouselState();
}

class _PokemonsCarouselState extends State<PokemonsCarousel> {
  late final FixedExtentScrollController _controller;

  @override
  void initState() {
    super.initState();
    final pokemons = PokemonsScope.of(context, listen: false).pokemons;
    _controller = FixedExtentScrollController(
      initialItem: pokemons.length ~/ 2,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _scrollItem(int direction) {
    _controller.animateToItem(
      _controller.selectedItem + direction,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final pokemons = PokemonsScope.of(context).pokemons;

    return Dialog(
      child: Shortcuts(
        shortcuts: {
          LogicalKeySet(LogicalKeyboardKey.arrowLeft):
              const MoveSelectionIntent(-1),
          LogicalKeySet(LogicalKeyboardKey.arrowRight):
              const MoveSelectionIntent(1),
        },
        child: Actions(
          actions: {
            MoveSelectionIntent: CallbackAction<MoveSelectionIntent>(
              onInvoke: (intent) {
                _scrollItem(intent.direction);
                return null;
              },
            ),
          },
          child: Focus(
            autofocus: true,
            child: SizedBox(
              height: 500,
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios),
                    onPressed: () => _scrollItem(-1),
                  ),
                  Expanded(
                    child: RotatedBox(
                      quarterTurns: -1,
                      child: ListWheelScrollView.useDelegate(
                        controller: _controller,
                        physics: const FixedExtentScrollPhysics(),
                        itemExtent: 200,
                        childDelegate: ListWheelChildBuilderDelegate(
                          builder: (context, index) => RotatedBox(
                            quarterTurns: 1,
                            child: _PokemonCard(
                              pokemon: pokemons[index],
                            ),
                          ),
                          childCount: pokemons.length,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_forward_ios),
                    onPressed: () => _scrollItem(1),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PokemonCard extends StatelessWidget {
  const _PokemonCard({
    required this.pokemon,
  });

  final Pokemon pokemon;

  @override
  Widget build(BuildContext context) => Card(
        child: Tooltip(
          message: pokemon.name,
          child: Image.network(pokemon.image),
        ),
      );
}

/// MoveSelectionIntent is an intent that moves the selection in the carousel.
class MoveSelectionIntent extends Intent {
  /// MoveSelectionIntent constructor
  const MoveSelectionIntent(this.direction);

  /// The direction to move the selection.
  final int direction;
}
