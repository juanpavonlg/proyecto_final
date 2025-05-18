import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proyecto_final/data/library_database.dart';
import 'package:proyecto_final/domain/author.dart';

class AuthorNotifier extends StateNotifier<List<Author>> {
  AuthorNotifier() : super([]) {
    loadAuthors();
  }

  Future<void> loadAuthors() async {
    state = await LibraryDatabase.instance.getAuthors();
  }

  Future<void> addAuthor(Author author) async {
    await LibraryDatabase.instance.addAuthor(author);
    await loadAuthors();
  }

  Future<void> updateAuthor(Author author) async {
    await LibraryDatabase.instance.updateAuthor(author);
    await loadAuthors();
  }

  Future<void> deleteAuthor(int id) async {
    await LibraryDatabase.instance.deleteAuthor(id);
    await loadAuthors();
  }

  Future<bool> existsAuthorName(String name) async {
    return await LibraryDatabase.instance.existsAuthorName(name);
  }
}

final authorListProvider = StateNotifierProvider((ref) => AuthorNotifier());
