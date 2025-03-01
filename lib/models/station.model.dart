import 'dart:convert';

class Station {
  final String id;
  final String name;
  final String username;
  final String phoneNumber;
  final String password;
  final String location;
  final String panCard;
  final String stationImage;
  final String accessToken;
  final int noOfSlots;
  final bool isVerified;

  Station({
    required this.id,
    required this.name,
    required this.username,
    required this.phoneNumber,
    required this.password,
    required this.location,
    required this.panCard,
    required this.stationImage,
    required this.accessToken,
    required this.noOfSlots,
    required this.isVerified,
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
      'stationImage': stationImage,
      'accessToken': accessToken,
      'noOfSlots': noOfSlots,
      'isVerified': isVerified,
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
      stationImage: map['stationImage'] ?? '',
      accessToken: map['accessToken'] ?? '',
      noOfSlots: map['noOfSlots'] ?? '',
      isVerified: map['isVerified'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory Station.fromJson(String source) => Station.fromMap(json.decode(source));
}
