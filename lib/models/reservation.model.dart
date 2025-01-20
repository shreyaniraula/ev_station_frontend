import 'dart:convert';

class Reservation {
  final String id;
  final String reservedBy;
  final String reservedTo;
  final String paymentAmount;
  final String startingTime;
  final String endingTime;
  final String remarks;

  Reservation({
    required this.id,
    required this.reservedBy,
    required this.reservedTo,
    required this.paymentAmount,
    required this.startingTime,
    required this.endingTime,
    required this.remarks,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'reservedBy': reservedBy,
      'reservedTo': reservedTo,
      'paymentAmount': paymentAmount,
      'startingTime': startingTime,
      'endingTime': endingTime,
      'remarks': remarks,
    };
  }

  factory Reservation.fromMap(Map<String, dynamic> map) {
    return Reservation(
      id: map['id'] ?? '',
      reservedBy: map['reservedBy'] ?? '',
      reservedTo: map['reservedTo'] ?? '',
      paymentAmount: map['paymentAmount'] ?? '',
      startingTime: map['startingTime'] ?? '',
      endingTime: map['endingTime'] ?? '',
      remarks: map['remarks'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Reservation.fromJson(String source) =>
      Reservation.fromMap(json.decode(source));
}
