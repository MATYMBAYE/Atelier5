import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../repositories/post_repository.dart';
import '../models/post.dart';

class FormScreen extends StatefulWidget {
  final Post? postToEdit;

  const FormScreen({super.key, this.postToEdit});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _titleController =
      TextEditingController();
  final TextEditingController _bodyController =
      TextEditingController();

  @override
  void initState() {
    super.initState();

    // ✅ Remplir champs si modification
    if (widget.postToEdit != null) {
      _titleController.text = widget.postToEdit!.title;
      _bodyController.text = widget.postToEdit!.body;
    }
  }

  // ✅ Fonction sauvegarde UNIQUE
  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final repo = context.read<PostRepository>();

    final post = Post(
      id: widget.postToEdit?.id,
      title: _titleController.text,
      body: _bodyController.text,
    );

    if (widget.postToEdit == null) {
      // AJOUT
      await repo.addPost(post);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Post ajouté avec succès'),
          ),
        );
      }
    } else {
      // MODIFICATION
      await repo.updatePost(post);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✏️ Post modifié avec succès'),
          ),
        );
      }
    }

    // ✅ Retour avec résultat
    if (mounted) {
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.postToEdit == null
              ? "Ajouter un post"
              : "Modifier le post",
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration:
                    const InputDecoration(labelText: "Titre"),
                validator: (value) =>
                    value == null || value.isEmpty
                        ? "Entrez un titre"
                        : null,
              ),

              TextFormField(
                controller: _bodyController,
                decoration:
                    const InputDecoration(labelText: "Contenu"),
                maxLines: 5,
                validator: (value) =>
                    value == null || value.isEmpty
                        ? "Entrez du contenu"
                        : null,
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: _save,
                child: Text(
                  widget.postToEdit == null
                      ? "Ajouter"
                      : "Modifier",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}