import 'dart:convert';

import 'package:http/http.dart' as http;

class LocationService {
  static const String baseUrl = 'http://localhost:5051/api/locations';

  // Get all locations
  static Future<Map<String, dynamic>> getAllLocations() async {
    try {
      final response = await http.get(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.body.isEmpty) {
        return {'success': false, 'message': 'Empty response from server'};
      }

      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        return {'success': true, 'data': responseData['data']};
      } else {
        return {
          'success': false,
          'message':
              responseData['message'] ?? 'Lỗi khi lấy danh sách địa điểm',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Lỗi kết nối: ${e.toString()}'};
    }
  }

  // Get featured locations
  static Future<Map<String, dynamic>> getFeaturedLocations() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/featured'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.body.isEmpty) {
        return {'success': false, 'message': 'Empty response from server'};
      }

      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        return {'success': true, 'data': responseData['data']};
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? 'Lỗi khi lấy địa điểm nổi bật',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Lỗi kết nối: ${e.toString()}'};
    }
  }

  // Get location by ID
  static Future<Map<String, dynamic>> getLocationById(String id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/$id'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.body.isEmpty) {
        return {'success': false, 'message': 'Empty response from server'};
      }

      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        return {'success': true, 'data': responseData['data']};
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? 'Không tìm thấy địa điểm',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Lỗi kết nối: ${e.toString()}'};
    }
  }
}
