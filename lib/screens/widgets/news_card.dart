import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/app_spacing_box.dart';
import '../../core/widgets/app_tag.dart';
import '../../cubit/account_cubit.dart';
import '../../cubit/account_state.dart';
import '../../data/models/news_model.dart';
import '../../l10n/app_localizations.dart';
import '../news_details_screen.dart';

class NewsCard extends StatelessWidget {
  final NewsModel article;

  const NewsCard({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final textTheme = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context);

    return BlocBuilder<AccountCubit, AccountState>(
      builder: (context, account) {
        final ready = account is AccountReady;
        final id = '${article.id}';
        final liked = ready && account.likedIds.contains(id);
        final disliked = ready && account.dislikedIds.contains(id);
        final saved = ready && account.savedArticleIds.contains(id);
        final cubit = context.read<AccountCubit>();

        return AppCard(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => NewsDetailsScreen(article: article),
              ),
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                article.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: textTheme.titleMedium,
              ),
              const AppSpacingBox.h(height: AppSpacing.sm),
              Text(
                article.body,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: textTheme.bodySmall?.copyWith(
                  color: palette.textSecondary,
                  height: 1.5,
                ),
              ),
              if (article.tags.isNotEmpty) ...[
                const AppSpacingBox.h(height: AppSpacing.md),
                Wrap(
                  spacing: AppSpacing.xs + 2,
                  runSpacing: AppSpacing.sm,
                  children: article.tags
                      .take(3)
                      .map(
                        (tag) => AppTag.neutral(context, tag, showHash: true),
                      )
                      .toList(),
                ),
              ],
              const AppSpacingBox.h(height: AppSpacing.md),
              Row(
                children: [
                  _Metric(
                    icon: Icons.visibility_outlined,
                    value: '${article.views}',
                    label: l10n.views,
                    color: palette.textMuted,
                  ),
                  const AppSpacingBox.w(width: AppSpacing.lg),
                  _Metric(
                    icon: Icons.thumb_up_outlined,
                    value: '${article.likes}',
                    label: l10n.likes,
                    color: palette.textMuted,
                  ),
                  const Spacer(),
                  const _ReadButton(),
                ],
              ),
              const AppSpacingBox.h(height: AppSpacing.md),
              Row(
                children: [
                  _ReactionButton(
                    tooltip: liked ? l10n.removeLike : l10n.like,
                    icon: liked
                        ? Icons.thumb_up_rounded
                        : Icons.thumb_up_outlined,
                    color: liked ? palette.success : palette.textMuted,
                    onPressed: () => cubit.toggleLike(article),
                  ),
                  _ReactionButton(
                    tooltip: disliked ? l10n.dislikedHidden : l10n.dislike,
                    icon: disliked
                        ? Icons.thumb_down_rounded
                        : Icons.thumb_down_outlined,
                    color: disliked ? palette.error : palette.textMuted,
                    onPressed: () => cubit.toggleDislike(article),
                  ),
                  _ReactionButton(
                    tooltip: saved ? l10n.removeBookmark : l10n.save,
                    icon: saved
                        ? Icons.bookmark_rounded
                        : Icons.bookmark_outline_rounded,
                    color: saved ? palette.primary : palette.textMuted,
                    onPressed: () => cubit.toggleSave(article),
                  ),
                  const Spacer(),
                  const _ReadButton(),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ReactionButton extends StatelessWidget {
  final String tooltip;
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  const _ReactionButton({
    required this.tooltip,
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: tooltip,
      onPressed: onPressed,
      padding: const EdgeInsets.all(6),
      icon: Icon(icon, size: 20, color: color),
    );
  }
}

class _Metric extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _Metric({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: color),
        const AppSpacingBox.w(width: AppSpacing.xs + 1),
        Text(
          value,
          style: AppTypography.textTheme(Theme.of(context).brightness)
              .labelSmall
              ?.copyWith(color: Theme.of(context).colorScheme.onSurface),
        ),
        const AppSpacingBox.w(width: AppSpacing.xs),
        Text(
          label,
          style: AppTypography.textTheme(
            Theme.of(context).brightness,
          ).labelSmall?.copyWith(color: color),
        ),
      ],
    );
  }
}

class _ReadButton extends StatelessWidget {
  const _ReadButton();

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs + 2,
      ),
      decoration: BoxDecoration(
        color: palette.primarySoft,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            l10n.read,
            style: AppTypography.textTheme(
              Theme.of(context).brightness,
            ).labelMedium?.copyWith(color: palette.primary),
          ),
          const AppSpacingBox.w(width: AppSpacing.xs),
          Icon(Icons.arrow_forward_rounded, size: 15, color: palette.primary),
        ],
      ),
    );
  }
}
