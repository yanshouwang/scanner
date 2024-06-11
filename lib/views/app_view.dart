import 'package:clover/clover.dart';
import 'package:flutter/material.dart';
import 'package:scanner/view_models.dart';

class AppView extends StatelessWidget {
  final RouterConfig<Object> routerConfig;

  const AppView({
    super.key,
    required this.routerConfig,
  });

  @override
  Widget build(BuildContext context) {
    final viewModel = ViewModel.of<AppViewModel>(context);
    return MaterialApp.router(
      routerConfig: routerConfig,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: viewModel.themeMode,
    );
  }
}
