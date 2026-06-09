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
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              const SizedBox(height: 100), // Pushes content below the floating top bar
              Expanded(
                child: BlocBuilder<NavigationCubit, NavigationTab>(
                  builder: (context, state) {
                    switch (state) {
                      case NavigationTab.home: return const HomeTab();
                      case NavigationTab.learn: return const LearnTab();
                      case NavigationTab.progress: return const ProgressTab();
                    }
                  },
                ),
              ),
              const SizedBox(height: 80),
            ],
          ),

          const Positioned(
            bottom: 0, left: 0, right: 0,
            child: BottomNavChips(),
          ),

          const Positioned(
            top: 0, left: 0, right: 0,
            child: TopUserBar(),
          ),
        ],
      ),
    );
  }
}