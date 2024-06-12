import 'dart:convert';
// import 'dart:math';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logging/logging.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';

final Logger logger = Logger('UserUtilLogger');

Future<Map<String, dynamic>> signInUserHTTP(
    String email, String password) async {
  var dio = Dio();
  var headers = {
    // 'apikey': dotenv.env['API_KEY'],
    // 'Authorization': '${dotenv.env['AUTHORIZATION']}',
    'apikey': const String.fromEnvironment('API_KEY'),
    'Authorization': const String.fromEnvironment('AUTHORIZATION'),
    'Content-Type': 'application/json',
  };
  var data = json.encode({"email": email, "password": password});

  try {
    var response = await dio.post(
      'https://phhvtpfbwuzoxvbiygib.supabase.co/auth/v1/token?grant_type=password',
      data: data,
      options: Options(headers: headers),
    );

    if (response.statusCode == 200) {
      return {
        "access_token": response.data["access_token"],
        'expires_in': response.data['expires_in'],
        'user_id': response.data['user']['id'],
        'email': response.data['user']['email']
      };
    } else {
      logger.info(response.statusCode);
      logger.info(response.statusMessage);
      return {"response": response.statusMessage};
    }
  } catch (e) {
    logger.info(e);
    return {"error": e};
  }
}

Future<bool> signOutUser() async {
  try {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    logger.info('User signed out and shared preferences cleared');
    return true; 
    
  } catch (e) {
    logger.info('Error signing out: $e');
    return false;
  }
}
