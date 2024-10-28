import 'package:cached_network_image/cached_network_image.dart';
import 'package:ev_charge/screens/common/station_details_screen.dart';
import 'package:ev_charge/services/station/get_stations.dart';
import 'package:flutter/material.dart';

class StationsPage extends StatefulWidget {
  static const String routeName = '/stations-page';
  const StationsPage({super.key});

  @override
  State<StationsPage> createState() => _StationsPageState();
}

class _StationsPageState extends State<StationsPage> {
  final GetStations getStations = GetStations();
  List<dynamic> stations = [];

  @override
  void initState() {
    super.initState();
    getAllStations();
  }

  void getAllStations() async {
    final allStations = await getStations.getAllStations(context: context);

    if (allStations != null) {
      setState(() {
        stations = allStations;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: stations.length,
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () => Navigator.of(context).pushNamed(
                StationDetailsScreen.routeName,
                arguments: stations[index]['username'],
              ),
              child: CachedNetworkImage(
                imageUrl: stations[index]['stationImage'],
                placeholder: (context, url) => SizedBox(
                  width: 50,
                  height: 50,
                  child: CircularProgressIndicator(color: Colors.blue),
                ),
                errorWidget: (context, url, error) => Icon(Icons.error),
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Text(
              stations[index]['name'],
              style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
            ),
            Text(
              stations[index]['location'],
              style: TextStyle(fontSize: 18.0),
            ),
          ],
        ),
      ),
    );
  }
}
