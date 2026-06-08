import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/navigation_cubit.dart';
import '../widgets/bottom_nav_chips.dart';
import '../widgets/top_user_bar.dart';

import '../../../vocabulary/presentation/pages/home_tab.dart';
import '../../../vocabulary/presentation/pages/learn_tab.dart';
import '../../../progress/presentation/pages/progress_tab.dart';

class MainHomeScreen extends StatelessWidget {
  const MainHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const TopUserBar(),
          Expanded(
            child: BlocBuilder<NavigationCubit, NavigationTab>(
              builder: (context, state) {
                // Switch the body based on the selected chip
                switch (state) {
                  case NavigationTab.home:
                    return const HomeTab(); // The Vocabulary List
                  case NavigationTab.learn:
                    return const LearnTab(); // Learn New Word Screen
                  case NavigationTab.progress:
                    return const ProgressTab(); // Analytics Screen
                }
              },
            ),
          ),
          const BottomNavChips(),
        ],
      ),
    );
  }
}