class Author {
  final int? id;
  final String name;
  final String? country;

  Author({this.id, required this.name, this.country});

  Map<String, dynamic> toMap() => {"id": id, "name": name, "country": country};

  static Author fromMap(Map<String, dynamic> map) => Author(
    id: map["id"],
    name: map["name"],
    country: map["country"],
  );
}
