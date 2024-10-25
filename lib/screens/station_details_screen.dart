import 'package:ev_charge/constants/styling_variables.dart';
import 'package:ev_charge/models/station.model.dart';
import 'package:ev_charge/services/station/get_stations.dart';
import 'package:flutter/material.dart';

class StationDetailsScreen extends StatefulWidget {
  static const String routeName = '/station-details-screen';
  // final String username;
  const StationDetailsScreen({super.key});

  @override
  State<StationDetailsScreen> createState() => _StationDetailsScreenState();
}

class _StationDetailsScreenState extends State<StationDetailsScreen> {
  final GetStations getStations = GetStations();

  Station station = Station(
    id: '',
    name: '',
    username: '',
    phoneNumber: '',
    password: '',
    location: '',
    panCard: '',
    stationImage: '',
    noOfSlots: 0,
    reservedSlots: 0,
    isVerified: false,
  );

  @override
  void initState() {
    super.initState();
    getStationDetails();
  }

  void getStationDetails() async {
    final stationDetails = await getStations.getStationDetails(
      context: context,
      username: 'banepa_ev_station',
    );

    if (stationDetails != null) {
      station = Station.fromMap(stationDetails);
    }
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
                  style: elevatedButtonStyle,
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
}
