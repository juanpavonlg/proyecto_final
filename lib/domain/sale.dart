class Sale {
  final int? id;
  final int bookId;
  final int clientId;
  final String date;
  final int quantity;

  Sale({
    this.id,
    required this.bookId,
    required this.clientId,
    required this.date,
    required this.quantity,
  });

  Map<String, dynamic> toMap() => {
    "id": id,
    "bookId": bookId,
    "clientId": clientId,
    "date": date,
    "quantity": quantity,
  };

  static Sale fromMap(Map<String, dynamic> map) => Sale(
    id: map["id"],
    bookId: map["bookId"],
    clientId: map["clientId"],
    date: map["date"],
    quantity: map["quantity"],
  );
}
