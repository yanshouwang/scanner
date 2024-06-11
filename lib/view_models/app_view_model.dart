import 'package:clover/clover.dart';
import 'package:flutter/material.dart';

class AppViewModel extends ViewModel {
  ThemeMode _themeMode;

  AppViewModel() : _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;
  set themeMode(ThemeMode value) {
    _themeMode = value;
    notifyListeners();
  }
}
