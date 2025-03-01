import 'package:ev_charge/models/reservation.model.dart';
import 'package:ev_charge/services/reservation/reservation_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MyReservations extends StatefulWidget {
  static const String routeName = '/my-reservations';
  const MyReservations({super.key});

  @override
  State<MyReservations> createState() => _MyReservationsState();
}

class _MyReservationsState extends State<MyReservations> {
  final ReservationService reservationService = ReservationService();
  List<Reservation> reservations = [];

  @override
  void initState() {
    super.initState();
    myReservations();
  }

  void cancelReservation(String reservationId) async {
    final success = await reservationService.cancelReservation(
      context: context,
      reservationId: reservationId,
    );
    if (success) {
      setState(() {
        reservations
            .removeWhere((reservation) => reservation.id == reservationId);
      });
    }
  }

  Future<void> _showCancelConfirmationDialog(String reservationId) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Cancel Reservation'),
          content:
              const Text('Are you sure you want to cancel this reservation?'),
          actions: <Widget>[
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
              },
            ),
            TextButton(
              child: const Text('Yes'),
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
                cancelReservation(reservationId); // Proceed with cancellation
              },
            ),
          ],
        );
      },
    );
  }

  void myReservations() async {
    final myBookings = await reservationService.myReservations();
    final now = DateTime.now();
    final futureBookings = myBookings.where(
      (reservation) {
        final startingTime = reservation.startingTime;
        return startingTime.isAfter(now);
      },
    ).toList();
    if (mounted) {
      setState(() {
        reservations = futureBookings;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('My Reservations'),
          backgroundColor: const Color.fromARGB(255, 196, 231, 167),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
          child: ListView.builder(
            itemCount: reservations.length,
            itemBuilder: (context, index) {
              return Card(
                elevation: 2,
                color: Color.fromARGB(248, 203, 243, 175),
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    spacing: 5,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.business, size: 16, color: Colors.grey),
                          SizedBox(width: 8),
                          Text(reservations[index].reservedStation),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(Icons.location_on,
                              size: 16, color: Colors.grey),
                          const SizedBox(width: 8),
                          Text(reservations[index].location),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(Icons.calendar_month,
                              size: 16, color: Colors.grey),
                          const SizedBox(width: 8),
                          Text(
                            DateFormat('yyyy-MM-dd')
                                .format(reservations[index].date!.toLocal()),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(Icons.access_time,
                              size: 16, color: Colors.grey),
                          const SizedBox(width: 8),
                          Text(
                              '${DateFormat('HH:mm').format(reservations[index].startingTime.toLocal())} - ${DateFormat('HH:mm').format(reservations[index].endingTime.toLocal())}'),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(Icons.note, size: 16, color: Colors.grey),
                          const SizedBox(width: 8),
                          Text(reservations[index].remarks),
                        ],
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton(
                          onPressed: () {
                            _showCancelConfirmationDialog(reservations[index].id);
                          },
                          style: ElevatedButton.styleFrom(
                            fixedSize: Size(90, 5),
                            backgroundColor:
                                const Color.fromARGB(255, 211, 206, 206),
                            foregroundColor: Colors.black,
                          ),
                          child: Text(
                            'Cancel',
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ));
  }
}
