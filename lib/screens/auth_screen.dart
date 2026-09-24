import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/widgets/app_spacing_box.dart';
import '../core/widgets/brand_mark.dart';
import '../cubit/account_cubit.dart';
import '../l10n/app_localizations.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isSignUp = false;
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final cubit = context.read<AccountCubit>();
      if (_isSignUp) {
        await cubit.signUp(
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
      } else {
        await cubit.signIn(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
      }
    } on FirebaseAuthException catch (error) {
      if (mounted) {
        setState(
          () => _error = _messageFor(AppLocalizations.of(context), error),
        );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  String _messageFor(AppLocalizations l10n, FirebaseAuthException error) {
    return switch (error.code) {
      'invalid-email' => l10n.invalidEmail,
      'user-not-found' ||
      'wrong-password' ||
      'invalid-credential' => l10n.invalidCredentials,
      'email-already-in-use' => l10n.emailInUse,
      'weak-password' => l10n.weakPassword,
      'network-request-failed' || 'too-many-requests' => l10n.networkError,
      _ => error.message ?? l10n.genericError,
    };
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final textTheme = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: AppSpacing.screen,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Center(child: BrandMark(size: 44)),
                    const AppSpacingBox.h(height: AppSpacing.lg),
                    Text(
                      l10n.welcomeTitle,
                      textAlign: TextAlign.center,
                      style: textTheme.headlineMedium?.copyWith(
                        color: palette.textPrimary,
                      ),
                    ),
                    const AppSpacingBox.h(height: AppSpacing.sm),
                    Text(
                      _isSignUp ? l10n.signUpSubtitle : l10n.signInSubtitle,
                      textAlign: TextAlign.center,
                      style: textTheme.bodySmall?.copyWith(
                        color: palette.textSecondary,
                      ),
                    ),
                    const AppSpacingBox.h(height: AppSpacing.xl),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            if (_isSignUp) ...[
                              TextFormField(
                                controller: _nameController,
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                  hintText: l10n.nameHint,
                                  prefixIcon: const Icon(
                                    Icons.person_outline,
                                    size: 20,
                                  ),
                                ),
                                validator: (value) =>
                                    (value == null || value.trim().isEmpty)
                                    ? l10n.nameRequired
                                    : null,
                              ),
                              const AppSpacingBox.h(height: AppSpacing.md),
                            ],
                            TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                hintText: l10n.emailHint,
                                prefixIcon: const Icon(
                                  Icons.mail_outline_rounded,
                                  size: 20,
                                ),
                              ),
                              validator: (value) =>
                                  (value == null || !value.contains('@'))
                                  ? l10n.emailInvalid
                                  : null,
                            ),
                            const AppSpacingBox.h(height: AppSpacing.md),
                            TextFormField(
                              controller: _passwordController,
                              obscureText: true,
                              textInputAction: TextInputAction.done,
                              onFieldSubmitted: (_) => _submit(),
                              decoration: InputDecoration(
                                hintText: l10n.passwordHint,
                                prefixIcon: const Icon(
                                  Icons.lock_outline_rounded,
                                  size: 20,
                                ),
                              ),
                              validator: (value) =>
                                  (value == null || value.length < 6)
                                  ? l10n.passwordTooShort
                                  : null,
                            ),
                            if (_error != null) ...[
                              const AppSpacingBox.h(height: AppSpacing.md),
                              Text(
                                _error!,
                                style: textTheme.bodySmall?.copyWith(
                                  color: palette.error,
                                ),
                              ),
                            ],
                            const AppSpacingBox.h(height: AppSpacing.xl),
                            FilledButton(
                              onPressed: _busy ? null : _submit,
                              child: Text(
                                _busy
                                    ? l10n.pleaseWait
                                    : _isSignUp
                                    ? l10n.createAccount
                                    : l10n.signIn,
                              ),
                            ),
                            const AppSpacingBox.h(height: AppSpacing.sm),
                            TextButton(
                              onPressed: _busy
                                  ? null
                                  : () => setState(() {
                                      _isSignUp = !_isSignUp;
                                      _error = null;
                                    }),
                              child: Text(
                                _isSignUp
                                    ? l10n.switchToSignIn
                                    : l10n.switchToSignUp,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
