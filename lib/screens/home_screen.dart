import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/feed_filter.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_theme.dart';
import '../core/widgets/app_error_state.dart';
import '../core/widgets/app_header.dart';
import '../core/widgets/app_loading.dart';
import '../cubit/account_cubit.dart';
import '../cubit/account_state.dart';
import '../cubit/news_cubit.dart';
import '../cubit/news_state.dart';
import '../l10n/app_localizations.dart';
import 'widgets/news_feed.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchController = TextEditingController();
  String _query = '';
  FeedMode _mode = FeedMode.forYou;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final cubit = context.read<NewsCubit>();
      if (cubit.state is NewsInitial) cubit.fetchNews();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppHeader(
        title: 'Newsly',
        actions: [
          IconButton(
            tooltip: AppLocalizations.of(context).clearSearch,
            onPressed: () => context.read<NewsCubit>().fetchNews(),
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: BlocBuilder<NewsCubit, NewsState>(
        builder: (context, state) {
          return switch (state) {
            NewsInitial() || NewsLoading() => Theme(
              data: AppTheme.light(),
              child: ColoredBox(
                color: AppPalette.light.canvas,
                child: SizedBox.expand(
                  child: AppLoading(
                    message: AppLocalizations.of(context).loadingNews,
                  ),
                ),
              ),
            ),
            NewsError() => AppErrorState(
              message: AppLocalizations.of(context).newsLoadError,
              onRetry: () => context.read<NewsCubit>().fetchNews(),
            ),
            NewsSuccess() => _buildFeed(state),
          };
        },
      ),
    );
  }

  Widget _buildFeed(NewsSuccess state) {
    return BlocBuilder<AccountCubit, AccountState>(
      builder: (context, account) {
        if (account is! AccountReady) {
          return AppLoading(
            message: AppLocalizations.of(context).preparingFeed,
          );
        }
        final visible = visibleNews(
          news: state.news,
          mode: _mode,
          preferredCategories: account.profile.preferredCategories.toSet(),
          dislikedIds: account.dislikedIds,
          query: _query,
        );
        return NewsFeed(
          news: visible,
          isOffline: state.isOffline,
          mode: _mode,
          onModeChanged: (mode) => setState(() => _mode = mode),
          query: _query,
          searchController: _searchController,
          onSearchChanged: (value) => setState(() => _query = value),
        );
      },
    );
  }
}
