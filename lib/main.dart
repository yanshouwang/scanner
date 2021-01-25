import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scanner/view.dart';

void main() {
  runApp(MyApp());
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final style =
        SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(style);

    return MaterialApp(
      home: HomeView(),
      theme: ThemeData.dark().copyWith(platform: TargetPlatform.iOS),
      routes: {
        'camerax': (context) => CameraView(),
        'show': (context) => ShowView(),
      },
      navigatorKey: navigatorKey,
    );
  }
}
