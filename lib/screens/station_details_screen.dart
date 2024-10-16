import 'package:ev_charge/constants/ev_station_coordinates.dart';
import 'package:flutter/material.dart';

class StationDetailsScreen extends StatelessWidget {
  const StationDetailsScreen({super.key});

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
                  evStationsCoordinates[0]['name'],
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  evStationsCoordinates[0]['address'],
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
                      '9812345670',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Text(
                  'Total Slots: 2',
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
}
