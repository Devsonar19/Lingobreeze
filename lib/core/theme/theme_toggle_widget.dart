import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'theme_cubit.dart';

class ThemeToggleWidget extends StatelessWidget {
  const ThemeToggleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, currentTheme) {
        IconData currentIcon = Icons.brightness_auto_rounded;
        if (currentTheme == ThemeMode.light) currentIcon = Icons.light_mode_rounded;
        if (currentTheme == ThemeMode.dark) currentIcon = Icons.dark_mode_rounded;

        return PopupMenuButton<ThemeMode>(
          icon: Icon(currentIcon, color: Theme.of(context).textTheme.bodyLarge?.color),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          color: Theme.of(context).cardColor,
          offset: const Offset(0, 40),
          onSelected: (ThemeMode mode) {
            context.read<ThemeCubit>().setTheme(mode);
          },
          itemBuilder: (BuildContext context) {
            final theme = Theme.of(context);
            final primary = theme.primaryColor;
            final textCol = theme.textTheme.bodyLarge?.color;

            return <PopupMenuEntry<ThemeMode>>[
              _buildThemeMenuItem(
                value: ThemeMode.system,
                label: "System",
                icon: Icons.brightness_auto_rounded,
                isSelected: currentTheme == ThemeMode.system,
                primaryColor: primary,
                textColor: textCol,
              ),
              _buildThemeMenuItem(
                value: ThemeMode.light,
                label: "Light",
                icon: Icons.light_mode_rounded,
                isSelected: currentTheme == ThemeMode.light,
                primaryColor: primary,
                textColor: textCol,
              ),
              _buildThemeMenuItem(
                value: ThemeMode.dark,
                label: "Dark",
                icon: Icons.dark_mode_rounded,
                isSelected: currentTheme == ThemeMode.dark,
                primaryColor: primary,
                textColor: textCol,
              ),
            ];
          },
        );
      },
    );
  }

  PopupMenuItem<ThemeMode> _buildThemeMenuItem({
    required ThemeMode value,
    required String label,
    required IconData icon,
    required bool isSelected,
    required Color primaryColor,
    Color? textColor,
  }) {
    return PopupMenuItem<ThemeMode>(
      value: value,
      child: Row(
        children: [
          Icon(icon, color: isSelected ? primaryColor : textColor?.withOpacity(0.7)),
          const SizedBox(width: 12),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? primaryColor : textColor,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}