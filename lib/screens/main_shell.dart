import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/locale_controller.dart';
import '../core/theme/theme_controller.dart';
import '../l10n/app_localizations.dart';
import 'home_screen.dart';
import 'profile_screen.dart';
import 'saved_screen.dart';

/// Bottom navigation shell: Home (For You / Top Stories), Saved and Profile.
/// IndexedStack keeps the feed state alive while switching tabs.
class MainShell extends StatefulWidget {
  final ThemeController? themeController;
  final LocaleController? localeController;

  const MainShell({super.key, this.themeController, this.localeController});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: [
          const HomeScreen(),
          const SavedScreen(),
          ProfileScreen(
            themeController: widget.themeController,
            localeController: widget.localeController,
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        backgroundColor: palette.surface,
        indicatorColor: palette.primarySoft,
        selectedIndex: _index,
        onDestinationSelected: (value) => setState(() => _index = value),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: const Icon(Icons.home_rounded),
            label: l10n.tabHome,
          ),
          NavigationDestination(
            icon: const Icon(Icons.bookmark_border_rounded),
            selectedIcon: const Icon(Icons.bookmark_rounded),
            label: l10n.tabSaved,
          ),
          NavigationDestination(
            icon: const Icon(Icons.person_outline_rounded),
            selectedIcon: const Icon(Icons.person_rounded),
            label: l10n.tabProfile,
          ),
        ],
      ),
    );
  }
}
