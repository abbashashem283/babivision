import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Http {
  static Future<Response<dynamic>> get(
    String endpoint, {
    Map<String, dynamic>? headers,
  }) async {
    final client = Dio();
    final fullPath = "${dotenv.env['HOST']}$endpoint";
    headers = {...?headers, "Accept": "application/json"};
    try {
      final response = await client.get(
        fullPath,
        options: Options(headers: headers),
      );
      return response;
    } on DioException catch (e) {
      if (e.response != null) {
        return e.response!;
      }
      rethrow;
    }
  }

  static Future<Response<dynamic>> post(
    String endpoint,
    Map<String, dynamic> data, {
    Map<String, dynamic>? headers,
  }) async {
    final client = Dio();
    final fullPath = "${dotenv.env['HOST']}$endpoint";
    headers = {...?headers, "Accept": "application/json"};
    try {
      final response = await client.post(
        fullPath,
        data: data,
        options: Options(headers: headers),
      );
      return response;
    } on DioException catch (e) {
      if (e.response != null) {
        return e.response!;
      }
      rethrow;
    }
  }
}
