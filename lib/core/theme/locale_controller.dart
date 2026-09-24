import 'package:flutter/material.dart';

/// App-wide locale state so the user can switch language in-app.
/// Independent of the device locale; defaults to English.
class LocaleController {
  LocaleController({Locale initial = const Locale('en')})
    : _locale = ValueNotifier<Locale>(initial);

  final ValueNotifier<Locale> _locale;

  ValueNotifier<Locale> get locale => _locale;

  Locale get value => _locale.value;

  bool get isArabic => _locale.value.languageCode == 'ar';

  void setLocale(Locale locale) => _locale.value = locale;

  void toggle() {
    _locale.value = isArabic ? const Locale('en') : const Locale('ar');
  }

  void dispose() => _locale.dispose();
}
