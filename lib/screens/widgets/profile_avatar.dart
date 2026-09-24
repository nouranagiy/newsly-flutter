import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';

String initialsFor(String name, String email) {
  final trimmed = name.trim();
  if (trimmed.isNotEmpty) {
    final parts = trimmed.split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    return trimmed.substring(0, 1).toUpperCase();
  }
  return email.trim().isEmpty
      ? '?'
      : email.trim().substring(0, 1).toUpperCase();
}

/// Gradient avatars for the profile header.
class ProfileAvatar extends StatelessWidget {
  final String initials;

  const ProfileAvatar({super.key, required this.initials});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Container(
      width: 56,
      height: 56,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [palette.primary, palette.accent],
        ),
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Text(
        initials,
        style: TextStyle(
          color: palette.onPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w700,
          height: 1,
        ),
      ),
    );
  }
}
