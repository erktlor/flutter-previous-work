class Location {
  final String asset;
  final String name;
  final String id;

  Location(this.id, this.name, this.asset);
}

class LocationItem {
  final Location location;
  final bool isSelected;
  final bool isBest;

  LocationItem(this.location, {this.isSelected = false, this.isBest = false});
}
