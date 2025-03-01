import 'package:ev_charge/constants/styling_variables.dart';
import 'package:ev_charge/models/station.model.dart';
import 'package:ev_charge/screens/reservation/user_booking_page.dart';
import 'package:ev_charge/services/station/get_stations.dart';
import 'package:flutter/material.dart';

class StationDetailsScreen extends StatefulWidget {
  static const String routeName = '/station-details-screen';
  final String username;
  const StationDetailsScreen({super.key, required this.username});

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
    accessToken: '',
    noOfSlots: 0,
    isVerified: false,
  );

  @override
  void initState() {
    super.initState();
    getStationDetails(widget.username);
  }

  void getStationDetails(String username) async {
    final stationDetails = await getStations.getStationDetails(
      context: context,
      username: username,
    );

    if (stationDetails != null) {
      setState(() {
        station = stationDetails;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(station.name),
        backgroundColor: Color.fromARGB(248, 203, 243, 175),
      ),
      backgroundColor: const Color.fromARGB(255, 240, 242, 246),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
          child: Column(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: double.infinity,
                height: 300,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    image: DecorationImage(
                      image: NetworkImage(station.stationImage),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              StationInfo(
                keys: 'Station Name',
                values: station.name,
              ),
              StationInfo(keys: 'Location', values: station.location),
              StationInfo(keys: 'Contact', values: station.phoneNumber),
              StationInfo(
                  keys: 'Number of Slots',
                  values: station.noOfSlots.toString()),
              StationInfo(
                  keys: 'Verified',
                  values: station.isVerified ? 'True' : 'False'),
              SizedBox(height: 20),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(
                      UserBookingPage.routeName,
                      arguments: UserBookingPage(
                        name: station.name,
                        address: station.location,
                        id: station.id,
                      ),
                    );
                  },
                  style: elevatedButtonStyle,
                  child: Text(
                    'Book Station',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              // Spacer(),
              // if (!station.isVerified)
              //   Container(
              //     width: double.infinity,
              //     color: Colors.red[100],
              //     child: Text(
              //       'This station is not verified yet.',
              //       style: TextStyle(fontSize: 18),
              //     ),
              //   ),
            ],
          ),
        ),
      ),
    );
  }
}

class StationInfo extends StatelessWidget {
  const StationInfo({
    super.key,
    required this.keys,
    required this.values,
  });

  final String keys, values;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          keys,
          style: TextStyle(
            fontSize: 18,
          ),
        ),
        Text(
          values,
          style: TextStyle(
            fontSize: 18,
          ),
        ),
      ],
    );
  }
}
