import 'package:flutter_bloc/flutter_bloc.dart';

enum NavigationTab { home, learn, progress }

class NavigationCubit extends Cubit<NavigationTab> {
  NavigationCubit() : super(NavigationTab.home);

  void selectTab(NavigationTab tab) => emit(tab);
}