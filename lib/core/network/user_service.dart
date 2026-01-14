import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  static const String _firstNameKey = 'user_first_name';
  static const String _lastNameKey = 'user_last_name';
  static const String _regionKey = 'user_region';
  static const String _phoneKey = 'user_phone';
  static const String _imagePathKey = 'user_image_path';
  static const String _isLoggedInKey = 'is_logged_in';

  static final ValueNotifier<int> userDataChanged = ValueNotifier<int>(0);

  static Future<void> savePhoneNumber(String phone) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_phoneKey, phone);
  }

  static Future<void> saveUserData({
    required String firstName,
    required String lastName,
    required String region,
    String? imagePath,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_firstNameKey, firstName);
    await prefs.setString(_lastNameKey, lastName);
    await prefs.setString(_regionKey, region);
    if (imagePath != null) {
      await prefs.setString(_imagePathKey, imagePath);
    }
    await prefs.setBool(_isLoggedInKey, true);

    userDataChanged.value++;
  }

  static Future<Map<String, String?>> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'firstName': prefs.getString(_firstNameKey),
      'lastName': prefs.getString(_lastNameKey),
      'region': prefs.getString(_regionKey),
      'phone': prefs.getString(_phoneKey),
      'imagePath': prefs.getString(_imagePathKey),
    };
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  static Future<bool> hasPhoneNumber() async {
    final prefs = await SharedPreferences.getInstance();
    final phone = prefs.getString(_phoneKey);
    return phone != null && phone.isNotEmpty;
  }

  static Future<void> updateProfileImage(String imagePath) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_imagePathKey, imagePath);

    userDataChanged.value++;
  }
  static Future<void> updateProfile({
    String? firstName,
    String? lastName,
    String? region,
    String? imagePath,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    if (firstName != null) await prefs.setString(_firstNameKey, firstName);
    if (lastName != null) await prefs.setString(_lastNameKey, lastName);
    if (region != null) await prefs.setString(_regionKey, region);
    if (imagePath != null) await prefs.setString(_imagePathKey, imagePath);
    userDataChanged.value++;
  }
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_firstNameKey);
    await prefs.remove(_lastNameKey);
    await prefs.remove(_regionKey);
    await prefs.remove(_phoneKey);
    await prefs.remove(_imagePathKey);
    await prefs.setBool(_isLoggedInKey, false);
    await prefs.clear();
    userDataChanged.value++;
  }

  static Future<String> getFullName() async {
    final userData = await getUserData();
    final firstName = userData['firstName'] ?? '';
    final lastName = userData['lastName'] ?? '';
    if (firstName.isEmpty && lastName.isEmpty) {
      return 'Foydalanuvchi';
    }
    return '$firstName $lastName'.trim();
  }
}
