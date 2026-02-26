import 'package:flutter/material.dart';
import '../models/post.dart';

class DetailScreen extends StatelessWidget {
  final Post post;

  const DetailScreen({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(post.title),

        // ✅ bouton modifier
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              final result = await Navigator.pushNamed(
                context,
                '/form',
                arguments: post,
              );

              // ✅ message succès après modification
              if (result == true && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('✏️ Modification enregistrée'),
                  ),
                );
              }
            },
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          post.body,
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}