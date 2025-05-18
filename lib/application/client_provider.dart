import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proyecto_final/data/library_database.dart';
import 'package:proyecto_final/domain/client.dart';

class ClientNotifier extends StateNotifier<List<Client>> {
  ClientNotifier() : super([]) {
    loadClients();
  }

  Future<void> loadClients() async {
    state = await LibraryDatabase.instance.getClients();
  }

  Future<void> addClient(Client client) async {
    await LibraryDatabase.instance.addClient(client);
    await loadClients();
  }

  Future<void> updateClient(Client client) async {
    await LibraryDatabase.instance.updateClient(client);
    await loadClients();
  }

  Future<void> deleteClient(int id) async {
    await LibraryDatabase.instance.deleteClient(id);
    await loadClients();
  }

  Future<bool> existsClientEmail(String email) async {
    return await LibraryDatabase.instance.existsClientEmail(email);
  }
}

final clientListProvider = StateNotifierProvider((ref) => ClientNotifier());
