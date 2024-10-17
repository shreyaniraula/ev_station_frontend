import 'dart:convert';
import 'package:ev_charge/models/station.model.dart';
import 'package:ev_charge/uri.dart';
import 'package:ev_charge/utils/show_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class StationDetailsScreen extends StatefulWidget {
  static const String routeName = '/station-details-screen';
  // final String username;
  const StationDetailsScreen({super.key});

  @override
  State<StationDetailsScreen> createState() => _StationDetailsScreenState();
}

class _StationDetailsScreenState extends State<StationDetailsScreen> {
  Station station = Station(
    id: '',
    name: '',
    username: '',
    phoneNumber: '',
    password: '',
    location: '',
    panCard: '',
    noOfSlots: 0,
    reservedSlots: 0,
    isVerified: false,
  );

  @override
  void initState() {
    super.initState();
    getStationDetails('banepa_ev_station').then((response) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: 250,
              width: 500,
              child: Image.asset(
                'assets/images/ev_station.jpg',
                fit: BoxFit.cover,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  station.name,
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  station.location,
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Contact',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.phone,
                      color: Color.fromARGB(255, 156, 240, 88),
                    ),
                    SizedBox(width: 5),
                    Text(
                      station.phoneNumber,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Text(
                  'Number of Slots: ${station.noOfSlots.toString()}',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Charging Available',
                  style: TextStyle(
                    fontWeight: FontWeight.w100,
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 156, 240, 88),
                  ),
                  child: Text('Book Station'),
                ),
              ],
            ),
            if (!station.isVerified)
              Container(
                width: double.infinity,
                color: Colors.red[100],
                child: Text(
                  'This station is not verified yet.',
                  style: TextStyle(fontSize: 18),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> getStationDetails(String username) async {
    try {
      http.Response stationRes = await http.get(
        Uri.parse('$uri/api/v1/stations/station-details'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'stationUsername': username,
        },
      );

      station =
          Station.fromJson(jsonEncode(jsonDecode(stationRes.body)['data']));
    } catch (e) {
      e.toString();
      showSnackBar(context, 'Something went wrong while displaying stations');
    }
  }
}
