import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_theme.dart';
import '../core/theme/locale_controller.dart';
import '../core/theme/theme_controller.dart';
import '../core/widgets/app_error_state.dart';
import '../core/widgets/app_loading.dart';
import '../cubit/account_cubit.dart';
import '../cubit/account_state.dart';
import '../l10n/app_localizations.dart';
import '../l10n/text.dart';
import 'auth_screen.dart';
import 'main_shell.dart';
import 'onboarding_screen.dart';

/// Routes based on the account session:
/// signed out → auth | needs categories → onboarding | ready → main shell.
class AuthGate extends StatelessWidget {
  final ThemeController? themeController;
  final LocaleController? localeController;

  const AuthGate({super.key, this.themeController, this.localeController});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return BlocBuilder<AccountCubit, AccountState>(
      builder: (context, state) {
        return switch (state) {
          AccountLoading() => Theme(
            data: AppTheme.light(),
            child: Scaffold(
              backgroundColor: AppPalette.light.canvas,
              body: AppLoading(message: l10n.loadingProfile),
            ),
          ),
          AccountSignedOut() => const AuthScreen(),
          AccountNeedsOnboarding() => const OnboardingScreen(),
          AccountFailure() => AppErrorState(
            message: accountErrorMessage(l10n, state.error),
            onRetry: () => context.read<AccountCubit>().retry(),
          ),
          AccountReady() => MainShell(
            themeController: themeController,
            localeController: localeController,
          ),
        };
      },
    );
  }
}
