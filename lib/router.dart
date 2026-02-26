// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/post.dart';
import 'repositories/post_repository.dart';
import 'screens/list_screen.dart';
import 'screens/form_screen.dart';
import 'screens/detail_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => PostRepository(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Posts App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (_) => const ListScreen(),
        '/form': (_) => const FormScreen(),
      },
      // ⚡ Utilisation de onGenerateRoute pour passer des arguments à DetailScreen
      onGenerateRoute: (settings) {
        if (settings.name == '/detail') {
          final post = settings.arguments as Post;
          return MaterialPageRoute(
            builder: (_) => DetailScreen(post: post),
          );
        }
        return null;
      },
    );
  }
}