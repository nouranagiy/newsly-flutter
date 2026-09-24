import 'package:flutter/material.dart';

class ThemeController extends ValueNotifier<ThemeMode> {
  ThemeController([super.value = ThemeMode.light]);

  void toggle() {
    final platformBrightness =
        WidgetsBinding.instance.platformDispatcher.platformBrightness;
    value = switch (value) {
      ThemeMode.light => ThemeMode.dark,
      ThemeMode.dark => ThemeMode.light,
      ThemeMode.system =>
        platformBrightness == Brightness.dark
            ? ThemeMode.light
            : ThemeMode.dark,
    };
  }
}
