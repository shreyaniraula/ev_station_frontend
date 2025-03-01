import 'package:ev_charge/models/reservation.model.dart';
import 'package:ev_charge/services/reservation/reservation_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReservationScreen extends StatefulWidget {
  static const String routeName = '/reservation-screen';

  const ReservationScreen({super.key});

  @override
  State<ReservationScreen> createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  bool _isLoading = true;
  String? _error;

  final ReservationService reservationService = ReservationService();
  List<Reservation> _reservations = [];

  @override
  void initState() {
    super.initState();
    _fetchReservations();
  }

  Future<void> _fetchReservations() async {
    if (mounted) {
      setState(() {
        _isLoading = true;
        _error = null;
      });
    }

    try {
      final bookings = await reservationService.getReservations();
      final now = DateTime.now();
      final futureBookings = bookings.where(
        (reservation) {
          final startingTime = reservation.startingTime;
          return startingTime.isAfter(now);
        },
      ).toList();
      if (mounted) {
        setState(() {
          _reservations = futureBookings;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _fetchReservations,
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _error != null
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Error: $_error',
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: _fetchReservations,
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    )
                  : _reservations.isEmpty
                      ? const Center(
                          child: Text('No upcoming reservations'),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: _reservations.length,
                          itemBuilder: (context, index) {
                            final reservation = _reservations[index];
                            return Card(
                              elevation: 2,
                              color: Color.fromARGB(248, 203, 243, 175),
                              margin: const EdgeInsets.only(bottom: 16),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Booking #${reservation.id}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium
                                              ?.copyWith(
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      children: [
                                        const Icon(Icons.calendar_today,
                                            size: 16, color: Colors.grey),
                                        const SizedBox(width: 8),
                                        Text(
                                          DateFormat('yyyy-MM-dd')
                                              .format(reservation.date!.toLocal()),
                                          style: const TextStyle(
                                            fontSize: 15,
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        const Icon(Icons.access_time,
                                            size: 16, color: Colors.grey),
                                        const SizedBox(width: 8),
                                        Text(
                                          '${DateFormat('HH:mm').format(reservation.startingTime.toLocal())} - ${DateFormat('HH:mm').format(reservation.endingTime.toLocal())}',
                                          style: const TextStyle(
                                            fontSize: 15,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        const Icon(Icons.person,
                                            size: 16, color: Colors.grey),
                                        const SizedBox(width: 8),
                                        Text(
                                          reservation.reserverName,
                                          style: const TextStyle(
                                            fontSize: 15,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        const Icon(Icons.monetization_on,
                                            size: 16, color: Colors.grey),
                                        const SizedBox(width: 8),
                                        Text(
                                          'Rs. ${reservation.paymentAmount/100}',
                                          style: const TextStyle(
                                            fontSize: 15,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        const Icon(Icons.note,
                                            size: 16, color: Colors.grey),
                                        const SizedBox(width: 8),
                                        Text(
                                          reservation.remarks,
                                          style: const TextStyle(
                                            fontSize: 15,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
        ),
      ),
    );
  }
}
