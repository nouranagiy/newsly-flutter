import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/widgets/app_header.dart';
import '../core/widgets/app_section_header.dart';
import '../core/widgets/app_spacing_box.dart';
import '../core/widgets/app_tag.dart';
import '../data/models/news_model.dart';
import '../l10n/app_localizations.dart';
import 'widgets/stat_card.dart';

class NewsDetailsScreen extends StatelessWidget {
  final NewsModel article;

  const NewsDetailsScreen({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final textTheme = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppHeader(title: l10n.newsDetails),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              article.title,
              style: textTheme.headlineMedium?.copyWith(
                color: palette.textPrimary,
              ),
            ),
            const AppSpacingBox.h(height: AppSpacing.md),
            if (article.tags.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: AppSpacing.xs),
                child: Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.sm,
                  children: article.tags
                      .map((tag) => AppTag.info(context, tag, showHash: true))
                      .toList(),
                ),
              ),
            const AppSpacingBox.h(height: AppSpacing.xl),
            Text(
              article.body,
              style: textTheme.bodyLarge?.copyWith(
                color: palette.textSecondary,
                height: 1.7,
              ),
            ),
            const AppSpacingBox.h(height: AppSpacing.xxl),
            AppSectionHeader(title: l10n.articleStats),
            const AppSpacingBox.h(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: StatCard(
                    icon: Icons.visibility_outlined,
                    value: '${article.views}',
                    label: l10n.views,
                    color: palette.primary,
                  ),
                ),
                const AppSpacingBox.w(width: AppSpacing.md),
                Expanded(
                  child: StatCard(
                    icon: Icons.thumb_up_alt_outlined,
                    value: '${article.likes}',
                    label: l10n.likes,
                    color: palette.success,
                  ),
                ),
                const AppSpacingBox.w(width: AppSpacing.md),
                Expanded(
                  child: StatCard(
                    icon: Icons.thumb_down_alt_outlined,
                    value: '${article.dislikes}',
                    label: l10n.dislikes,
                    color: palette.error,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
