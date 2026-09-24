import 'package:flutter/material.dart';

abstract final class AppRadius {
  static const double sm = 10;
  static const double md = 14;
  static const double lg = 20;
  static const double pill = 1000;

  static const BorderRadius button = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius input = BorderRadius.all(Radius.circular(md));
  static const BorderRadius card = BorderRadius.all(Radius.circular(lg));
}
