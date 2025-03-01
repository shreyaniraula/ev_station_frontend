import 'dart:convert';

class Reservation {
  final String id;
  final String reservedBy;
  final String reservedTo;
  final String reserverName;
  final String reservedStation;
  final String location;
  final int paymentAmount;
  final DateTime startingTime;
  final DateTime endingTime;
  final DateTime? date;
  final String remarks;

  Reservation({
    required this.id,
    required this.reservedBy,
    required this.reservedTo,
    required this.reserverName,
    required this.reservedStation,
    required this.location,
    required this.paymentAmount,
    required this.startingTime,
    required this.endingTime,
    this.date,
    required this.remarks,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'reservedBy': reservedBy,
      'reservedTo': reservedTo,
      'reserverName': reserverName,
      'reservedStation': reservedStation,
      'location': location,
      'paymentAmount': paymentAmount,
      'startingTime': startingTime,
      'endingTime': endingTime,
      'date': date,
      'remarks': remarks,
    };
  }

  factory Reservation.fromMap(Map<String, dynamic> map) {
    return Reservation(
      id: map['id'] ?? '',
      reservedBy: map['reservedBy'] ?? '',
      reservedTo: map['reservedTo'] ?? '',
      reserverName: map['reserverName'] ?? '',
      reservedStation: map['reservedStation'] ?? '',
      location: map['location'] ?? '',
      paymentAmount: map['paymentAmount'] ?? '',
      startingTime: map['startingTime'] ?? '',
      endingTime: map['endingTime'] ?? '',
      date: map['date'] != null ? DateTime.parse(map['date']) : null,
      remarks: map['remarks'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Reservation.fromJson(String source) =>
      Reservation.fromMap(json.decode(source));
}
