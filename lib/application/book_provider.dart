import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proyecto_final/data/library_database.dart';
import 'package:proyecto_final/domain/book.dart';

class BookNotifier extends StateNotifier<List<Book>> {
  BookNotifier() : super([]) {
    loadBooks();
  }

  Future<void> loadBooks() async {
    state = await LibraryDatabase.instance.getBooks();
  }

  Future<void> addBook(Book book) async {
    await LibraryDatabase.instance.addBook(book);
    await loadBooks();
  }

  Future<void> updateBook(Book book) async {
    await LibraryDatabase.instance.updateBook(book);
    await loadBooks();
  }

  Future<void> deleteBook(String id) async {
    await LibraryDatabase.instance.deleteBook(id);
    await loadBooks();
  }

  Future<bool> existsBookId(String id) async {
    return await LibraryDatabase.instance.existsBookId(id);
  }
}

final bookListProvider = StateNotifierProvider((ref) => BookNotifier());
