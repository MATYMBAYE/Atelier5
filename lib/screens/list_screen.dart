import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../repositories/post_repository.dart';
import 'detail_screen.dart';
import 'form_screen.dart';

class ListScreen extends StatelessWidget {
  const ListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = context.watch<PostRepository>();

    return Scaffold(
      appBar: AppBar(title: const Text("Liste des posts")),

      body: ListView.builder(
        itemCount: repo.posts.length,
        itemBuilder: (context, index) {
          final post = repo.posts[index];

          return Dismissible(
            key: Key(post.id.toString()),
            background: Container(color: Colors.red),

            // ✅ SUPPRESSION (swipe)
            onDismissed: (_) async {
              await repo.deletePost(post.id!);

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('🗑️ Post supprimé avec succès'),
                ),
              );
            },

            child: ListTile(
              title: Text(post.title),

              subtitle: Text(
                post.body.length > 50
                    ? '${post.body.substring(0, 50)}...'
                    : post.body,
              ),

              // ✅ DETAIL
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DetailScreen(post: post),
                  ),
                );
              },

              // ✅ MODIFIER
              trailing: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => FormScreen(postToEdit: post),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),

      // ✅ AJOUTER
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const FormScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}