import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

// Core & Theme
import 'core/theme/app_theme.dart';
import 'core/theme/theme_cubit.dart';

// Navigation
import 'features/main_nav/presentation/cubit/navigation_cubit.dart';
import 'features/main_nav/presentation/pages/main_home_screen.dart';

// Vocabulary Feature
import 'features/vocabulary/data/datasources/vocabulary_remote_datasource.dart';
import 'features/vocabulary/data/repositories/vocabulary_repository_impl.dart';
import 'features/vocabulary/presentation/bloc/vocabulary_bloc.dart';
import 'firebase_options.dart';

void main() async {
  // 1. Ensure Flutter is ready before calling native code
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Initialize Firebase (Ensure you have run `flutterfire configure` if testing on mobile)
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );

  // 3. Dependency Injection Setup
  final firestore = FirebaseFirestore.instance;
  final httpClient = http.Client();

  final remoteDataSource = VocabularyRemoteDataSourceImpl(
    firestore: firestore,
    client: httpClient,
  );

  final vocabularyRepository = VocabularyRepositoryImpl(
    remoteDataSource: remoteDataSource,
  );

  runApp(
    LingoBreezeApp(vocabularyRepository: vocabularyRepository),
  );
}

class LingoBreezeApp extends StatelessWidget {
  final VocabularyRepositoryImpl vocabularyRepository;

  const LingoBreezeApp({
    super.key,
    required this.vocabularyRepository,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeCubit>(create: (_) => ThemeCubit()),
        BlocProvider<NavigationCubit>(create: (_) => NavigationCubit()),
        BlocProvider<VocabularyBloc>(
          create: (_) => VocabularyBloc(repository: vocabularyRepository),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp(
            title: 'LingoBreeze',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeMode,
            home: const MainHomeScreen(),
          );
        },
      ),
    );
  }
}