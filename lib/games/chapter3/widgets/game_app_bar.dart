import 'package:flutter/material.dart';
import 'theme.dart';


class GameAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const GameAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: DigitalTheme.surfaceBackground,
      elevation: 0,
      title: Text(
        title,
        style: DigitalTheme.subheadingStyle.copyWith(
          color: DigitalTheme.primaryCyan,
          fontSize: 16,
          letterSpacing: 1.5,
        ),
      ),
      leading: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(color: DigitalTheme.primaryCyan),
          borderRadius: BorderRadius.circular(4),
        ),
        child: IconButton(
          icon: const Icon(Icons.arrow_back, color: DigitalTheme.primaryCyan),
          onPressed: () => Navigator.pop(context),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}