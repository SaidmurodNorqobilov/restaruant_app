import 'package:shared_preferences/shared_preferences.dart';

class LocationStorage {
  static const String _latKey = 'selected_latitude';
  static const String _lngKey = 'selected_longitude';

  static Future<void> saveLocation(double lat, double lng) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_latKey, lat);
    await prefs.setDouble(_lngKey, lng);
  }

  static Future<Map<String, double>?> getLocation() async {
    final prefs = await SharedPreferences.getInstance();
    final double? lat = prefs.getDouble(_latKey);
    final double? lng = prefs.getDouble(_lngKey);

    if (lat != null && lng != null) {
      return {'lat': lat, 'lng': lng};
    }
    return null;
  }

  static Future<void> clearLocation() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_latKey);
    await prefs.remove(_lngKey);
  }
}