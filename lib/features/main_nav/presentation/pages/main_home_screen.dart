import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../vocabulary/presentation/pages/progress_tab.dart';
import '../cubit/navigation_cubit.dart';
import '../widgets/bottom_nav_chips.dart';
import '../widgets/top_user_bar.dart';

import '../../../vocabulary/presentation/pages/home_tab.dart';
import '../../../vocabulary/presentation/pages/learn_tab.dart';

class MainHomeScreen extends StatelessWidget {
  const MainHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      // The solid background color
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          Positioned(
            top: -100, left: -100,
            child: Container(
              width: 300, height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDark ? Colors.blueAccent.withOpacity(0.2) : Colors.blue.withOpacity(0.3),
              ),
            ),
          ),
          Positioned(
            bottom: 100, right: -50,
            child: Container(
              width: 250, height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDark ? Colors.purpleAccent.withOpacity(0.2) : Colors.purple.withOpacity(0.2),
              ),
            ),
          ),

          Column(
            children: [
              const SizedBox(height: 100),
              Expanded(
                child: BlocBuilder<NavigationCubit, NavigationTab>(
                  builder: (context, state) {
                    // Smooth Transition Engine
                    return AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      switchInCurve: Curves.easeOutCubic,
                      switchOutCurve: Curves.easeInCubic,
                      transitionBuilder: (Widget child, Animation<double> animation) {
                        return FadeTransition(
                          opacity: animation,
                          child: ScaleTransition(
                            scale: Tween<double>(begin: 0.95, end: 1.0).animate(animation),
                            child: child,
                          ),
                        );
                      },
                      child: _buildTab(state),
                    );
                  },
                ),
              ),
              const SizedBox(height: 100),
            ],
          ),

          const Positioned(bottom: 24, left: 24, right: 24, child: BottomNavChips()),
          const Positioned(top: 0, left: 0, right: 0, child: TopUserBar()),
        ],
      ),
    );
  }

  Widget _buildTab(NavigationTab tab) {
    switch (tab) {
      case NavigationTab.home: return const HomeTab(key: ValueKey('home'));
      case NavigationTab.learn: return const LearnTab(key: ValueKey('learn'));
      case NavigationTab.progress: return const ProgressTab(key: ValueKey('progress'));
    }
  }
}