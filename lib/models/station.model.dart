import 'dart:convert';

class Station {
  final String id;
  final String name;
  final String username;
  final String phoneNumber;
  final String password;
  final String location;
  final String panCard;
  final String noOfSlots;
  final String reservedSlots;

  Station({
    required this.id,
    required this.name,
    required this.username,
    required this.phoneNumber,
    required this.password,
    required this.location,
    required this.panCard,
    required this.noOfSlots,
    required this.reservedSlots,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'username': username,
      'phoneNumber': phoneNumber,
      'password': password,
      'location': location,
      'panCard': panCard,
      'noOfSlots': noOfSlots,
      'reservedSlots': reservedSlots,
    };
  }

  factory Station.fromMap(Map<String, dynamic> map) {
    return Station(
      id: map['_id'] ?? '',
      name: map['name'] ?? '',
      username: map['username'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      password: map['password'] ?? '',
      location: map['location'] ?? '',
      panCard: map['panCard'] ?? '',
      noOfSlots: map['noOfSlots'] ?? '',
      reservedSlots: map['reservedSlots'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Station.fromJson(String source) => Station.fromMap(json.decode(source));
}
