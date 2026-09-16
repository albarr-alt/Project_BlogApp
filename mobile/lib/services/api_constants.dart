import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';

class ApiConstants {
  // Ubah URL di bawah ini jika menggunakan HP Fisik (misal: "http://192.168.1.15:3000")
  static const String? _customBaseUrl = null;

  static String get baseUrl {
    if (_customBaseUrl != null && _customBaseUrl!.isNotEmpty) {
      return _customBaseUrl!;
    }

    if (kIsWeb) {
      return "http://localhost:3000";
    }

    // Jika berjalan di Android Emulator, arahkan ke 10.0.2.2 (alias localhost PC)
    if (Platform.isAndroid) {
      return "http://10.0.2.2:3000";
    }

    // Desktop (Windows/macOS/Linux) atau iOS Simulator
    return "http://localhost:3000";
  }

  static String get registerEndpoint => "$baseUrl/api/v1/auth/register";
  static String get loginEndpoint => "$baseUrl/api/v1/auth/login";
  static String get postsEndpoint => "$baseUrl/api/v1/posts";
  static String get usersEndpoint => "$baseUrl/api/v1/users";
}

