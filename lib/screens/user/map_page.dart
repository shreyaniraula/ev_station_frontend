import 'dart:async';
import 'dart:convert';

import 'package:ev_charge/constants/api_key.dart';
import 'package:ev_charge/constants/ev_station_coordinates.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;

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
  LatLng? currentPosition;
  final Set<Marker> _markers = {};
  final List<LatLng> routeCoordinates = [];
  final Set<Polyline> _polylines = {};

  @override
  void initState() {
    super.initState();
    getUserLocation().then((response) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            markers: _markers,
            polylines: _polylines,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            initialCameraPosition: const CameraPosition(
              target: _initialPosition,
              zoom: 13.0,
            ),
            onMapCreated: ((GoogleMapController controller) {
              _mapController.complete(controller);
              _moveCameraToCurrentPosition();
            }),
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton(
              onPressed: findNearestEVStation,
              tooltip: 'Find Nearest EV Station',
              child: const Icon(Icons.local_car_wash),
            ),
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
        if (mounted) {
          setState(() {
            currentPosition = LatLng(
              currentLocation.latitude!,
              currentLocation.longitude!,
            );
            displayMarkers();
          });
        }
        _moveCameraToCurrentPosition();
      }
    });
  }

  Future<void> displayMarkers() async {
    _markers.clear();
    // Add user's location marker
    if (currentPosition != null) {
      _markers.add(Marker(
        markerId: const MarkerId('user_location'),
        position: currentPosition!,
        infoWindow: const InfoWindow(title: 'My location'),
      ));
    }

    final stationIcon = await BitmapDescriptor.asset(
      const ImageConfiguration(size: Size(20, 20)),
      'assets/images/charging_station.png',
    );
    for (var data in evStationsCoordinates) {
      _markers.add(
        Marker(
          markerId: MarkerId(data['name']),
          position: LatLng(data['latitude'], data['longitude']),
          icon: stationIcon,
          infoWindow: InfoWindow(title: data['name']),
        ),
      );
    }
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _moveCameraToCurrentPosition() async {
    final controller = await _mapController.future;
    if (currentPosition != null) {
      controller.animateCamera(CameraUpdate.newLatLng(currentPosition!));
    }
  }

  Future<void> findNearestEVStation() async {
    if (currentPosition == null) return;

    double nearestDistance = double.infinity;
    Map<String, dynamic>? nearestStation;

    for (var station in evStationsCoordinates) {
      LatLng stationLocation =
          LatLng(station['latitude'], station['longitude']);
      double distance = await getDistance(currentPosition!, stationLocation);
      print('Distance to ${station['name']}: $distance');
      if (distance < nearestDistance) {
        nearestDistance = distance;
        nearestStation = station; // Store the nearest station
      }
    }

    if (nearestStation != null) {
      print(
          'Nearest station: ${nearestStation['name']} at $nearestDistance meters');
      // Add the nearest station marker
      _markers.add(Marker(
        markerId: const MarkerId('nearest_station'),
        position:
            LatLng(nearestStation['latitude'], nearestStation['longitude']),
        icon: await BitmapDescriptor.asset(
          const ImageConfiguration(size: Size(20, 20)),
          'assets/images/charging_station.png',
        ),
        infoWindow: InfoWindow(
          title: nearestStation['name'],
          snippet: '${(nearestDistance / 1000).toStringAsFixed(2)} km away',
        ),
      ));

      // Show distance and duration
      final distanceAndDuration = await getDistanceAndDuration(currentPosition!,
          LatLng(nearestStation['latitude'], nearestStation['longitude']));
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
            'Nearest EV Station: ${nearestStation['name']} (${(nearestDistance / 1000).toStringAsFixed(2)} km away, ${distanceAndDuration['duration']})'),
      ));

      if (mounted) {
        setState(() {});
      }
      getRouteToStation(currentPosition!, nearestStation);
    }
  }

  Future<Map<String, dynamic>> getDistanceAndDuration(
      LatLng start, LatLng end) async {
    final response = await http.get(
      Uri.parse(
        'https://maps.gomaps.pro/maps/api/directions/json?origin=${start.latitude},${start.longitude}&destination=${end.latitude},${end.longitude}&key=$kGoMapsProApiKey',
      ),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == 'OK') {
        // Extract distance and duration from the response
        String distanceText = data['routes'][0]['legs'][0]['distance']['text'];
        String durationText = data['routes'][0]['legs'][0]['duration']['text'];
        return {
          'distance': distanceText,
          'duration': durationText,
        };
      } else {
        throw Exception('Failed to calculate distance: ${data['status']}');
      }
    } else {
      throw Exception('Failed to load directions');
    }
  }

  Future<void> getRouteToStation(
      LatLng start, Map<String, dynamic> station) async {
    final String url =
        'https://maps.gomaps.pro/maps/api/directions/json?origin=${start.latitude},${start.longitude}&destination=${station['latitude']},${station['longitude']}&key=$kGoMapsProApiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data['routes'].isNotEmpty) {
        // Get steps and decode each step polyline
        List<LatLng> routePoints = [];
        for (var step in data['routes'][0]['legs'][0]['steps']) {
          String polyline = step['polyline']['points'];
          routePoints.addAll(decodePolyline(polyline));
        }

        // Add the polyline to the map
        if (mounted) {
          setState(() {
            _polylines.clear(); // Clear any existing route
            _polylines.add(
              Polyline(
                polylineId: PolylineId('route'),
                color: Colors.blue, // Choose your desired color
                width: 5, // Width of the route line
                points: routePoints,
              ),
            );
          });
        }
      }
    }
  }

  List<LatLng> decodePolyline(String poly) {
    List<LatLng> result = [];
    int index = 0, len = poly.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, resultLat = 0;
      do {
        b = poly.codeUnitAt(index++) - 63;
        resultLat |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((resultLat & 1) != 0 ? ~(resultLat >> 1) : (resultLat >> 1));
      lat += dlat;

      shift = 0;
      int resultLng = 0;
      do {
        b = poly.codeUnitAt(index++) - 63;
        resultLng |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((resultLng & 1) != 0 ? ~(resultLng >> 1) : (resultLng >> 1));
      lng += dlng;

      LatLng p = LatLng(lat / 1E5, lng / 1E5);
      result.add(p);
    }

    return result;
  }

  Future<double> getDistance(LatLng start, LatLng end) async {
    return Geolocator.distanceBetween(
      start.latitude,
      start.longitude,
      end.latitude,
      end.longitude,
    );
  }
}
