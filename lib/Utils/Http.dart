import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Http {
  static Future<Response<dynamic>> get(
    String endpoint, {
    Map<String, dynamic>? headers,
  }) async {
    final client = Dio();
    final fullPath = "${dotenv.env['HOST']}$endpoint";
    final response = await client.get(
      fullPath,
      options: Options(headers: headers),
    );
    return response;
  }

  static Future<Response<dynamic>> post(
    String endpoint,
    Map<String, dynamic> data,
    Map<String, dynamic>? headers,
  ) async {
    final client = Dio();
    final fullPath = "${dotenv.env['HOST']}$endpoint";
    final response = await client.post(
      fullPath,
      data: data,
      options: Options(headers: headers),
    );
    return response;
  }
}
