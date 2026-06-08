import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/navigation_cubit.dart';

class BottomNavChips extends StatelessWidget {
  const BottomNavChips({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationCubit, NavigationTab>(
      builder: (context, currentTab) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          child: SafeArea(
            top: false,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildChip(context, "Home", Icons.home_rounded, NavigationTab.home, currentTab),
                _buildChip(context, "Learn", Icons.school_rounded, NavigationTab.learn, currentTab),
                _buildChip(context, "Progress", Icons.bar_chart_rounded, NavigationTab.progress, currentTab),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildChip(BuildContext context, String label, IconData icon, NavigationTab tab, NavigationTab currentTab) {
    final isSelected = tab == currentTab;
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () => context.read<NavigationCubit>().selectTab(tab),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutQuart,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? theme.primaryColor : theme.cardColor,
          borderRadius: BorderRadius.circular(30),
          boxShadow: isSelected
              ? [BoxShadow(color: theme.primaryColor.withOpacity(0.4), blurRadius: 12, offset: const Offset(0, 4))]
              : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 20, color: isSelected ? Colors.white : theme.textTheme.bodyMedium?.color),
            if (isSelected) ...[
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
              ),
            ]
          ],
        ),
      ),
    );
  }
}