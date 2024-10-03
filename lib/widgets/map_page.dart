import 'dart:async';

import 'package:ev_charge/constants/ev_station_coordinates.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
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
                  child: CircularProgressIndicator(),
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


          displayMarkers();


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

  Future<void> displayMarkers() async {

    for (var data in evStationsCoordinates) {
      _markers.add(
        Marker(
            markerId: const MarkerId('_destinationMarker'),
            position: LatLng(data['latitude'], data['longitude']),
            icon: await BitmapDescriptor.asset(
              const ImageConfiguration(size: Size(20, 20)),
              'assets/images/charging_station.png',
            ),
            infoWindow: InfoWindow(title: data['name'])),
      );
    }

  }
}