import 'package:babivision/Utils/Tokens.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MissingTokenException implements Exception {
  final String message;
  final String tokenType;
  MissingTokenException({required this.message, required this.tokenType});
}

class Http {
  static Future<Response<dynamic>> get(
    String endpoint, {
    Map<String, dynamic>? headers,
    bool isAuth = false,
  }) async {
    final client = Dio();
    final fullPath = "${dotenv.env['HOST']}$endpoint";
    headers = {...?headers, "Accept": "application/json"};
    if (isAuth) {
      final accessToken = await Tokens.get(TokenTypes.ACCESS);
      if (accessToken == null)
        throw MissingTokenException(
          message: "access token is missing",
          tokenType: TokenTypes.ACCESS,
        );
      headers = {...headers, "Authorization": "Bearer $accessToken"};
    }
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
