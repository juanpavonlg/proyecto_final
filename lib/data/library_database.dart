import 'package:proyecto_final/domain/author.dart';
import 'package:proyecto_final/domain/book.dart';
import 'package:proyecto_final/domain/client.dart';
import 'package:proyecto_final/domain/sale.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class LibraryDatabase {
  static final LibraryDatabase instance = LibraryDatabase._init();
  static Database? _database;
  static const String dbName = "library.db";
  static const int dbVersion = 1;

  LibraryDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, dbName);

    _database = await openDatabase(
      path,
      version: dbVersion,
      onCreate: _createDB,
    );
    return _database!;
  }

  static Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE authors (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL UNIQUE,
        country TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE books (
        id TEXT PRIMARY KEY NOT NULL,
        title TEXT NOT NULL,
        authorId INTEGER NOT NULL,
        price REAL NOT NULL,
        stock INTEGER NOT NULL,
        FOREIGN KEY (authorId) REFERENCES authors(id)
      )
    ''');
    await db.execute('''
      CREATE TABLE clients (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        city TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE sales (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        bookId INTEGER,
        clientId INTEGER,
        date TEXT NOT NULL,
        quantity INTEGER NOT NULL,
        FOREIGN KEY (bookId) REFERENCES books(id),
        FOREIGN KEY (clientId) REFERENCES clients(id)
      )
    ''');
  }

  Future<List<Author>> getAuthors() async {
    final db = await database;
    final result = await db.query("authors");
    return result.map((e) => Author.fromMap(e)).toList();
  }

  Future<int> addAuthor(Author author) async {
    final db = await database;
    return db.insert("authors", author.toMap());
  }

  Future<int> updateAuthor(Author author) async {
    final db = await database;
    return db.update(
      "authors",
      author.toMap(),
      where: "id = ?",
      whereArgs: [author.id],
    );
  }

  Future<int> deleteAuthor(int id) async {
    final db = await database;
    return db.delete("authors", where: "id = ?", whereArgs: [id]);
  }

  Future<bool> existsAuthorName(String name) async {
    final db = await database;
    final result = await db.query(
      "authors",
      columns: ["id"],
      where: "name = ?",
      whereArgs: [name],
      limit: 1,
    );
    return result.isNotEmpty;
  }

  Future<List<Book>> getBooks() async {
    final db = await database;
    final result = await db.query("books");
    return result.map((e) => Book.fromMap(e)).toList();
  }

  Future<int> addBook(Book book) async {
    final db = await database;
    return db.insert("books", book.toMap());
  }

  Future<int> updateBook(Book book) async {
    final db = await database;
    return db.update(
      "books",
      book.toMap(),
      where: "id = ?",
      whereArgs: [book.id],
    );
  }

  Future<int> deleteBook(String id) async {
    final db = await database;
    return db.delete("books", where: "id = ?", whereArgs: [id]);
  }

  Future<bool> existsBookId(String id) async {
    final db = await database;
    final result = await db.query(
      "books",
      columns: ["id"],
      where: "id = ?",
      whereArgs: [id],
      limit: 1,
    );
    return result.isNotEmpty;
  }

  Future<List<Client>> getClients() async {
    final db = await database;
    final result = await db.query("clients");
    return result.map((e) => Client.fromMap(e)).toList();
  }

  Future<int> addClient(Client client) async {
    final db = await database;
    return db.insert("clients", client.toMap());
  }

  Future<int> updateClient(Client client) async {
    final db = await database;
    return db.update(
      "clients",
      client.toMap(),
      where: "id = ?",
      whereArgs: [client.id],
    );
  }

  Future<int> deleteClient(int id) async {
    final db = await database;
    return db.delete("clients", where: "id = ?", whereArgs: [id]);
  }

  Future<bool> existsClientEmail(String email) async {
    final db = await database;
    final result = await db.query(
      "clients",
      columns: ["id"],
      where: "email = ?",
      whereArgs: [email],
      limit: 1,
    );
    return result.isNotEmpty;
  }

  Future<List<Sale>> getSales() async {
    final db = await database;
    final result = await db.query("sales");
    return result.map((e) => Sale.fromMap(e)).toList();
  }

  Future<int> addSale(Sale sale) async {
    final db = await database;
    return db.insert("sales", sale.toMap());
  }

  Future<int> updateSale(Sale sale) async {
    final db = await database;
    return db.update(
      "sales",
      sale.toMap(),
      where: "id = ?",
      whereArgs: [sale.id],
    );
  }

  Future<int> deleteSale(int id) async {
    final db = await database;
    return db.delete("sales", where: "id = ?", whereArgs: [id]);
  }

  Future close() async {
    final db = await database;
    db.close();
  }
}
