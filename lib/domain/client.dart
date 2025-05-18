class Client {
  final int? id;
  final String name;
  final String email;
  final String? city;

  Client({this.id, required this.name, required this.email, this.city});

  Map<String, dynamic> toMap() => {"id": id, "name": name, "email": email, "city": city};

  static Client fromMap(Map<String, dynamic> map) => Client(
    id: map["id"],
    name: map["name"],
    email: map["email"],
    city: map["city"],
  );
}