import 'package:flutter/material.dart';
import 'package:proyecto_final/presentation/author_screen.dart';
import 'package:proyecto_final/presentation/book_screen.dart';
import 'package:proyecto_final/presentation/client_screen.dart';
import 'package:proyecto_final/presentation/sale_screen.dart';

class Menu extends StatelessWidget {
  const Menu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange.shade100,
      appBar: AppBar(
        title: Text("Librería"),
        backgroundColor: Colors.orange.shade900,
      ),
      body: Column(
        children: [
          Expanded(child: Center(child: Text("Seleccione una opción del menú"))),
          Text("Desarrollado por Juan Pablo von Landwüst Gumucio")
        ],
      ),
      drawer: Drawer(
        child: Container(
          color: Colors.orangeAccent,
          child: ListView(
            children: [
              UserAccountsDrawerHeader(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.orange.shade900, Colors.orange.shade100],
                  ),
                ),
                accountName: Text("Sistema de librería"),
                accountEmail: Text("libreria@email.com"),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.orange.shade900,
                  child: Icon(Icons.book, color: Colors.white, size: 50),
                ),
              ),
              // Divider(height: 10, color: Colors.orange),
              ListTile(
                focusColor: Colors.blue.shade100,
                leading: Icon(Icons.edit_outlined),
                title: Text("Autores", style: TextStyle(fontSize: 20)),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AuthorScreen()),
                  );
                },
              ),
              ListTile(
                focusColor: Colors.blue.shade100,
                leading: Icon(Icons.book_outlined),
                title: Text("Libros", style: TextStyle(fontSize: 20)),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BookScreen()),
                  );
                },
              ),
              ListTile(
                focusColor: Colors.blue.shade100,
                leading: Icon(Icons.person_2_outlined),
                title: Text("Clientes", style: TextStyle(fontSize: 20)),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ClientScreen()),
                  );
                },
              ),
              ListTile(
                focusColor: Colors.blue.shade100,
                leading: Icon(Icons.production_quantity_limits_outlined),
                title: Text("Ventas", style: TextStyle(fontSize: 20)),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SaleScreen()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
