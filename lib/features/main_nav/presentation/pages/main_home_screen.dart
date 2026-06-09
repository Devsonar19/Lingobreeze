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
                    return AnimatedSwitcher(
                      duration: const Duration(milliseconds: 400), // Slightly longer for premium feel
                      switchInCurve: Curves.easeOutCubic, // Starts fast, slows down smoothly
                      switchOutCurve: Curves.easeInCubic, // Slowly accelerates out
                      transitionBuilder: (Widget child, Animation<double> animation) {

                        // 1. The Fade Effect
                        final fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(animation);

                        // 2. The Slide Effect (Slides up slightly from the bottom)
                        final slideAnimation = Tween<Offset>(
                          begin: const Offset(0.0, 0.05), // Starts 5% lower
                          end: Offset.zero, // Ends exactly in position
                        ).animate(animation);

                        return FadeTransition(
                          opacity: fadeAnimation,
                          child: SlideTransition(
                            position: slideAnimation,
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