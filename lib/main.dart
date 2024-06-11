import 'dart:async';

import 'package:clover/clover.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart';

import 'view_models.dart';
import 'views.dart';

void main() {
  Logger.root.level = Level.INFO;
  runZonedGuarded(onStartUp, onUncaughtError);
}

void onStartUp() {
  final app = ViewModelBinding(
    viewBuilder: (context) => AppView(
      routerConfig: GoRouter(
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => ViewModelBinding(
              viewBuilder: (context) => const HomeView(),
              viewModelBuilder: (context) => HomeViewModel(),
            ),
          ),
        ],
      ),
    ),
    viewModelBuilder: (context) => AppViewModel(),
  );
  runApp(app);
  // Set up system UI overlay style.
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  const systemUIOverlayStyle = SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    systemNavigationBarColor: Colors.transparent,
  );
  SystemChrome.setSystemUIOverlayStyle(systemUIOverlayStyle);
}

void onUncaughtError(Object error, StackTrace stackTrace) {
  Logger.root.severe('onUncaughtError', error, stackTrace);
}
