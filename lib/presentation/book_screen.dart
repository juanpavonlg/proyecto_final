import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proyecto_final/application/book_provider.dart';
import 'package:proyecto_final/domain/book.dart';

class BookScreen extends ConsumerWidget {
  const BookScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final books = ref.watch(bookListProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text("Libros", style: TextStyle(color: Colors.green.shade100)),
        backgroundColor: Colors.green.shade900,
      ),
      body: Container(
        color: Colors.green.shade100,
        child: ListView.builder(
          itemCount: books.length,
          itemBuilder: (_, index) {
            final book = books[index];
            return ListTile(
              title: Text(book.title),
              subtitle: Text(
                "${book.authorId} - \$${book.price.toStringAsFixed(2)} - ${book.stock} unidades",
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () => _showForm(context, ref, book: book),
                    icon: Icon(Icons.edit, color: Colors.green.shade900),
                  ),
                  IconButton(
                    onPressed: () => _confirmDelete(context, ref, book),
                    icon: Icon(Icons.delete, color: Colors.red.shade900),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green.shade900,
        onPressed: () => _showForm(context, ref),
        child: Icon(Icons.add, color: Colors.green.shade100),
      ),
    );
  }

  void _showForm(BuildContext context, WidgetRef ref, {Book? book}) {
    final idController = TextEditingController(text: book?.id ?? "");
    final titleController = TextEditingController(text: book?.title ?? "");
    final authorIdController = TextEditingController(
      text: book?.authorId.toString() ?? "",
    );
    final priceController = TextEditingController(
      text: book?.price.toString() ?? "",
    );
    final stockController = TextEditingController(
      text: book?.stock.toString() ?? "",
    );
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text(book == null ? "Agregar libro" : "Editar libro"),
            content: Container(
              color: Colors.green.shade100,
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: idController,
                            decoration: InputDecoration(
                              labelText: "Id",
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "El id no puede estar vacío";
                              }
                              return null;
                            },
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.qr_code_scanner),
                          onPressed: () async {
                            final result = await BarcodeScanner.scan();
                            if (result.type == ResultType.Barcode) {
                              idController.text = result.rawContent;
                            }
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    TextFormField(
                      controller: titleController,
                      decoration: InputDecoration(
                        labelText: "Título",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "El título no puede estar vacío";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 5),
                    TextFormField(
                      controller: authorIdController,
                      decoration: InputDecoration(
                        labelText: "Id autor",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "El id del autor no puede estar vacío";
                        }
                        if (int.tryParse(value) == null ||
                            int.parse(value) < 1) {
                          return "El id del autor tiene que ser un entero mayor a 0";
                        }
                        return null;
                      },
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 5),
                    TextFormField(
                      controller: priceController,
                      decoration: InputDecoration(
                        labelText: "Precio",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "El precio no puede estar vacío";
                        }
                        if (double.tryParse(value) == null ||
                            double.parse(value) < 0) {
                          return "El precio tiene ser un número no negativo";
                        }
                        return null;
                      },
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 5),
                    TextFormField(
                      controller: stockController,
                      decoration: InputDecoration(
                        labelText: "Existencias",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Las existencias no puede estar vacías";
                        }
                        if (int.tryParse(value) == null ||
                            int.parse(value) < 1) {
                          return "Las existencias tienen que ser un entero mayor a 0";
                        }
                        return null;
                      },
                      keyboardType: TextInputType.number,
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
                  style: TextStyle(color: Colors.green.shade900),
                ),
              ),
              TextButton(
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    final newBook = Book(
                      id: idController.text,
                      title: titleController.text,
                      authorId: int.tryParse(authorIdController.text) ?? 0,
                      price: double.tryParse(priceController.text) ?? 1,
                      stock: int.tryParse(stockController.text) ?? 1,
                    );
                    if (book == null) {
                      final exists = await ref
                          .read(bookListProvider.notifier)
                          .existsBookId(newBook.id);
                      if (!exists) {
                        ref.read(bookListProvider.notifier).addBook(newBook);
                        Navigator.pop(context);
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text("Libro creado")));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Error, el id de libro ya existe"),
                          ),
                        );
                      }
                    } else {
                      ref.read(bookListProvider.notifier).updateBook(newBook);
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Libro actualizado")),
                      );
                    }
                  }
                },
                child: Text(
                  book == null ? "Guardar" : "Actualizar",
                  style: TextStyle(color: Colors.green.shade900),
                ),
              ),
            ],
          ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, Book book) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text("Eliminar libro"),
            content: Text(
              book.title,
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
                  ref.read(bookListProvider.notifier).deleteBook(book.id);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text("Libro eliminado")));
                },
                child: Text("Eliminar"),
              ),
            ],
          ),
    );
  }
}
