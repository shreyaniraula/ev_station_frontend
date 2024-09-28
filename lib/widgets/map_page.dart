import 'dart:async';
import 'dart:convert';

import 'package:ev_charge/constants/api_key.dart';
import 'package:ev_charge/utils/show_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  // static const LatLng _initialPosition = LatLng(26.4525, 87.2718);
  final Completer<GoogleMapController> _mapController =
      Completer<GoogleMapController>();
  final Set<Marker> _markers = {};

  final Location _locationController = Location();
  LatLng? _currentPosition;

  @override
  void initState() {
    super.initState();
    getUserLocation().then((response) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _currentPosition == null
              ? const Center(
                  child: Text('Loading...'),
                )
              : GoogleMap(
                  onMapCreated: ((GoogleMapController controller) =>
                      _mapController.complete(controller)),
                  initialCameraPosition: CameraPosition(
                    target: _currentPosition!,
                    zoom: 13.0,
                  ),
                  markers: _markers,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                ),
        ],
      ),
    );
  }

  Future<void> getUserLocation() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await _locationController.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _locationController.requestService();
    }

    permissionGranted = await _locationController.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _locationController.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationController.onLocationChanged
        .listen((LocationData currentLocation) {
      if (currentLocation.latitude != null &&
          currentLocation.longitude != null) {
        setState(() {
          _currentPosition = LatLng(
            currentLocation.latitude!,
            currentLocation.longitude!,
          );
          // _pointToUser(_currentPosition!);
          _getNearbyChargingStations(
            _currentPosition!.latitude,
            _currentPosition!.longitude,
          );
          _markers.add(
            Marker(
              markerId: const MarkerId('_currentLocation'),
              position: _currentPosition!,
            ),
          );
        });
      }
    });
  }

  Future<void> _getNearbyChargingStations(double lat, double lng) async {
    String apiKey = kGoogleApiKey;
    String url =
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=$lat,$lng&radius=1500&type=ev_charging_station&key=$apiKey';

    final response = await http.get(Uri.parse(url));
    print(
        'The results are ***************************************************');
    print(response.body);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final results = data['results'];

      setState(() {
        displayStations(results);
      });
    } else {
      showSnackBar(context, 'Failed to load nearby EV stations');
    }
  }

  Future<void> displayStations(results) async {
    for (var result in results) {
      _markers.add(
        Marker(
          markerId: MarkerId(result['place_id']),
          position: LatLng(result['geometry']['location']['lat'],
              result['geometry']['location']['lng']),
          infoWindow: InfoWindow(title: result['name']),
          icon: await BitmapDescriptor.asset(
            const ImageConfiguration(size: Size(48, 48)),
            'assets/images/charging_station.png',
          ),
        ),
      );
    }
  }
}


/*
User enters the station details
Admin verifies the station
Admin enters the coordinates of the station and stores in database
There is a marker field in the database which is initially null
But once added the coordinates of the map are retrieved from database and markers are shown in the map
*/