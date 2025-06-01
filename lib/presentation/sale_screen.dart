import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proyecto_final/application/sale_provider.dart';
import 'package:proyecto_final/domain/sale.dart';

class SaleScreen extends ConsumerWidget {
  const SaleScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sales = ref.watch(saleListProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text("Ventas", style: TextStyle(color: Colors.blue.shade100)),
        backgroundColor: Colors.blue.shade900,
      ),
      body: Container(
        color: Colors.blue.shade100,
        child: ListView.builder(
          itemCount: sales.length,
          itemBuilder: (_, index) {
            final sale = sales[index];
            return ListTile(
              title: Text(sale.date),
              subtitle: Text(
                "${sale.bookId} - ${sale.clientId} - ${sale.quantity} unidades",
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () => _showForm(context, ref, sale: sale),
                    icon: Icon(Icons.edit, color: Colors.green.shade900),
                  ),
                  IconButton(
                    onPressed: () => _confirmDelete(context, ref, sale),
                    icon: Icon(Icons.delete, color: Colors.red.shade900),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue.shade900,
        onPressed: () => _showForm(context, ref),
        child: Icon(Icons.add, color: Colors.blue.shade100),
      ),
    );
  }

  void _showForm(BuildContext context, WidgetRef ref, {Sale? sale}) {
    final bookIdController = TextEditingController(
      text: sale?.bookId.toString() ?? "",
    );
    final clientIdController = TextEditingController(
      text: sale?.clientId.toString() ?? "",
    );
    final dateController = TextEditingController(
      text: sale?.date.toString() ?? "",
    );
    final quantityController = TextEditingController(
      text: sale?.quantity.toString() ?? "",
    );
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text(sale == null ? "Agregar venta" : "Editar venta"),
            content: Container(
              color: Colors.blue.shade100,
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: bookIdController,
                      decoration: InputDecoration(
                        labelText: "Id libro",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "El id del libro no puede estar vacío";
                        }
                        if (int.tryParse(value) == null ||
                            int.parse(value) < 1) {
                          return "El id del libro tiene que ser un entero mayor a 0";
                        }
                        return null;
                      },
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 5),
                    TextFormField(
                      controller: clientIdController,
                      decoration: InputDecoration(
                        labelText: "Id cliente",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "El id del cliente no puede estar vacío";
                        }
                        if (int.tryParse(value) == null ||
                            int.parse(value) < 1) {
                          return "El id del cliente tiene que ser un entero mayor a 0";
                        }
                        return null;
                      },
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 5),
                    TextFormField(
                      controller: dateController,
                      decoration: InputDecoration(
                        labelText: "Fecha",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "La fecha no puede estar vacía";
                        }
                        return null;
                      },
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 5),
                    TextFormField(
                      controller: quantityController,
                      decoration: InputDecoration(
                        labelText: "Cantidad",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "La cantidad no puede estar vacía";
                        }
                        if (int.tryParse(value) == null ||
                            int.parse(value) < 1) {
                          return "La cantidad tiene que ser un entero mayor a 0";
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
                  style: TextStyle(color: Colors.blue.shade900),
                ),
              ),
              TextButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    final newSale = Sale(
                      id: sale?.id,
                      bookId: int.tryParse(bookIdController.text) ?? 0,
                      clientId: int.tryParse(clientIdController.text) ?? 0,
                      date: DateTime.tryParse(dateController.text).toString(),
                      quantity: int.tryParse(quantityController.text) ?? 1,
                    );
                    if (sale == null) {
                      ref.read(saleListProvider.notifier).addSale(newSale);
                    } else {
                      ref.read(saleListProvider.notifier).updateSale(newSale);
                    }
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "Venta ${sale == null ? "registrada" : "actualizada"}",
                        ),
                      ),
                    );
                  }
                },
                child: Text(
                  sale == null ? "Guardar" : "Actualizar",
                  style: TextStyle(color: Colors.blue.shade900),
                ),
              ),
            ],
          ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, Sale sale) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text("Eliminar venta"),
            content: Text(
              "${sale.id} - ${sale.date}",
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
                  ref.read(saleListProvider.notifier).deleteSale(sale.id!);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text("Venta eliminada")));
                },
                child: Text("Eliminar"),
              ),
            ],
          ),
    );
  }
}
