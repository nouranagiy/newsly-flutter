import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/network/api_service.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/locale_controller.dart';
import 'core/theme/theme_controller.dart';
import 'cubit/account_cubit.dart';
import 'cubit/news_cubit.dart';
import 'data/repositories/firebase_session_repository.dart';
import 'data/repositories/news_repository.dart';
import 'firebase_options.dart';
import 'l10n/app_localizations.dart';
import 'screens/auth_gate.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final sessionRepository = FirebaseSessionRepository();
  final newsRepository = NewsRepository(ApiService());

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => NewsCubit(newsRepository)..fetchNews()),
        BlocProvider(create: (_) => AccountCubit(sessionRepository)),
      ],
      child: const NewslyApp(),
    ),
  );
}

class NewslyApp extends StatefulWidget {
  final ThemeController? themeController;
  final LocaleController? localeController;

  const NewslyApp({super.key, this.themeController, this.localeController});

  @override
  State<NewslyApp> createState() => _NewslyAppState();
}

class _NewslyAppState extends State<NewslyApp> {
  late final ThemeController _themeController;
  late final LocaleController _localeController;

  @override
  void initState() {
    super.initState();
    _themeController = widget.themeController ?? ThemeController();
    _localeController = widget.localeController ?? LocaleController();
  }

  @override
  void dispose() {
    if (widget.themeController == null) {
      _themeController.dispose();
    }
    if (widget.localeController == null) {
      _localeController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: _themeController,
      builder: (context, mode, _) {
        return ValueListenableBuilder<Locale>(
          valueListenable: _localeController.locale,
          builder: (context, locale, _) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Newsly',
              theme: AppTheme.light(),
              darkTheme: AppTheme.dark(),
              themeMode: mode,
              locale: locale,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              home: AuthGate(
                themeController: _themeController,
                localeController: _localeController,
              ),
            );
          },
        );
      },
    );
  }
}
