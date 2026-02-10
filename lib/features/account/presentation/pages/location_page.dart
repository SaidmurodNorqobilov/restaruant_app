import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:restaurantapp/core/constants/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/locationBloc/location_bloc.dart';

enum LocationPageMode { add, view, edit }

class LocationPage extends StatefulWidget {
  final LocationPageMode mode;
  final String? locationId;
  final String? initialTitle;
  final String? initialAddress;
  final double? initialLat;
  final double? initialLng;

  const LocationPage({
    super.key,
    this.mode = LocationPageMode.add,
    this.locationId,
    this.initialTitle,
    this.initialAddress,
    this.initialLat,
    this.initialLng,
  });

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  late YandexMapController mapController;
  Point? cameraPosition;
  String selectedAddress = 'Aniqlanmoqda...';
  bool isLoading = false;
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  List<Placemark> searchResults = [];
  bool isSearching = false;
  final List<PlacemarkMapObject> placemarks = [];

  @override
  void initState() {
    super.initState();
    if (widget.mode != LocationPageMode.add) {
      _titleController.text = widget.initialTitle ?? '';
      selectedAddress = widget.initialAddress ?? '';
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  String get _pageTitle {
    switch (widget.mode) {
      case LocationPageMode.add:
        return 'Yangi manzil qo\'shish';
      case LocationPageMode.view:
        return 'Manzilni ko\'rish';
      case LocationPageMode.edit:
        return 'Manzilni o\'zgartirish';
    }
  }

  String get _buttonText {
    switch (widget.mode) {
      case LocationPageMode.add:
        return 'Shu yerga yetkazish';
      case LocationPageMode.view:
        return 'Yopish';
      case LocationPageMode.edit:
        return 'O\'zgarishlarni saqlash';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isViewMode = widget.mode == LocationPageMode.view;
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
        title: widget.mode == LocationPageMode.view
            ? Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 6,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            widget.initialTitle ?? '',
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        )
            : null,
      ),
      body: Stack(
        children: [
          YandexMap(
            mapObjects: isViewMode ? placemarks : [],
            onMapCreated: (controller) async {
              mapController = controller;
              await mapController.toggleUserLayer(
                visible: true,
                headingEnabled: true,
              );
              await _initializeLocation();
            },
            onCameraPositionChanged: isViewMode
                ? null
                : (position, reason, finished) {
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
          if (!isViewMode)
            Positioned(
              top: 100,
              left: 16,
              right: 16,
              child: Column(
                children: [
                  Container(
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
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Manzilni qidirish...',
                        hintStyle: TextStyle(
                          color: isDark
                              ? AppColors.white.withOpacity(0.5)
                              : Colors.grey,
                        ),
                        prefixIcon: Icon(
                          Icons.search,
                          color: isDark ? AppColors.white : Colors.grey,
                        ),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                          icon: Icon(
                            Icons.clear,
                            color: isDark ? AppColors.white : Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              _searchController.clear();
                              searchResults.clear();
                              isSearching = false;
                            });
                          },
                        )
                            : null,
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                      ),
                      style: TextStyle(
                        color: isDark ? AppColors.white : Colors.black,
                      ),
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          _searchLocation(value);
                        } else {
                          setState(() {
                            searchResults.clear();
                            isSearching = false;
                          });
                        }
                      },
                    ),
                  ),
                  if (isSearching && searchResults.isNotEmpty)
                    Container(
                      margin: const EdgeInsets.only(top: 8),
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
                      constraints: const BoxConstraints(maxHeight: 200),
                      child: ListView.separated(
                        shrinkWrap: true,
                        padding: const EdgeInsets.all(8),
                        itemCount: searchResults.length,
                        separatorBuilder: (context, index) => Divider(
                          color: isDark
                              ? Colors.grey.shade700
                              : Colors.grey.shade300,
                          height: 1,
                        ),
                        itemBuilder: (context, index) {
                          final place = searchResults[index];
                          final address = [
                            place.street,
                            place.subLocality,
                            place.locality,
                          ].where((e) => e != null && e.isNotEmpty).join(', ');

                          return ListTile(
                            dense: true,
                            leading: Icon(
                              Icons.location_on,
                              color: Colors.red.shade700,
                            ),
                            title: Text(
                              address,
                              style: TextStyle(
                                color: isDark ? AppColors.white : Colors.black,
                                fontSize: 14,
                              ),
                            ),
                            onTap: () async {
                              final locations = await locationFromAddress(
                                address,
                              );
                              if (locations.isNotEmpty) {
                                final location = locations.first;
                                final point = Point(
                                  latitude: location.latitude,
                                  longitude: location.longitude,
                                );
                                await mapController.moveCamera(
                                  CameraUpdate.newCameraPosition(
                                    CameraPosition(target: point, zoom: 17),
                                  ),
                                  animation: const MapAnimation(
                                    type: MapAnimationType.smooth,
                                    duration: 1,
                                  ),
                                );
                                setState(() {
                                  _searchController.clear();
                                  searchResults.clear();
                                  isSearching = false;
                                  selectedAddress = address;
                                });
                              }
                            },
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),
          Positioned(
            top: isViewMode ? 100 : (isSearching ? 320 : 160),
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
                  Icon(
                    Icons.directions_car,
                    color: Colors.green.shade600,
                  ),
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
              onPressed: isLoading ? null : _handleButtonPress,
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
                  : Text(
                _buttonText,
                style: const TextStyle(
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

  Future<void> _searchLocation(String query) async {
    setState(() => isSearching = true);
    try {
      final locations = await locationFromAddress(query);
      if (locations.isNotEmpty) {
        List<Placemark> places = [];
        for (var location in locations.take(5)) {
          final placemarks = await placemarkFromCoordinates(
            location.latitude,
            location.longitude,
          );
          if (placemarks.isNotEmpty) {
            places.add(placemarks.first);
          }
        }
        setState(() {
          searchResults = places;
        });
      }
    } catch (e) {
      debugPrint('Qidirishda xatolik');
      setState(() {
        searchResults.clear();
      });
    }
  }

  Future<void> _initializeLocation() async {
    if (widget.mode == LocationPageMode.view ||
        widget.mode == LocationPageMode.edit) {
      if (widget.initialLat != null && widget.initialLng != null) {
        final point = Point(
          latitude: widget.initialLat!,
          longitude: widget.initialLng!,
        );
        if (widget.mode == LocationPageMode.view) {
          setState(() {
            placemarks.add(
              PlacemarkMapObject(
                mapId: const MapObjectId('saved_location'),
                point: point,
                opacity: 1,
                icon: PlacemarkIcon.single(
                  PlacemarkIconStyle(
                    image: BitmapDescriptor.fromAssetImage(
                      'assets/icons/location_marker.png', // Agar asset bo'lsa
                    ),
                    scale: 0.15,
                  ),
                ),
              ),
            );
          });
        }

        await mapController.moveCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: point, zoom: 17),
          ),
          animation: const MapAnimation(
            type: MapAnimationType.smooth,
            duration: 1,
          ),
        );
        setState(() {
          cameraPosition = point;
        });
      }
    } else {
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

  Future<void> _handleButtonPress() async {
    if (widget.mode == LocationPageMode.view) {
      Navigator.pop(context);
      return;
    }

    if (cameraPosition == null) return;

    if (widget.mode == LocationPageMode.add) {
      await _confirmAddLocation();
    } else if (widget.mode == LocationPageMode.edit) {
      await _confirmEditLocation();
    }
  }

  Future<void> _confirmAddLocation() async {
    if (cameraPosition != null) {
      final isDark = Theme.of(context).brightness == Brightness.dark;
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) => AlertDialog(
          backgroundColor: isDark ? AppColors.darkAppBar : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Text(
            'Manzil nomini kiriting',
            style: TextStyle(
              color: isDark ? AppColors.white : AppColors.textColor,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: TextField(
            controller: _titleController,
            cursorColor: isDark ? AppColors.white : AppColors.textColor,
            style: TextStyle(
              color: isDark ? AppColors.white : AppColors.textColor,
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: isDark ? Colors.grey[800] : Colors.grey[200],
              hintText: "Masalan: Uyim, Ishxonam",
              hintStyle: TextStyle(
                fontSize: 14,
                color: isDark ? Colors.grey[400] : Colors.grey[600],
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                _titleController.clear();
                Navigator.pop(dialogContext);
              },
              child: Text(
                'Bekor qilish',
                style: TextStyle(
                  color: isDark ? AppColors.white : AppColors.textColor,
                  fontSize: 14,
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                if (_titleController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Manzil nomini kiriting'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                setState(() => isLoading = true);
                Navigator.pop(dialogContext);

                context.read<MyLocationBloc>().add(
                  MyLocationAddEvent(
                    title: _titleController.text.trim(),
                    address: selectedAddress,
                    latitude: cameraPosition!.latitude,
                    longitude: cameraPosition!.longitude,
                  ),
                );
                final prefs = await SharedPreferences.getInstance();
                await prefs.setDouble('saved_lat', cameraPosition!.latitude);
                await prefs.setDouble('saved_lng', cameraPosition!.longitude);
                await prefs.setString('saved_address', selectedAddress);

                if (mounted) {
                  Navigator.pop(context, {
                    'address': selectedAddress,
                    'lat': cameraPosition!.latitude,
                    'lng': cameraPosition!.longitude,
                    'title': _titleController.text.trim(),
                  });
                }

                _titleController.clear();
                setState(() => isLoading = false);
              },
              child: Text(
                'Saqlash',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  Future<void> _confirmEditLocation() async {
    if (cameraPosition != null && widget.locationId != null) {
      setState(() => isLoading = true);

      context.read<MyLocationBloc>().add(
        MyLocationEditEvent(
          locationId: widget.locationId!,
          title: widget.initialTitle!,
          address: selectedAddress,
          latitude: cameraPosition!.latitude,
          longitude: cameraPosition!.longitude,
        ),
      );

      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble('saved_lat', cameraPosition!.latitude);
      await prefs.setDouble('saved_lng', cameraPosition!.longitude);
      await prefs.setString('saved_address', selectedAddress);

      if (mounted) {
        Navigator.pop(context);
      }

      setState(() => isLoading = false);
    }
  }
}