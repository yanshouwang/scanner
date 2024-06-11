import 'package:clover/clover.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:scanner/view_models.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  SMIBool? _themeInput;

  bool get isDark {
    final themeMode = ViewModel.of<AppViewModel>(context).themeMode;
    if (themeMode == ThemeMode.system) {
      return MediaQuery.platformBrightnessOf(context) == Brightness.dark;
    }
    return themeMode == ThemeMode.dark;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final appViewModel = ViewModel.of<AppViewModel>(context);
    final themeMode = appViewModel.themeMode;
    return Scaffold(
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          RiveAnimation.asset(
            'rivs/happycrm_greetings.riv',
            fit: BoxFit.cover,
            onInit: (artboard) {
              final themeController = StateMachineController.fromArtboard(
                artboard,
                'State Machine 1',
              );
              if (themeController == null) {
                return;
              }
              artboard.addController(themeController);
              final themeInput = themeController.getBoolInput('Theme toggled');
              if (themeInput == null) {
                return;
              }
              _themeInput = themeInput..value = isDark;
            },
          ),
          Container(
            margin: const EdgeInsets.only(top: 40.0),
            child: SegmentedButton(
              emptySelectionAllowed: false,
              multiSelectionEnabled: false,
              showSelectedIcon: false,
              onSelectionChanged: (mode) {
                appViewModel.themeMode = mode.single;
              },
              segments: ThemeMode.values
                  .map((mode) => ButtonSegment(
                        value: mode,
                        label: Text('$mode'.split('.').last.toUpperCase()),
                      ))
                  .toList(),
              selected: {themeMode},
            ),
          ),
        ],
      ),
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
