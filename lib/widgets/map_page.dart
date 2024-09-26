import 'dart:async';

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

  late GoogleMapController _mapController;
  final Location _locationController = Location();
  // ignore: unused_field
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
                  initialCameraPosition: const CameraPosition(
                    target: _initialPosition,
                    zoom: 13.0,
                  ),
                  markers: {
                    Marker(
                      markerId: const MarkerId('_currentLocation'),
                      position: _currentPosition!,
                    ),
                  },
                ),
          // SafeArea(
          //   child: Padding(
          //     padding: const EdgeInsets.all(8.0),
          //     child: Column(
          //       children: [
          //         // Search box and icons
          //         Container(
          //           margin: const EdgeInsets.symmetric(horizontal: 16),
          //           padding:
          //               const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          //           decoration: BoxDecoration(
          //             color: Colors.grey.shade300,
          //             borderRadius: BorderRadius.circular(16),
          //           ),
          //           child: Row(
          //             children: [
          //               TextField(
          //                 obscureText: true,
          //                 style: const TextStyle(color: Colors.white),
          //                 decoration: InputDecoration(
          //                   labelText: 'Your Location',
          //                   labelStyle: const TextStyle(
          //                     color: Color.fromARGB(255, 145, 145, 145),
          //                   ),
          //                   enabledBorder: OutlineInputBorder(
          //                     borderRadius: BorderRadius.circular(20),
          //                     borderSide: const BorderSide(color: Colors.white),
          //                   ),
          //                   focusedBorder: OutlineInputBorder(
          //                     borderRadius: BorderRadius.circular(20),
          //                     borderSide: const BorderSide(
          //                         color: Color.fromRGBO(205, 221, 169, 0.651)),
          //                   ),
          //                   filled: true,
          //                   fillColor: Colors.white,
          //                 ),
          //               ),
          //               const Spacer(),
          //               const Icon(Icons.filter_alt, color: Colors.green),
          //             ],
          //           ),
          //         ),
          //         const SizedBox(height: 20),
          //         // Circular buttons on the right side
          //         Align(
          //           alignment: Alignment.topRight,
          //           child: Column(
          //             mainAxisSize: MainAxisSize.min,
          //             children: [
          //               IconButton(
          //                 icon: const Icon(
          //                   Icons.location_pin,
          //                   color: Colors.green,
          //                 ),
          //                 onPressed: () {},
          //               ),
          //               IconButton(
          //                 icon: const Icon(
          //                   Icons.phone,
          //                   color: Colors.green,
          //                 ),
          //                 onPressed: () {},
          //               ),
          //             ],
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
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
          _pointToUser(_currentPosition!);
        });
      }
    });
  }

  Future<void> _pointToUser(LatLng position) async {
    final GoogleMapController controller = await _mapController.future;

    CameraPosition newCameraPosition = CameraPosition(
      target: position,
      zoom: 13,
    );

    await controller.animateCamera(
      CameraUpdate.newCameraPosition(newCameraPosition),
    );
  }
}
