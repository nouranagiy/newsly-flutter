import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

/// Pill-shaped badge with a soft tinted background and matching text color.
class AppTag extends StatelessWidget {
  final String label;
  final Color foreground;
  final Color background;
  final bool showHash;

  const AppTag({
    super.key,
    required this.label,
    required this.foreground,
    required this.background,
    this.showHash = false,
  });

  AppTag.neutral(
    BuildContext context,
    String label, {
    Key? key,
    bool showHash = false,
  }) : this(
         key: key,
         label: label,
         showHash: showHash,
         foreground: context.palette.textSecondary,
         background: context.palette.surfaceMuted,
       );

  AppTag.info(
    BuildContext context,
    String label, {
    Key? key,
    bool showHash = false,
  }) : this(
         key: key,
         label: label,
         showHash: showHash,
         foreground: context.palette.primary,
         background: context.palette.primarySoft,
       );

  AppTag.success(
    BuildContext context,
    String label, {
    Key? key,
    bool showHash = false,
  }) : this(
         key: key,
         label: label,
         showHash: showHash,
         foreground: context.palette.success,
         background: context.palette.successSoft,
       );

  AppTag.warning(
    BuildContext context,
    String label, {
    Key? key,
    bool showHash = false,
  }) : this(
         key: key,
         label: label,
         showHash: showHash,
         foreground: context.palette.warning,
         background: context.palette.warningSoft,
       );

  AppTag.error(
    BuildContext context,
    String label, {
    Key? key,
    bool showHash = false,
  }) : this(
         key: key,
         label: label,
         showHash: showHash,
         foreground: context.palette.error,
         background: context.palette.errorSoft,
       );

  @override
  Widget build(BuildContext context) {
    final textStyle = AppTypography.textTheme(
      Theme.of(context).brightness,
    ).labelSmall?.copyWith(color: foreground, fontWeight: FontWeight.w600);
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm + 2,
        vertical: AppSpacing.xs + 1,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Text(
        showHash ? '#$label' : label,
        style: textStyle,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
