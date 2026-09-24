import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_radius.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_typography.dart';
import '../core/widgets/app_header.dart';
import '../core/widgets/app_spacing_box.dart';
import '../cubit/account_cubit.dart';
import '../cubit/account_state.dart';
import '../data/models/news_catalog.dart';
import '../l10n/app_localizations.dart';
import '../l10n/text.dart';

/// First-run category picker (shown right after sign-up) and, in edit mode,
/// the "change my interests" screen reachable from the Profile tab.
class OnboardingScreen extends StatefulWidget {
  final bool isEditing;

  const OnboardingScreen({super.key, this.isEditing = false});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  Set<String> _selected = {};
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    if (widget.isEditing) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final state = context.read<AccountCubit>().state;
        if (state is AccountReady) {
          setState(() => _selected = {...state.profile.preferredCategories});
        }
      });
    }
  }

  List<String> get _selectedSlugs => [
    for (final category in kNewsCategories)
      if (_selected.contains(category.slug)) category.slug,
  ];

  Future<void> _save(List<String> slugs) async {
    setState(() => _saving = true);
    await context.read<AccountCubit>().saveCategories(slugs);
    if (!mounted) return;
    setState(() => _saving = false);
    if (widget.isEditing) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final textTheme = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: widget.isEditing ? AppHeader(title: l10n.editInterests) : null,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!widget.isEditing)
              Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.pickInterestsTitle,
                      style: textTheme.headlineMedium?.copyWith(
                        color: palette.textPrimary,
                      ),
                    ),
                    const AppSpacingBox.h(height: AppSpacing.sm),
                    Text(
                      l10n.pickInterestsSubtitle,
                      style: textTheme.bodySmall?.copyWith(
                        color: palette.textSecondary,
                      ),
                    ),
                  ],
                ),
              )
            else
              Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Text(
                  l10n.editInterestsHint,
                  style: textTheme.bodySmall?.copyWith(
                    color: palette.textSecondary,
                  ),
                ),
              ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  0,
                  AppSpacing.lg,
                  AppSpacing.md,
                ),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: AppSpacing.md,
                  crossAxisSpacing: AppSpacing.md,
                  childAspectRatio: 3.0,
                ),
                itemCount: kNewsCategories.length,
                itemBuilder: (context, index) {
                  final category = kNewsCategories[index];
                  final selected = _selected.contains(category.slug);
                  return FilterChip(
                    label: Text(categoryLabel(l10n, category.slug)),
                    avatar: Icon(
                      category.icon,
                      size: 16,
                      color: selected ? palette.primary : palette.textSecondary,
                    ),
                    selected: selected,
                    selectedColor: palette.primarySoft,
                    checkmarkColor: palette.primary,
                    labelStyle:
                        AppTypography.textTheme(
                          Theme.of(context).brightness,
                        ).labelMedium?.copyWith(
                          color: selected
                              ? palette.primary
                              : palette.textPrimary,
                        ),
                    onSelected: (_) {
                      setState(() {
                        if (selected) {
                          _selected.remove(category.slug);
                        } else {
                          _selected.add(category.slug);
                        }
                      });
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  FilledButton(
                    onPressed: _selected.isEmpty || _saving
                        ? null
                        : () => _save(_selectedSlugs),
                    style: FilledButton.styleFrom(
                      minimumSize: const Size.fromHeight(48),
                      shape: RoundedRectangleBorder(
                        borderRadius: AppRadius.button,
                      ),
                    ),
                    child: Text(
                      _saving
                          ? l10n.saving
                          : widget.isEditing
                          ? l10n.saveChanges
                          : l10n.getStarted,
                    ),
                  ),
                  if (!widget.isEditing) ...[
                    const AppSpacingBox.h(height: AppSpacing.sm),
                    TextButton(
                      onPressed: _saving ? null : () => _save(const []),
                      child: Text(l10n.skipForNow),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
