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
  static const LatLng _initialPosition = LatLng(26.4525, 87.2718);
  final Completer<GoogleMapController> _mapController =
      Completer<GoogleMapController>();

  final Location _locationController = Location();
  LatLng? _currentPosition;
  final Set<Marker> _markers = {};

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
          GoogleMap(
            markers: _markers,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            initialCameraPosition: const CameraPosition(
              target: _initialPosition,
              zoom: 13.0,
            ),
            onMapCreated: ((GoogleMapController controller) =>
                _mapController.complete(controller)),
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
        });
      }
    });
  }

  Future<void> displayMarkers() async {
    for (var data in evStationsCoordinates) {
      _markers.add(Marker(
        markerId: const MarkerId('_destinationMarker'),
        position: LatLng(data['latitude'], data['longitude']),
        icon: await BitmapDescriptor.asset(
          const ImageConfiguration(size: Size(60, 60)),
          'assets/images/charging_station.png',
        ),
        infoWindow: InfoWindow(title: data['name']),
      ));
    }
  }
}
