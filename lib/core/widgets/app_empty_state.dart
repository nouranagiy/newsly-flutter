import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import 'app_spacing_box.dart';

class AppEmptyState extends StatelessWidget {
  final String title;
  final String? message;
  final IconData icon;

  const AppEmptyState({
    super.key,
    required this.title,
    this.message,
    this.icon = Icons.search_off_rounded,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: palette.primarySoft,
                borderRadius: BorderRadius.circular(AppRadius.pill),
              ),
              child: Icon(icon, size: 32, color: palette.primary),
            ),
            const AppSpacingBox.h(height: AppSpacing.lg),
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            if (message != null) ...[
              const AppSpacingBox.h(height: AppSpacing.sm),
              Text(
                message!,
                textAlign: TextAlign.center,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: palette.textSecondary),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
