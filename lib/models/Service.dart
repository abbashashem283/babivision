class Service {
  final int id;
  final String name;
  final String discription;
  final int durationMin;
  final double price;

  Service({
    required this.id,
    required this.name,
    required this.discription,
    required this.durationMin,
    required this.price,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json["id"],
      name: json["name"],
      discription: json["discription"],
      durationMin: json["duration_min"],
      price: double.parse(json["price"]),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is Service && this.id == other.id);

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Service(id: $id, name: $name, description: $discription, durationMin: $durationMin, price: $price)';
  }
}
