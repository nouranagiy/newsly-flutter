import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/theme/app_spacing.dart';
import '../core/widgets/app_empty_state.dart';
import '../core/widgets/app_error_state.dart';
import '../core/widgets/app_header.dart';
import '../core/widgets/app_loading.dart';
import '../cubit/account_cubit.dart';
import '../cubit/account_state.dart';
import '../data/models/saved_article.dart';
import '../l10n/app_localizations.dart';
import '../l10n/text.dart';
import 'widgets/news_card.dart';

class SavedScreen extends StatelessWidget {
  const SavedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppHeader(title: l10n.tabSaved),
      body: BlocBuilder<AccountCubit, AccountState>(
        builder: (context, state) {
          return switch (state) {
            AccountLoading() => AppLoading(message: l10n.loadingSaved),
            AccountFailure() => AppErrorState(
              message: accountErrorMessage(l10n, state.error),
              onRetry: () => context.read<AccountCubit>().retry(),
            ),
            _ => _SavedList(
              items: state is AccountReady
                  ? state.savedArticles
                  : const <SavedArticle>[],
            ),
          };
        },
      ),
    );
  }
}

class _SavedList extends StatelessWidget {
  final List<SavedArticle> items;

  const _SavedList({required this.items});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (items.isEmpty) {
      return AppEmptyState(
        title: l10n.emptySavedTitle,
        message: l10n.emptySavedMessage,
        icon: Icons.bookmark_border_rounded,
      );
    }
    return ListView.separated(
      padding: AppSpacing.screen,
      itemCount: items.length,
      itemBuilder: (context, index) => NewsCard(article: items[index].article),
      separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
    );
  }
}
