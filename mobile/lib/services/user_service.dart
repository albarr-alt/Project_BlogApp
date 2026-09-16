import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_constants.dart';
import 'auth_service.dart';

class UserService {
  /// Mengambil semua postingan milik user tertentu berdasarkan userId
  /// Endpoint: GET /api/v1/users/:userId
  static Future<List<Map<String, dynamic>>> getUserPosts(int userId) async {
    try {
      final token = await AuthService.getToken();
      if (token == null) return [];

      final response = await http.get(
        Uri.parse('${ApiConstants.usersEndpoint}/$userId'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        final List<dynamic> postsData = body['data']?['posts'] ?? [];
        return postsData.map((e) => Map<String, dynamic>.from(e)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  /// Mengambil detail postingan milik user tertentu berdasarkan userId & postId
  /// Endpoint: GET /api/v1/users/:userId/posts/:postId
  static Future<Map<String, dynamic>?> getUserPostDetail(
    int userId,
    int postId,
  ) async {
    try {
      final token = await AuthService.getToken();
      if (token == null) return null;

      final response = await http.get(
        Uri.parse('${ApiConstants.usersEndpoint}/$userId/posts/$postId'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        return body['data']?['post'] ?? body['data'];
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
