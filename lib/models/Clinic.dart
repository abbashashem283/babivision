import 'dart:convert';

class Clinic {
  final int id;
  final String name;
  final String address;
  final String latitude;
  final String longitude;
  final String openTime;
  final String closeTime;
  final List<dynamic> workDays;

  Clinic({
    required this.id,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.openTime,
    required this.closeTime,
    required this.workDays,
  });

  factory Clinic.fromJson(Map<String, dynamic> json) {
    return Clinic(
      id: json["id"],
      name: json["name"],
      address: json["address"],
      latitude: json["latitude"],
      longitude: json["longitude"],
      openTime: json["open_time"],
      closeTime: json["close_time"],
      workDays: jsonDecode(json["workdays"]),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is Clinic && this.id == other.id);

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Clinic(id: $id, name: $name, address: $address, openTime: $openTime, closeTime: $closeTime, workDays: $workDays)';
  }
}
