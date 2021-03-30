import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wevpn/widgets/location_picker/data/city.dart';

class Country {
  final String asset;
  final String isoCode;
  final String name;

  final List<City> cities;

  Country({
    @required this.asset,
    @required this.isoCode,
    this.name = '',
    this.cities,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Country &&
          runtimeType == other.runtimeType &&
          asset == other.asset &&
          isoCode == other.isoCode &&
          name == other.name &&
          cities == other.cities;

  @override
  int get hashCode =>
      asset.hashCode ^ isoCode.hashCode ^ name.hashCode ^ cities.hashCode;

//  String getDisplayName() =>
//      this.name +
//          (selectedLocationIndex > -1
//              ? " - ${this.locations[selectedLocationIndex].name}"
//              : '');
//
//  bool hasLocations() => locations?.isNotEmpty ?? false;
//
//  String getId() => _favoriteId(isoCode, selectedLocationIndex > -1 ?
//      locations[selectedLocationIndex]
//      : null);

//  Country copyWith({String name, int selectedIndex, bool favorite, List<Location> locations}) {
//    return Country(
//        name: name ?? this.name,
//        isoCode: this.isoCode,
//        asset: this.asset,
//        locations: locations ?? this.locations,
//        selectedLocationIndex: selectedIndex ?? this.selectedLocationIndex,
//        favorite: favorite ?? this.favorite
//    );
//  }
//
//  Country copy() {
//    return Country(
//      name: this.name,
//      isoCode: this.isoCode,
//      asset: this.asset,
//      locations: this.locations,
//      selectedLocationIndex: this.selectedLocationIndex,
//    );
//  }

//  List<Location> getFavoriteLocations(){
//    return locations?.where((location)=>location.favorite)?.toList() ?? <Location>[];
//  }

  static Future<List<String>> getFavoriteIds() async {
    var _prefs = await SharedPreferences.getInstance();
    var favoriteIds = _prefs.getStringList("favoriteIds");
    if (favoriteIds == null) {
      favoriteIds = <String>[];
      _prefs.setStringList("favoriteIds", favoriteIds);
    }
    return favoriteIds;
  }

  static Future<void> setFavoriteIds(List<String> favoriteIds) async {
    var _prefs = await SharedPreferences.getInstance();
    List<String> _favoriteIds = _prefs.getStringList("favoriteIds");
    Function eq = const ListEquality().equals;

    if (!eq(_favoriteIds, favoriteIds)) {
      _prefs.setStringList("favoriteIds", favoriteIds);
    }
    return favoriteIds;
  }

  static Country us = Country(
      asset: "assets/svgs/flags/USA.svg",
      isoCode: "US",
      name: "USA",
      cities: [
        City('New York'),
        City('Atlanta'),
        City('Boston'),
        City('Austin'),
      ]);

  static Country ca = Country(
      asset: "assets/svgs/flags/Canada.svg",
      isoCode: "CA",
      name: "Canada",
      cities: [
        City('CA Vancouver'),
        City('CA Toronto'),
        City('CA Montreal'),
      ]);

  static Country mx = Country(
    asset: "assets/svgs/flags/Mexico.svg",
    isoCode: "MX",
    name: "Mexico",
  );

  static Country de = Country(
      asset: "assets/svgs/flags/Germany.svg",
      isoCode: "DE",
      name: "Germany",
      cities: [
        City('Frankfurt'),
      ]);

  static Country at = Country(
      asset: "assets/svgs/flags/Austria.svg",
      isoCode: "AT",
      name: "Austria",
      );

  static Country be = Country(
    asset: "assets/svgs/flags/Belgium.svg",
    isoCode: "BE",
    name: "Belgium",
  );

  static Country ne = Country(
    asset: "assets/svgs/flags/Netherlands.svg",
    isoCode: "NE",
    name: "Netherlands",
  );

  static Country dk = Country(
    asset: "assets/svgs/flags/Denmark.svg",
    isoCode: "DK",
    name: "Denmark",
  );

  static Country hu = Country(
    asset: "assets/svgs/flags/Hungary.svg",
    isoCode: "HU",
    name: "Hungary",
  );

  static Country es = Country(
    asset: "assets/svgs/flags/Spain.svg",
    isoCode: "ES",
    name: "Spain",
  );

  static Country it = Country(
    asset: "assets/svgs/flags/Italy.svg",
    isoCode: "IT",
    name: "Italy",
  );

  static Country fr = Country(
    asset: "assets/svgs/flags/France.svg",
    isoCode: "FR",
    name: "France",
  );

  static Country se = Country(
    asset: "assets/svgs/flags/Sweden.svg",
    isoCode: "SE",
    name: "Sweden",
  );

  static Country pl = Country(
    asset: "assets/svgs/flags/Poland.svg",
    isoCode: "PL",
    name: "Poland",
  );

  static Country ro = Country(
    asset: "assets/svgs/flags/Romania.svg",
    isoCode: "RO",
    name: "Romania",
  );

  static Country no = Country(
    asset: "assets/svgs/flags/Norway.svg",
    isoCode: "NO",
    name: "Norway",
  );

  static Country sg = Country(
    asset: "assets/svgs/flags/Singapore.svg",
    isoCode: "SG",
    name: "Singapore",
  );

  static Country ind = Country(
    asset: "assets/svgs/flags/India.svg",
    isoCode: "IN",
    name: "India",
  );
  static Country jp = Country(
    asset: "assets/svgs/flags/Japan.svg",
    isoCode: "JP",
    name: "Japan",
  );
  static Country hk = Country(
    asset: "assets/svgs/flags/Hong-Kong.svg",
    isoCode: "HK",
    name: "Hong Kong",
  );

  static all() => <Country>[
        us,
        ca,
        mx,
        de,
        at,
        be,
        ne,
        dk,
        hu,
        es,
        it,
        fr,
        se,
        pl,
        ro,
        no,
        sg,
        ind,
        jp,
        hk,
      ];

//  static List<Country> populateFavorites(List<Country> countries,
//      List<String> favoriteIds) {
//    return countries.map((country) {
//      if(country.hasLocations()){
//        List<Location>  locations = country.locations.map((location){
//          String favoriteId = _favoriteId(country.isoCode, location);
//          return location..favorite = favoriteIds.contains(favoriteId);
//        }).toList();
//        return country.copyWith(favorite: favoriteIds.contains(country.getId()), locations: locations);
//      }
//      return country.copyWith(favorite: favoriteIds.contains(country.getId()));
//    }).toList();
//  }
//
//  static List<Country> getFavorites(List<Country> countries){
//    return countries.where((country){
//      return country.favorite || country.getFavoriteLocations().isNotEmpty;
//    }).toList();
//  }
}
