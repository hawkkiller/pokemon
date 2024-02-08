import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sizzle_starter/src/core/localization/localization.dart';
import 'package:sizzle_starter/src/core/router/routes.dart';
import 'package:sizzle_starter/src/feature/app/widget/error_screen.dart';
import 'package:sizzle_starter/src/feature/pokemons/widget/pokemons_scope.dart';
import 'package:sizzle_starter/src/feature/settings/widget/settings_scope.dart';

/// {@template material_context}
/// [MaterialContext] is an entry point to the material context.
///
/// This widget sets locales, themes and routing.
/// {@endtemplate}
class MaterialContext extends StatefulWidget {
  /// {@macro material_context}
  const MaterialContext({super.key});

  // This global key is needed for [MaterialApp]
  // to work properly when Widgets Inspector is enabled.
  static final _globalKey = GlobalKey();

  @override
  State<MaterialContext> createState() => _MaterialContextState();
}

class _MaterialContextState extends State<MaterialContext> {
  late final GoRouter goRouter;

  @override
  void initState() {
    super.initState();
    goRouter = GoRouter(
      initialLocation: '/pokemons',
      routes: $appRoutes,
      restorationScopeId: 'pokemon_navigation',
      errorBuilder: errorScreenBuilder,
    );
  }

  @override
  void dispose() {
    goRouter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = SettingsScope.themeOf(context).theme;
    final locale = SettingsScope.localeOf(context).locale;

    return MaterialApp.router(
      key: MaterialContext._globalKey,
      restorationScopeId: 'pokemon_app',
      routerConfig: goRouter,
      debugShowCheckedModeBanner: false,
      theme: theme.lightTheme,
      darkTheme: theme.darkTheme,
      themeMode: theme.mode,
      localizationsDelegates: Localization.localizationDelegates,
      supportedLocales: Localization.supportedLocales,
      locale: locale,
      builder: (context, child) => MediaQuery.withClampedTextScaling(
        minScaleFactor: 1.0,
        maxScaleFactor: 2.0,
        child: PokemonsScope(child: child!),
      ),
    );
  }
}
