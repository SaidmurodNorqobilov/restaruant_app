class LocationModel {
  final String id;
  final int userId;
  final String title;
  final String address;
  final double lat;
  final double lng;

  LocationModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.lat,
    required this.lng,
    required this.address,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      id: json['id'] as String,
      userId: json['user_id'] as int,
      title: json['title'] as String,
      address: json['address_line'] as String,
      lat: double.tryParse(json['latitude'].toString()) ?? 0.0,
      lng: double.tryParse(json['longitude'].toString()) ?? 0.0,
    );
  }
}

class MyLocationModel {
  final String id;
  final String title;
  final String address;
  final String latitude;
  final String longitude;

  MyLocationModel({
    required this.id,
    required this.title,
    required this.address,
    required this.latitude,
    required this.longitude,
  });

  factory MyLocationModel.fromJson(Map<String, dynamic> json) {
    return MyLocationModel(
      id: json['id'],
      title: json['title'],
      address: json['addess_line'],
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }
}

class AddLocationRequest {
  final String title;
  final String addressLine;
  final double latitude;
  final double longitude;

  AddLocationRequest({
    required this.title,
    required this.addressLine,
    required this.latitude,
    required this.longitude,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'address_line': addressLine,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
