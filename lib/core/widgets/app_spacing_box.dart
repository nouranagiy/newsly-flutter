import 'package:flutter/material.dart';

import '../theme/app_spacing.dart';

class AppSpacingBox extends StatelessWidget {
  final double height;
  final double width;

  const AppSpacingBox({super.key, this.height = 0, this.width = 0});

  const AppSpacingBox.h({super.key, this.height = AppSpacing.md}) : width = 0;

  const AppSpacingBox.w({super.key, this.width = AppSpacing.md}) : height = 0;

  @override
  Widget build(BuildContext context) => SizedBox(width: width, height: height);
}
