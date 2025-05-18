import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proyecto_final/application/client_provider.dart';
import 'package:proyecto_final/domain/client.dart';

class ClientScreen extends ConsumerWidget {
  const ClientScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final clients = ref.watch(clientListProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Clientes",
          style: TextStyle(color: Colors.purple.shade100),
        ),
        backgroundColor: Colors.purple.shade900,
      ),
      body: Container(
        color: Colors.purple.shade100,
        child: ListView.builder(
          itemCount: clients.length,
          itemBuilder: (_, index) {
            final client = clients[index];
            return ListTile(
              title: Text(client.name),
              subtitle: Text("${client.email} - ${client.city ?? ""}"),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () => _showForm(context, ref, client: client),
                    icon: Icon(Icons.edit, color: Colors.green.shade900),
                  ),
                  IconButton(
                    onPressed: () => _confirmDelete(context, ref, client),
                    icon: Icon(Icons.delete, color: Colors.red.shade900),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.purple.shade900,
        onPressed: () => _showForm(context, ref),
        child: Icon(Icons.add, color: Colors.purple.shade100),
      ),
    );
  }

  void _showForm(BuildContext context, WidgetRef ref, {Client? client}) {
    final nameController = TextEditingController(text: client?.name ?? "");
    final emailController = TextEditingController(text: client?.email ?? "");
    final cityController = TextEditingController(text: client?.city ?? "");
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text(client == null ? "Agregar cliente" : "Editar cliente"),
            content: Container(
              color: Colors.purple.shade100,
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
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: "Correo",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "El correo no puede estar vacío";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 5),
                    TextFormField(
                      controller: cityController,
                      decoration: InputDecoration(
                        labelText: "Ciudad",
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
                  style: TextStyle(color: Colors.purple.shade900),
                ),
              ),
              TextButton(
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    final newClient = Client(
                      id: client?.id,
                      name: nameController.text,
                      email: emailController.text,
                      city: cityController.text,
                    );
                    if (client == null) {
                      final exists = await ref
                          .read(clientListProvider.notifier)
                          .existsClientEmail(newClient.email);
                      if (!exists) {
                        ref
                            .read(clientListProvider.notifier)
                            .addClient(newClient);
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Cliente creado")),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "Error, el correo de cliente ya existe",
                            ),
                          ),
                        );
                      }
                    } else {
                      ref
                          .read(clientListProvider.notifier)
                          .updateClient(newClient);
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Cliente actualizado")),
                      );
                    }
                  }
                },
                child: Text(
                  client == null ? "Guardar" : "Actualizar",
                  style: TextStyle(color: Colors.purple.shade900),
                ),
              ),
            ],
          ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, Client client) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text("Eliminar cliente"),
            content: Text(
              client.name,
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
                      .read(clientListProvider.notifier)
                      .deleteClient(client.id!);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text("Cliente eliminado")));
                },
                child: Text("Eliminar"),
              ),
            ],
          ),
    );
  }
}
