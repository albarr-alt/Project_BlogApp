import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_constants.dart';
import 'auth_service.dart';

class PostService {
  // 1. Ambil Semua Postingan yang Published
  static Future<List<Map<String, dynamic>>> getPosts() async {
    try {
      final response = await http.get(
        Uri.parse(ApiConstants.postsEndpoint),
        headers: {'Accept': 'application/json'},
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

  // 2. Ambil Detail Postingan Berdasarkan ID
  static Future<Map<String, dynamic>?> getPostById(int id) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConstants.postsEndpoint}/$id'),
        headers: {'Accept': 'application/json'},
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

  // 3. Buat Postingan Baru (Support Cloudinary / Multipart atau JSON)
  static Future<Map<String, dynamic>> createPost({
    required String title,
    required String content,
    String? imagePath,
  }) async {
    try {
      final token = await AuthService.getToken();
      final user = await AuthService.getUser();

      if (token == null) {
        return {
          'success': false,
          'message': 'Kamu belum login. Silakan login terlebih dahulu.',
        };
      }

      final userId = user?['id'] ?? 1;

      // Jika ada upload file gambar lokal
      if (imagePath != null && imagePath.isNotEmpty && !imagePath.startsWith('http')) {
        final request = http.MultipartRequest(
          'POST',
          Uri.parse(ApiConstants.postsEndpoint),
        );

        request.headers['Authorization'] = 'Bearer $token';
        request.fields['userId'] = userId.toString();
        request.fields['title'] = title.trim();
        request.fields['content'] = content.trim();

        request.files.add(
          await http.MultipartFile.fromPath('image', imagePath),
        );

        final streamedResponse = await request.send();
        final response = await http.Response.fromStream(streamedResponse);
        final data = jsonDecode(response.body);

        if (response.statusCode == 201 || response.statusCode == 200) {
          return {
            'success': true,
            'message': data['message'] ?? 'Tulisan berhasil diposting!',
            'data': data['data'],
          };
        } else {
          return {
            'success': false,
            'message': data['message'] ?? 'Gagal membuat tulisan (${response.statusCode})',
          };
        }
      } else {
        // Tanpa file atau gambar via URL
        final response = await http.post(
          Uri.parse(ApiConstants.postsEndpoint),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode({
            'userId': userId,
            'title': title.trim(),
            'content': content.trim(),
            if (imagePath != null && imagePath.startsWith('http'))
              'imageUrl': imagePath.trim(),
          }),
        );

        final data = jsonDecode(response.body);

        if (response.statusCode == 201 || response.statusCode == 200) {
          return {
            'success': true,
            'message': data['message'] ?? 'Tulisan berhasil diposting!',
            'data': data['data'],
          };
        } else {
          return {
            'success': false,
            'message': data['message'] ?? 'Gagal membuat tulisan (${response.statusCode})',
          };
        }
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Gagal terhubung ke backend: $e',
      };
    }
  }

  // 4. Update Postingan (PATCH /api/v1/posts/:id)
  static Future<Map<String, dynamic>> updatePost({
    required int id,
    String? title,
    String? content,
    String? imagePath,
  }) async {
    try {
      final token = await AuthService.getToken();
      if (token == null) {
        return {
          'success': false,
          'message': 'Sesi habis, silakan login kembali',
        };
      }

      final response = await http.patch(
        Uri.parse('${ApiConstants.postsEndpoint}/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          if (title != null) 'title': title.trim(),
          if (content != null) 'content': content.trim(),
          if (imagePath != null) 'imageUrl': imagePath.trim(),
        }),
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': data['message'] ?? 'Postingan berhasil diperbarui',
          'data': data['data'],
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Gagal memperbarui postingan',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Gagal memperbarui postingan: $e',
      };
    }
  }

  // 5. Hapus Postingan (DELETE /api/v1/posts/:id)
  static Future<Map<String, dynamic>> deletePost(int id) async {
    try {
      final token = await AuthService.getToken();
      if (token == null) {
        return {
          'success': false,
          'message': 'Sesi habis, silakan login kembali',
        };
      }

      final response = await http.delete(
        Uri.parse('${ApiConstants.postsEndpoint}/$id'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': data['message'] ?? 'Postingan berhasil dihapus',
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Gagal menghapus postingan',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Gagal menghapus postingan: $e',
      };
    }
  }
}
