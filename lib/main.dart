import 'package:flutter/material.dart';

import 'presentation/pages/home/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tasks App',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        textTheme: TextTheme(
          titleMedium: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w600),
          bodyMedium: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 2),
          labelMedium: Theme.of(context).textTheme.labelMedium?.copyWith(fontSize: 16, fontWeight: FontWeight.w300, height: 1.5),
        ),
        textButtonTheme: const TextButtonThemeData(
          style: ButtonStyle(
            foregroundColor: MaterialStatePropertyAll(Colors.black),
            iconColor: MaterialStatePropertyAll(Colors.white),
          ),
        ),
      ),
      home: const Home(),
    );
  }
}
