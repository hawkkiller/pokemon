import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sizzle_starter/src/core/router/routes.dart';


/// 
Widget errorScreenBuilder(BuildContext context, GoRouterState state) =>
    const ErrorScreen();

/// {@template error_screen}
/// Screen to be shown when the route is not found.
/// {@endtemplate}
class ErrorScreen extends StatelessWidget {
  /// {@macro error_screen}
  const ErrorScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Error: 404',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              Text(
                'Route not found',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              // This is a button to go back to the previous route.
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: FilledButton(
                  onPressed: () {
                    PokemonsRoute().go(context);
                  },
                  child: const Text('Go Home'),
                ),
              ),
            ],
          ),
        ),
      );
}
