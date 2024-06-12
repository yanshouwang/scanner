import 'package:clover/clover.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:rive/rive.dart' as rive;
import 'package:scanner/view_models.dart';

class AppView extends StatefulWidget {
  final RouterConfig<Object> routerConfig;

  const AppView({
    super.key,
    required this.routerConfig,
  });

  @override
  State<AppView> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  rive.SMIBool? _themeInput;

  bool get isDark {
    final themeMode = ViewModel.of<AppViewModel>(context).themeMode;
    if (themeMode == ThemeMode.system) {
      return MediaQuery.platformBrightnessOf(context) == Brightness.dark;
    }
    return themeMode == ThemeMode.dark;
  }

  @override
  Widget build(BuildContext context) {
    final theme = ThemeData.light();
    final darkTheme = ThemeData.dark();
    final viewModel = ViewModel.of<AppViewModel>(context);
    return MaterialApp.router(
      routerConfig: widget.routerConfig,
      // Localization
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      onGenerateTitle: (context) => AppLocalizations.of(context)!.appName,
      // Theme
      themeMode: viewModel.themeMode,
      theme: theme.copyWith(
        appBarTheme: theme.appBarTheme.copyWith(
          backgroundColor: theme.colorScheme.surface.withOpacity(0.0),
          foregroundColor: theme.colorScheme.onSurface,
        ),
        scaffoldBackgroundColor: theme.colorScheme.surface.withOpacity(0.0),
      ),
      darkTheme: darkTheme.copyWith(
        appBarTheme: darkTheme.appBarTheme.copyWith(
          backgroundColor: darkTheme.colorScheme.surface.withOpacity(0.0),
          foregroundColor: darkTheme.colorScheme.onSurface,
        ),
        scaffoldBackgroundColor: theme.colorScheme.surface.withOpacity(0.0),
      ),
      // Background
      builder: (context, child) {
        return Stack(
          children: [
            DecoratedBox(
              position: DecorationPosition.foreground,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Theme.of(context).colorScheme.surface.withOpacity(0.0),
                    Theme.of(context).colorScheme.surface,
                  ],
                ),
              ),
              child: rive.RiveAnimation.asset(
                'rivs/happycrm_greetings.riv',
                fit: BoxFit.cover,
                onInit: (artboard) {
                  final themeController =
                      rive.StateMachineController.fromArtboard(
                    artboard,
                    'State Machine 1',
                  );
                  if (themeController == null) {
                    return;
                  }
                  artboard.addController(themeController);
                  final themeInput =
                      themeController.getBoolInput('Theme toggled');
                  if (themeInput == null) {
                    return;
                  }
                  _themeInput = themeInput..value = isDark;
                },
              ),
            ),
            child!,
          ],
        );
      },
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final themeInput = _themeInput;
    if (themeInput == null) {
      return;
    }
    final isDark = this.isDark;
    debugPrint('isDark: $isDark');
    themeInput.value = isDark;
  }
}
