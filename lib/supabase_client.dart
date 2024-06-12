import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logging/logging.dart';

class SupabaseClient {
  final Logger _logger = Logger('SupabaseClientLogger');

  final Dio _dio = Dio();
  static const String baseUrl = 'https://phhvtpfbwuzoxvbiygib.supabase.co';

  SupabaseClient() {
    _dio.options.baseUrl = baseUrl;
    _dio.options.headers['apikey'] = dotenv.env['API_KEY'];
    _dio.options.headers['Authorization'] = dotenv.env['AUTHORIZATION'];
    _dio.options.headers['Content-Type'] = 'application/json';
  }

  Future<bool> insertNote(String table, String title, String content,
      String userId, String color) async {
    var data = json.encode({
      "title": title,
      "content": content,
      "user_id": userId,
      "color": color,
    });

    try {
      final response = await _dio.post('/rest/v1/$table', data: data);
      if (response.statusCode == 201) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      _logger.info('Error inserting data: $e');
      return false;
    }
  }

  Future<bool> updateNote(String table, String noteId, String title,
      String content, String userId) async {
    // Prepare the data to be updated
    var data = jsonEncode({
      "title": title,
      "content": content,
    });

    try {
      final response =
          await _dio.patch('/rest/v1/$table?id=eq.$noteId', data: data);
      if (response.statusCode == 200 || response.statusCode == 204) {
        return true;
      } else {
        _logger.info("Update failed: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      _logger.info('Error updating data: $e');
      return false;
    }
  }

  Future<List<dynamic>> fetchUserNote(String table, String userId) async {
    try {
      final response = await _dio.get('/rest/v1/$table', queryParameters: {
        "user_id": "eq.$userId",
      });
      return response.data;
    } catch (e) {
      _logger.info('Error fetching data: $e');
      return [];
    }
  }

  Future<bool> deleteNote(String table, String noteId) async {
    try {
      final response = await _dio.delete('/rest/v1/$table?id=eq.$noteId');
      if (response.statusCode == 200 || response.statusCode == 204) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      _logger.info('Error deleting note: $e');
      return false;
    }
  }

  Future<dynamic> signUpUser(String email, String password) async {
    const String signUpEndpoint = '/auth/v1/signup';
    try {
      final response = await _dio.post(
        signUpEndpoint,
        data: {
          'email': email,
          'password': password,
        },
      );
      return response.data;
    } catch (e) {
      _logger.info("Error signing up user: $e");
      return null;
    }
  }
}// SupabaseClient