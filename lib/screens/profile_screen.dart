import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/locale_controller.dart';
import '../core/theme/theme_controller.dart';
import '../core/widgets/app_card.dart';
import '../core/widgets/app_error_state.dart';
import '../core/widgets/app_header.dart';
import '../core/widgets/app_loading.dart';
import '../core/widgets/app_section_header.dart';
import '../core/widgets/app_spacing_box.dart';
import '../core/widgets/app_tag.dart';
import '../cubit/account_cubit.dart';
import '../cubit/account_state.dart';
import '../data/models/user_profile.dart';
import '../l10n/app_localizations.dart';
import '../l10n/text.dart';
import 'onboarding_screen.dart';
import 'widgets/profile_avatar.dart';
import 'widgets/profile_stats.dart';

/// Signed-in user's profile: identity, interaction stats, interests and
/// account actions (theme, language, sign out).
class ProfileScreen extends StatelessWidget {
  final ThemeController? themeController;
  final LocaleController? localeController;

  const ProfileScreen({super.key, this.themeController, this.localeController});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppHeader(title: l10n.tabProfile, showMark: false),
      body: BlocBuilder<AccountCubit, AccountState>(
        builder: (context, state) {
          return switch (state) {
            AccountLoading() => AppLoading(message: l10n.loadingProfile),
            AccountFailure() => AppErrorState(
              message: accountErrorMessage(l10n, state.error),
              onRetry: () => context.read<AccountCubit>().retry(),
            ),
            AccountReady() => _ProfileBody(
              profile: state.profile,
              saved: state.savedArticles.length,
              liked: state.likedIds.length,
              disliked: state.dislikedIds.length,
              themeController: themeController,
              localeController: localeController,
            ),
            _ => const SizedBox.shrink(),
          };
        },
      ),
    );
  }
}

class _ProfileBody extends StatelessWidget {
  final UserProfile profile;
  final int saved;
  final int liked;
  final int disliked;
  final ThemeController? themeController;
  final LocaleController? localeController;

  const _ProfileBody({
    required this.profile,
    required this.saved,
    required this.liked,
    required this.disliked,
    this.themeController,
    this.localeController,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final textTheme = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context);
    final brightness = Theme.of(context).brightness;

    return ListView(
      padding: AppSpacing.screen,
      children: [
        const AppSpacingBox.h(height: AppSpacing.sm),
        Row(
          children: [
            ProfileAvatar(initials: initialsFor(profile.name, profile.email)),
            const AppSpacingBox.w(width: AppSpacing.lg),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    profile.name,
                    style: textTheme.titleLarge?.copyWith(
                      color: palette.textPrimary,
                    ),
                  ),
                  const AppSpacingBox.h(height: AppSpacing.xs),
                  Text(
                    profile.email,
                    style: textTheme.bodySmall?.copyWith(
                      color: palette.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const AppSpacingBox.h(height: AppSpacing.xl),
        ProfileStatsRow(saved: saved, liked: liked, disliked: disliked),
        const AppSpacingBox.h(height: AppSpacing.xl),
        AppSectionHeader(
          title: l10n.interests,
          trailing: TextButton.icon(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const OnboardingScreen(isEditing: true),
              ),
            ),
            icon: const Icon(Icons.edit_outlined, size: 16),
            label: Text(l10n.edit),
          ),
        ),
        const AppSpacingBox.h(height: AppSpacing.sm),
        if (profile.preferredCategories.isEmpty)
          AppCard(
            child: Text(
              l10n.emptyInterests,
              style: textTheme.bodySmall?.copyWith(
                color: palette.textSecondary,
              ),
            ),
          )
        else
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              for (final slug in profile.preferredCategories)
                AppTag.info(context, categoryLabel(l10n, slug)),
            ],
          ),
        const AppSpacingBox.h(height: AppSpacing.xl),
        AppSectionHeader(title: l10n.preferences),
        const AppSpacingBox.h(height: AppSpacing.sm),
        AppCard(
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(
              brightness == Brightness.dark
                  ? Icons.dark_mode_rounded
                  : Icons.light_mode_rounded,
              color: palette.primary,
            ),
            title: Text(l10n.darkMode),
            subtitle: Text(
              l10n.darkModeSubtitle,
              style: textTheme.bodySmall?.copyWith(
                color: palette.textSecondary,
              ),
            ),
            trailing: Switch(
              value: brightness == Brightness.dark,
              onChanged: (_) => themeController?.toggle(),
            ),
          ),
        ),
        const AppSpacingBox.h(height: AppSpacing.md),
        AppCard(
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.language_rounded, color: palette.primary),
            title: Text(l10n.language),
            subtitle: Text(
              l10n.languageSubtitle,
              style: textTheme.bodySmall?.copyWith(
                color: palette.textSecondary,
              ),
            ),
            trailing: SegmentedButton<Locale>(
              showSelectedIcon: false,
              style: ButtonStyle(
                visualDensity: VisualDensity.compact,
                backgroundColor: WidgetStateProperty.resolveWith(
                  (states) => states.contains(WidgetState.selected)
                      ? palette.primarySoft
                      : palette.surfaceMuted,
                ),
                foregroundColor: WidgetStateProperty.resolveWith(
                  (states) => states.contains(WidgetState.selected)
                      ? palette.primary
                      : palette.textSecondary,
                ),
              ),
              segments: const [
                ButtonSegment(value: Locale('en'), label: Text('EN')),
                ButtonSegment(value: Locale('ar'), label: Text('عربي')),
              ],
              selected: {localeController?.value ?? const Locale('en')},
              onSelectionChanged: (selection) =>
                  localeController?.setLocale(selection.first),
            ),
          ),
        ),
        const AppSpacingBox.h(height: AppSpacing.xl),
        AppCard(
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.logout_rounded, color: palette.error),
            title: Text(
              l10n.signOut,
              style: textTheme.bodyMedium?.copyWith(color: palette.error),
            ),
            onTap: () => context.read<AccountCubit>().signOut(),
          ),
        ),
        const AppSpacingBox.h(height: AppSpacing.xl),
      ],
    );
  }
}
