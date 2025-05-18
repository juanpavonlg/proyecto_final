class Book {
  final String id;
  final String title;
  final int authorId;
  final double price;
  final int stock;

  Book({
    required this.id,
    required this.title,
    required this.authorId,
    required this.price,
    required this.stock,
  });

  Map<String, dynamic> toMap() => {
    "id": id,
    "title": title,
    "authorId": authorId,
    "price": price,
    "stock": stock,
  };

  static Book fromMap(Map<String, dynamic> map) => Book(
    id: map["id"],
    title: map["title"],
    authorId: map["authorId"],
    price: map["price"],
    stock: map["stock"],
  );
}
