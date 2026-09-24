import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/app_spacing_box.dart';
import '../../l10n/app_localizations.dart';

/// Saved / liked / disliked counts shown on the profile header.
class ProfileStatsRow extends StatelessWidget {
  final int saved;
  final int liked;
  final int disliked;

  const ProfileStatsRow({
    super.key,
    required this.saved,
    required this.liked,
    required this.disliked,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AppCard(
      child: Row(
        children: [
          _ProfileStat(
            value: '$saved',
            label: l10n.saved,
            icon: Icons.bookmark_rounded,
            color: context.palette.primary,
          ),
          _ProfileStat(
            value: '$liked',
            label: l10n.liked,
            icon: Icons.thumb_up_rounded,
            color: context.palette.success,
          ),
          _ProfileStat(
            value: '$disliked',
            label: l10n.disliked,
            icon: Icons.thumb_down_rounded,
            color: context.palette.error,
          ),
        ],
      ),
    );
  }
}

class _ProfileStat extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  final Color color;

  const _ProfileStat({
    required this.value,
    required this.label,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Expanded(
      child: Column(
        children: [
          Icon(icon, size: 20, color: color),
          const AppSpacingBox.h(height: AppSpacing.sm),
          Text(
            value,
            style: textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const AppSpacingBox.h(height: AppSpacing.xs),
          Text(
            label,
            style: textTheme.labelSmall?.copyWith(
              color: context.palette.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}
