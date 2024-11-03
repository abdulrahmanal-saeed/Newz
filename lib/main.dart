import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newz/apptheme.dart';
import 'package:newz/bloc/category_bloc.dart';
import 'package:newz/bloc/news_bloc.dart';
import 'package:newz/repositories/news_repository.dart';
import 'package:newz/api/api_service.dart';
import 'package:newz/repositories/saved-articles_repository.dart';
import 'package:newz/views/splashscreen/splashscreen.dart';

void main() {
  runApp(const Newz());
}

class Newz extends StatelessWidget {
  const Newz({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => NewsRepository(APIService())),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
              create: (context) => NewsBloc(context.read<NewsRepository>())),
          BlocProvider(
              create: (context) =>
                  CategoryBloc(context.read<NewsRepository>())),
          RepositoryProvider(create: (context) => SavedArticlesRepository()),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          routes: {
            Splashscreen.routeName: (_) => const Splashscreen(),
          },
          theme: AppTheme.lightTheme,
          themeMode: ThemeMode.light,
        ),
      ),
    );
  }
}
