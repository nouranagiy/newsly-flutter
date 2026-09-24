import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/feed_filter.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/app_empty_state.dart';
import '../../core/widgets/app_spacing_box.dart';
import '../../cubit/news_cubit.dart';
import '../../data/models/news_model.dart';
import '../../l10n/app_localizations.dart';
import 'news_card.dart';
import 'news_search_field.dart';
import 'offline_banner.dart';

class NewsFeed extends StatelessWidget {
  final List<NewsModel> news;
  final bool isOffline;
  final FeedMode mode;
  final ValueChanged<FeedMode> onModeChanged;
  final String query;
  final TextEditingController searchController;
  final ValueChanged<String> onSearchChanged;

  const NewsFeed({
    super.key,
    required this.news,
    required this.isOffline,
    required this.mode,
    required this.onModeChanged,
    required this.query,
    required this.searchController,
    required this.onSearchChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return RefreshIndicator(
      onRefresh: () => context.read<NewsCubit>().fetchNews(),
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          if (isOffline) const SliverToBoxAdapter(child: OfflineBanner()),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.md,
                AppSpacing.lg,
                0,
              ),
              child: NewsSearchField(
                controller: searchController,
                onChanged: onSearchChanged,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(
                top: AppSpacing.md,
                bottom: AppSpacing.xs,
              ),
              child: FeedModeToggle(mode: mode, onChanged: onModeChanged),
            ),
          ),
          if (news.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: AppEmptyState(
                title: mode == FeedMode.forYou
                    ? l10n.emptyForYouTitle
                    : l10n.emptyTopStoriesTitle,
                message: mode == FeedMode.forYou
                    ? l10n.emptyForYouMessage
                    : l10n.emptyTopStoriesMessage,
                icon: mode == FeedMode.forYou
                    ? Icons.tune_rounded
                    : Icons.article_outlined,
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                0,
                AppSpacing.lg,
                AppSpacing.xl,
              ),
              sliver: SliverList.separated(
                itemCount: news.length,
                itemBuilder: (context, index) => NewsCard(article: news[index]),
                separatorBuilder: (context, index) =>
                    const SizedBox(height: AppSpacing.md),
              ),
            ),
        ],
      ),
    );
  }
}

/// "For You" / "Top Stories" selector styled like the app's pill components.
class FeedModeToggle extends StatelessWidget {
  final FeedMode mode;
  final ValueChanged<FeedMode> onChanged;

  const FeedModeToggle({
    super.key,
    required this.mode,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Row(
      children: [
        Expanded(
          child: _ModePill(
            label: l10n.modeForYou,
            selected: mode == FeedMode.forYou,
            onTap: () => onChanged(FeedMode.forYou),
          ),
        ),
        const AppSpacingBox.w(width: AppSpacing.sm),
        Expanded(
          child: _ModePill(
            label: l10n.modeTopStories,
            selected: mode == FeedMode.topStories,
            onTap: () => onChanged(FeedMode.topStories),
          ),
        ),
      ],
    ).withPadding(AppSpacing.screen);
  }
}

class _ModePill extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _ModePill({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final brightness = Theme.of(context).brightness;
    final foreground = selected ? palette.onPrimary : palette.textSecondary;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        curve: Curves.easeOut,
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? palette.primary : palette.surface,
          borderRadius: BorderRadius.circular(AppRadius.pill),
          border: Border.all(
            color: selected ? palette.primary : palette.border,
          ),
        ),
        child: Text(
          label,
          style: AppTypography.textTheme(
            brightness,
          ).labelMedium?.copyWith(color: foreground),
        ),
      ),
    );
  }
}

extension on Widget {
  Widget withPadding(EdgeInsetsGeometry padding) =>
      Padding(padding: padding, child: this);
}
