import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'presentation/blocs/movie/movie_bloc.dart';
import 'presentation/blocs/tv/tv_bloc.dart';
import 'presentation/pages/home_page.dart';
import 'presentation/themes/colors.dart';

void main() {
  Timer(
    const Duration(milliseconds: 1200),
    () => runApp(const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => MovieBloc(),
        ),
        BlocProvider(
          create: (context) => TvBloc(),
        ),
      ],
      child: MaterialApp(
        themeMode: ThemeMode.dark,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: primary),
          useMaterial3: true,
        ),
        home: const HomePage(),
      ),
    );
  }
}
