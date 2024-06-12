import 'package:clover/clover.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:scanner/view_models.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context)!;
    final appViewModel = ViewModel.of<AppViewModel>(context);
    final themeMode = appViewModel.themeMode;
    return Scaffold(
      appBar: AppBar(
        title: Text(appLocalizations.appName),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Spacer(),
          Container(
            margin: const EdgeInsets.only(bottom: 40.0),
            alignment: Alignment.bottomCenter,
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
}
