class Location {
  final String city;
  final String country;

  Location(this.city, this.country);

  @override
  String toString() {
    return '$city - $country';
  }
}