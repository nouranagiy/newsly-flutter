import 'package:flutter/material.dart';

import 'brand_mark.dart';

class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showMark;
  final List<Widget> actions;

  const AppHeader({
    super.key,
    required this.title,
    this.showMark = true,
    this.actions = const [],
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showMark) ...[
            const BrandMark(size: 26),
            const SizedBox(width: 10),
          ],
          Text(title),
        ],
      ),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
