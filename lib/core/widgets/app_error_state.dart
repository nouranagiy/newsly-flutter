import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import 'app_spacing_box.dart';

class AppErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const AppErrorState({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final l10n = AppLocalizations.of(context);
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
                color: palette.errorSoft,
                borderRadius: BorderRadius.circular(AppRadius.pill),
              ),
              child: Icon(
                Icons.cloud_off_outlined,
                size: 34,
                color: palette.error,
              ),
            ),
            const AppSpacingBox.h(height: AppSpacing.lg),
            Text(
              l10n.errorTitle,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const AppSpacingBox.h(height: AppSpacing.sm),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: palette.textSecondary),
            ),
            const AppSpacingBox.h(height: AppSpacing.xl),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh, size: 18),
              label: Text(l10n.tryAgain),
            ),
          ],
        ),
      ),
    );
  }
}
