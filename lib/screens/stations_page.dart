import 'package:cached_network_image/cached_network_image.dart';
import 'package:ev_charge/constants/ev_station_coordinates.dart';
import 'package:flutter/material.dart';

class StationsPage extends StatelessWidget {
  static const String routeName = '/stations-page';
  const StationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: evStationsCoordinates.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              Card(child: CachedNetworkImage(imageUrl: evStationsCoordinates[index].imageUrl),),
              Text(evStationsCoordinates[index].name),
              Text(evStationsCoordinates[index].address),
            ],
          );
        },
      ),
    );
  }
}
