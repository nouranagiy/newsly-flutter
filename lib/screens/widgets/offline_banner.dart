import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/widgets/app_spacing_box.dart';
import '../../core/widgets/app_tag.dart';
import '../../l10n/app_localizations.dart';

class OfflineBanner extends StatelessWidget {
  final String? message;

  const OfflineBanner({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final l10n = AppLocalizations.of(context);
    return Container(
      margin: AppSpacing.screen,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: palette.warningSoft,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: palette.warning.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.cloud_off_rounded, size: 20, color: palette.warning),
          const AppSpacingBox.w(width: AppSpacing.md),
          Expanded(
            child: Text(
              message ?? l10n.offlineBanner,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: palette.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const AppSpacingBox.w(width: AppSpacing.sm),
          AppTag.warning(context, l10n.offline),
        ],
      ),
    );
  }
}
