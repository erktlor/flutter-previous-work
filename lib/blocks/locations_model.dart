import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wevpn/screens/main/status.dart';
import 'package:wevpn/widgets/location_picker/data/locations.dart';

String _generateId(String isoCode, {City city}) {
  return "$isoCode:${city?.name ?? '-'}"; //'   iso_code:city_name  or  iso_code:-'
}

const _kRecentIds = 'recentIds';

class LocationsModel extends ChangeNotifier {
  final _countries = Country.all();
  SharedPreferences _prefs;
  List<Location> _locations = [];
  String _selectedId;
  String _bestId;
  List<String> _recentIds = [];
  String _filter;
  
  Future<void> init() async {
    _locations = _generateLocations();
    _selectedId = 'US:New York';
    _bestId = 'US:New York';
    _filter = '';
    _prefs = await SharedPreferences.getInstance();
    _recentIds = _prefs.getStringList(_kRecentIds) ?? [];
    allLocations;
    recentLocations;
  }

  setSelected(String itemId) {
    _selectedId = itemId;
    notifyListeners();
  }

  _saveRecentIds() => _prefs.setStringList(_kRecentIds, _recentIds);

  int get serverLocations => _locations.length;

  set filter(String value) {
    _filter = value.toLowerCase();
    notifyListeners();
  }

  List<LocationItem> get allLocations => _locations
        .where((location) => _filter.isEmpty ? true : location.name.toLowerCase().contains(_filter))
        .map((location) => _convertItem(location))
        .toList();

  List<LocationItem> get recentLocations => _recentIds
      .map((locId) => _locations.firstWhere((l) => l.id == locId))
      .where((location) => _filter.isEmpty
        ? _recentIds.contains(location.id)
        : location.name.toLowerCase().contains(_filter) && _recentIds.contains(location.id))
      .map((location) => _convertItem(location))
      .toList();

  LocationItem _convertItem(Location location) {
    return LocationItem(location,
        isBest: location.id == _bestId, isSelected: location.id == _selectedId);
  }

  LocationItem get selectedLocation => _locations
      .where((location) => location.id == _selectedId)
      .map((location) => _convertItem(location))
      .first;

  List<Location> _generateLocations() {
    var result = <Location>[];
    _countries.forEach((Country country) {
      if (country.cities?.isEmpty ?? true) {
        result.add(Location(
            _generateId(country.isoCode), country.name, country.asset));
      } else {
        country.cities.forEach((city) {
          String name = "${country.name} - ${city.name}";
          result.add(Location(
              _generateId(country.isoCode, city: city), name, country.asset));
        });
      }
    });
    result.sort((a, b) => a.name.compareTo(b.name));
    return result;
  }

  LocationItem get bestLocation {
    return _locations
        .where((location) => location.id == _bestId)
        .map((location) => _convertItem(location))
        .first;
  }

  void updateStatus(Status status) {
    if (status == Status.CONNECTED) {

      if (_recentIds.indexOf(_selectedId) != 0) {
        _recentIds.remove(_selectedId);
        _recentIds.insert(0, _selectedId);
        _recentIds.length = min(_recentIds.length, 3);

        _saveRecentIds();

        notifyListeners();
      }
    }
  }
}
