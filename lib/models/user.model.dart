import 'dart:convert';
import 'dart:io';

import 'package:image_picker/image_picker.dart';

class User {
  final String id;
  final String fullName;
  final String username;
  final String password;
  final String phoneNumber;
  final String token;
  final String image;

  User({
    required this.id,
    required this.username,
    required this.fullName,
    required this.password,
    required this.phoneNumber,
    required this.image,
    required this.token,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fullName': fullName,
      'username': username,
      'password': password,
      'phoneNumber': phoneNumber,
      'image': image,
      'token': token,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['_id'] ?? '',
      fullName: map['fullName'] ?? '',
      username: map['username'] ?? '',
      password: map['password'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      image: map['image'] ?? File(''),
      token: map['token'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));
}
