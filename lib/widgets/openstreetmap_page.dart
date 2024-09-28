import 'dart:convert';

import 'package:ev_charge/constants/api_key.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;

class OpenstreetmapPage extends StatefulWidget {
  const OpenstreetmapPage({super.key});

  @override
  State<OpenstreetmapPage> createState() => _OpenstreetmapPageState();
}

class _OpenstreetmapPageState extends State<OpenstreetmapPage> {
  final MapController _mapController = MapController();
  Position? _currentPosition;
  List<Marker> _evMarkers = [];
  static const lat = 26.458376831959747;
  static const lon = 87.28710201254815;
  final String _evApiUrl =
      'https://api.openchargemap.io/v3/poi/?output=json&latitude=$lat&longitude=$lon&maxresults=10&key=$kOpenChargeMapApiKey'; // Example API

  static const initialPosition = LatLng(26.819800, 87.288500);

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: const MapOptions(
              initialCenter: initialPosition,
              initialZoom: 16.0,
              interactionOptions:
                  InteractionOptions(flags: InteractiveFlag.doubleTapZoom),
            ),
            children: [
              TileLayer(
                // Display map tiles from any source
                urlTemplate:
                    'https://tile.openstreetmap.org/{z}/{x}/{y}.png', // OSMF's Tile Server
                userAgentPackageName: 'com.ev_station_frontend.app',
                // And many more recommended properties!
              ),
              const MarkerLayer(
                markers: [
                  Marker(
                    point: initialPosition,
                    width: 50,
                    height: 50,
                    child: Icon(
                      Icons.location_pin,
                      size: 40,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    _currentPosition = await Geolocator.getCurrentPosition();
    setState(() {
      _getEVChargingStations();
    });
  }

  // Fetch nearby EV charging stations
  void _getEVChargingStations() async {
    if (_currentPosition == null) return;

    final double latitude = _currentPosition!.latitude;
    final double longitude = _currentPosition!.longitude;

    final response = await http.get(
      Uri.parse(_evApiUrl),
      headers: {
        'User-Agent': 'EV station finder',
      },
    );

    print(response.body);

    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      List<Marker> markers = data.map((station) {
        return Marker(
          width: 80.0,
          height: 80.0,
          point: LatLng(station['AddressInfo']['Latitude'],
              station['AddressInfo']['Longitude']),
          child: Icon(Icons.ev_station, color: Colors.green),
        );
      }).toList();

      setState(() {
        _evMarkers = markers;
      });
    }
  }
}
