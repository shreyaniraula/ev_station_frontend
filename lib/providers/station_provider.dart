import 'package:ev_charge/models/station.model.dart';
import 'package:flutter/material.dart';

class StationProvider extends ChangeNotifier {
  Station _station = Station(
    id: '',
    name: '',
    username: '',
    phoneNumber: '',
    password: '',
    location: '',
    panCard: '',
    stationImage: '',
    noOfSlots: 0,
    isVerified: false,
    accessToken: '',
  );

  Station get station => _station;

  void setStation(String station) {
    _station = Station.fromJson(station);
    notifyListeners();
  }

  void setStationFromModel(Station station) {
    _station = station;
    notifyListeners();
  }
}
