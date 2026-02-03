class LocationModel {
  final int id;
  final String name;
  final double lat;
  final double lng;

  LocationModel({required this.id, required this.name, required this.lat, required this.lng});

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      id: json['id'],
      name: json['name'],
      lat: double.parse(json['latitude'].toString()),
      lng: double.parse(json['longitude'].toString()),
    );
  }
}