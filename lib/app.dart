import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'repositories/post_repository.dart';
import 'screens/list_screen.dart';
import 'screens/form_screen.dart';
import 'screens/detail_screen.dart';
import 'models/post.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PostRepository(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'CRUD App',
        theme: ThemeData(useMaterial3: true),
        initialRoute: '/',
        routes: {
          '/': (_) => const ListScreen(),
          '/form': (_) => const FormScreen(),
        },
        // ⚡ Gestion de la route /detail avec arguments
        onGenerateRoute: (settings) {
          if (settings.name == '/detail') {
            final post = settings.arguments as Post;
            return MaterialPageRoute(
              builder: (_) => DetailScreen(post: post),
            );
          }
          return null;
        },
      ),
    );
  }
}