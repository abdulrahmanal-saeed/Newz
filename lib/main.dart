import 'package:flutter/material.dart';
import 'package:newz/apptheme.dart';
import 'package:newz/view_models/category_view_model.dart';
import 'package:newz/view_models/news_view_model.dart';
import 'package:newz/views/splashscreen/splashscreen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const Newz());
}

class Newz extends StatelessWidget {
  const Newz({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CategoryViewModel()),
        ChangeNotifierProvider(create: (_) => NewsViewModel()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: {
          Splashscreen.routeName: (_) => const Splashscreen(),
        },
        theme: AppTheme.lightTheme,
        themeMode: ThemeMode.light,
      ),
    );
  }
}
