import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proyecto_final/application/author_provider.dart';
import 'package:proyecto_final/domain/author.dart';

class AuthorScreen extends ConsumerWidget {
  const AuthorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authors = ref.watch(authorListProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text("Autores", style: TextStyle(color: Colors.yellow.shade100)),
        backgroundColor: Colors.yellow.shade900,
      ),
      body: Container(
        color: Colors.yellow.shade100,
        child: ListView.builder(
          itemCount: authors.length,
          itemBuilder: (_, index) {
            final author = authors[index];
            return ListTile(
              title: Text(author.name),
              subtitle: Text(author.country ?? ""),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () => _showForm(context, ref, author: author),
                    icon: Icon(Icons.edit, color: Colors.green.shade900),
                  ),
                  IconButton(
                    onPressed: () => _confirmDelete(context, ref, author),
                    icon: Icon(Icons.delete, color: Colors.red.shade900),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.yellow.shade900,
        onPressed: () => _showForm(context, ref),
        child: Icon(Icons.add, color: Colors.yellow.shade100),
      ),
    );
  }

  void _showForm(BuildContext context, WidgetRef ref, {Author? author}) {
    final nameController = TextEditingController(text: author?.name ?? "");
    final countryController = TextEditingController(
      text: author?.country ?? "",
    );
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text(author == null ? "Agregar autor" : "Editar autor"),
            content: Container(
              color: Colors.yellow.shade100,
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: "Nombre",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "El nombre no puede estar vacío";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 5),
                    TextFormField(
                      controller: countryController,
                      decoration: InputDecoration(
                        labelText: "País",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  "Cancelar",
                  style: TextStyle(color: Colors.yellow.shade900),
                ),
              ),
              TextButton(
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    final newAuthor = Author(
                      id: author?.id,
                      name: nameController.text,
                      country: countryController.text,
                    );
                    if (author == null) {
                      final exists = await ref
                          .read(authorListProvider.notifier)
                          .existsAuthorName(newAuthor.name);
                      if (!exists) {
                        ref
                            .read(authorListProvider.notifier)
                            .addAuthor(newAuthor);
                        Navigator.pop(context);
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text("Autor creado")));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "Error, el nombre de autor ya existe",
                            ),
                          ),
                        );
                      }
                    } else {
                      ref
                          .read(authorListProvider.notifier)
                          .updateAuthor(newAuthor);
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Autor actualizado")),
                      );
                    }
                  }
                },
                child: Text(
                  author == null ? "Guardar" : "Actualizar",
                  style: TextStyle(color: Colors.yellow.shade900),
                ),
              ),
            ],
          ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, Author author) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text("Eliminar autor"),
            content: Text(
              author.name,
              style: TextStyle(fontSize: 25),
              textAlign: TextAlign.center,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Cancelar"),
              ),
              TextButton(
                onPressed: () {
                  ref
                      .read(authorListProvider.notifier)
                      .deleteAuthor(author.id!);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text("Autor eliminado")));
                },
                child: Text("Eliminar"),
              ),
            ],
          ),
    );
  }
}
