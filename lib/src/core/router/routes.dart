// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sizzle_starter/src/feature/pokemon/widget/pokemon_screen.dart';
import 'package:sizzle_starter/src/feature/pokemons/widget/pokemons_carousel.dart';
import 'package:sizzle_starter/src/feature/pokemons/widget/pokemons_screen.dart';

part 'routes.g.dart';

/// PokemonsRoute is a route that displays the home screen.
///
/// The route in the root.
@TypedGoRoute<PokemonsRoute>(
  path: '/pokemons',
  routes: [
    TypedGoRoute<PokemonsCarouselRoute>(path: 'carousel'),
    TypedGoRoute<PokemonRoute>(path: ':id'),
  ],
)
class PokemonsRoute extends GoRouteData {
  @override
  Widget build(
    BuildContext context,
    GoRouterState state,
  ) =>
      const PokemonsScreen();
}

/// PokemonRoute is a route that displays the pokemon screen.
class PokemonRoute extends GoRouteData {
  /// Pokemon id
  final int id;

  /// PokemonRoute constructor
  PokemonRoute({required this.id});

  @override
  Widget build(
    BuildContext context,
    GoRouterState state,
  ) =>
      PokemonScreen(id: id);
}

/// PokemonsCarouselRoute is a route that displays the pokemons carousel.
class PokemonsCarouselRoute extends GoRouteData {
  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) =>
      DialogPage<void>(
        barrierColor: Theme.of(context).colorScheme.inverseSurface.withOpacity(
              0.8,
            ),
        builder: (BuildContext context) => const PokemonsCarousel(),
      );
}

class DialogPage<T> extends Page<T> {
  final WidgetBuilder builder;
  final bool useSafeArea;
  final bool barrierDismissible;

  final Offset? anchorPoint;
  final Color? barrierColor;
  final String? barrierLabel;
  final CapturedThemes? themes;
  final TraversalEdgeBehavior? traversalEdgeBehavior;

  const DialogPage({
    required this.builder,
    this.barrierDismissible = true,
    this.useSafeArea = true,
    this.anchorPoint,
    this.barrierColor,
    this.barrierLabel,
    this.themes,
    this.traversalEdgeBehavior,
    super.name,
    super.arguments,
    super.restorationId,
    super.key,
  });

  @override
  Route<T> createRoute(BuildContext context) => DialogRoute<T>(
        context: context,
        settings: this,
        builder: builder,
        anchorPoint: anchorPoint,
        barrierColor: barrierColor,
        barrierDismissible: barrierDismissible,
        barrierLabel: barrierLabel,
        useSafeArea: useSafeArea,
        themes: themes,
        traversalEdgeBehavior: traversalEdgeBehavior,
      );
}
