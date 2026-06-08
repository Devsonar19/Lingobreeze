import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/theme_cubit.dart';

class TopUserBar extends StatelessWidget {
  const TopUserBar({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor.withOpacity(0.8),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            const CircleAvatar(
              radius: 20,
              backgroundColor: Color(0xFF3498DB),
              child: Icon(Icons.person, color: Colors.white),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Good Morning,",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Text(
                    "Dev", // We can make this dynamic later with your Auth feature
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
              color: Theme.of(context).textTheme.bodyLarge?.color,
              onPressed: () {
                context.read<ThemeCubit>().toggleTheme();
              },
            ),
            IconButton(
              icon: const Icon(Icons.logout),
              color: Theme.of(context).textTheme.bodyLarge?.color,
              onPressed: () {
                // TODO: Trigger Auth Bloc Logout Event
              },
            ),
          ],
        ),
      ),
    );
  }
}