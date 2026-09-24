import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_radius.dart';

/// Brand mark used across loading, error and empty states.
class BrandMark extends StatelessWidget {
  final double size;

  const BrandMark({super.key, this.size = 56});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [palette.primary, palette.accent],
        ),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      alignment: Alignment.center,
      child: Text(
        'N',
        style: TextStyle(
          color: palette.onPrimary,
          fontSize: size * 0.45,
          fontWeight: FontWeight.w800,
          height: 1,
        ),
      ),
    );
  }
}
