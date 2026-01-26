import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:restaurantapp/core/utils/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';
import 'package:geolocator/geolocator.dart';

class LocationPage extends StatefulWidget {
  const LocationPage({super.key});

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  late YandexMapController mapController;
  Point? cameraPosition;
  String selectedAddress = 'Aniqlanmoqda...';
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: Colors.white,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          YandexMap(
            onMapCreated: (controller) async {
              mapController = controller;
              await mapController.toggleUserLayer(
                visible: true,
                headingEnabled: true,
              );
              await _initializeLocation();
            },
            onCameraPositionChanged: (position, reason, finished) {
              setState(() {
                cameraPosition = position.target;
              });
              if (finished) {
                _getAddressFromPoint(position.target);
              }
            },
            onUserLocationAdded: (view) async {
              return view.copyWith(
                accuracyCircle: view.accuracyCircle.copyWith(
                  fillColor: Colors.blue.withOpacity(0.15),
                ),
              );
            },
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 40),
              child: Icon(
                Icons.location_on,
                size: 45,
                color: Colors.red.shade700,
              ),
            ),
          ),
          Positioned(
            top: 100,
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkAppBar : AppColors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(21),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(Icons.directions_car, color: Colors.green.shade600),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Yetkazib berish manzili',
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? AppColors.white : Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          selectedAddress,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: isDark ? AppColors.white : Colors.black,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            right: 16,
            bottom: 120,
            child: FloatingActionButton(
              mini: true,
              backgroundColor: Colors.white,
              onPressed: _moveToCurrentLocation,
              child: const Icon(Icons.my_location, color: Colors.blue),
            ),
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 30,
            child: ElevatedButton(
              onPressed: isLoading ? null : _confirmLocation,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text(
                      'Shu yerga yetkazish',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _initializeLocation() async {
    final prefs = await SharedPreferences.getInstance();
    final double? lat = prefs.getDouble('saved_lat');
    final double? lng = prefs.getDouble('saved_lng');

    if (lat != null && lng != null) {
      await mapController.moveCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: Point(latitude: lat, longitude: lng),
            zoom: 17,
          ),
        ),
        animation: const MapAnimation(
          type: MapAnimationType.smooth,
          duration: 1,
        ),
      );
    } else {
      await _moveToCurrentLocation();
    }
  }

  Future<void> _moveToCurrentLocation() async {
    setState(() => isLoading = true);
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always) {
        Position position = await Geolocator.getCurrentPosition();
        Point currentPoint = Point(
          latitude: position.latitude,
          longitude: position.longitude,
        );

        await mapController.moveCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: currentPoint, zoom: 17),
          ),
          animation: const MapAnimation(
            type: MapAnimationType.smooth,
            duration: 1.5,
          ),
        );
      }
    } catch (e) {
      debugPrint('Manzil tanlashda xatolik');
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  Future<void> _getAddressFromPoint(Point point) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        point.latitude,
        point.longitude,
      );

      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        setState(() {
          selectedAddress = [
            place.street,
            place.subLocality,
            place.locality,
          ].where((e) => e != null && e.isNotEmpty).join(', ');
        });
      }
    } catch (e) {
      setState(() {
        selectedAddress =
            "${point.latitude.toStringAsFixed(4)}, ${point.longitude.toStringAsFixed(4)}";
      });
    }
  }

  Future<void> _confirmLocation() async {
    if (cameraPosition != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble('saved_lat', cameraPosition!.latitude);
      await prefs.setDouble('saved_lng', cameraPosition!.longitude);
      await prefs.setString('saved_address', selectedAddress);

      Navigator.pop(context, {
        'address': selectedAddress,
        'lat': cameraPosition!.latitude,
        'lng': cameraPosition!.longitude,
      });
      print('Selected Address: $selectedAddress');
      print('Selected Latitude: ${cameraPosition!.latitude}');
      print('Selected Longitude: ${cameraPosition!.longitude}');
    }
  }
}
