import 'package:babivision/Utils/Auth.dart';
import 'package:babivision/Utils/Tokens.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MissingTokenException implements Exception {
  final String message;
  MissingTokenException({required this.message});
}

class AuthenticationFailedException implements Exception {
  final String message;
  AuthenticationFailedException({required this.message});
}

class Http {
  static List<int> authErrorCodes = [403, 401, 409];

  static Future<Response<dynamic>> get(
    String endpoint, {
    Map<String, dynamic>? headers,
    bool isAuth = false,
  }) async {
    final client = Dio();
    final fullPath = "${dotenv.env['HOST']}$endpoint";
    headers = {...?headers, "Accept": "application/json"};
    if (isAuth) {
      final tokens = await Tokens.getAll();
      if (tokens == null)
        throw MissingTokenException(
          message: "some or all tokens are missing from local storage",
        );
      headers = {
        ...headers,
        "Authorization": "Bearer ${tokens['access_token']}",
      };
    }
    try {
      final response = await client.get(
        fullPath,
        options: Options(headers: headers),
      );
      debugPrint("response by dio ${response.data.toString()}");

      return response;
    } on DioException catch (e) {
      if (e.response == null) rethrow;
      final response = e.response!;
      final responseCode = response.statusCode;
      if (isAuth && authErrorCodes.contains(responseCode)) {
        final refreshResponse = await Auth.refreshTokens();
        if (refreshResponse == null || refreshResponse.data["type"] == "error")
          throw AuthenticationFailedException(
            message: refreshResponse?.data["message"] ?? "...",
          );
        await Tokens.setAll(
          accessToken: refreshResponse.data['access_token'],
          refreshToken: refreshResponse.data['refresh_token'],
          csrfToken: refreshResponse.data['csrf_token'],
        );
        debugPrint("fetching $endpoint again isAuth: $isAuth");
        return get(endpoint, isAuth: isAuth);
      }
      return response;
    }
  }

  static Future<Response<dynamic>> post(
    String endpoint,
    Map<String, dynamic> data, {
    Map<String, dynamic>? headers,
    bool isAuth = false,
  }) async {
    final client = Dio();
    final fullPath = "${dotenv.env['HOST']}$endpoint";
    headers = {...?headers, "Accept": "application/json"};
    if (isAuth) {
      final tokens = await Tokens.getAll();
      if (tokens == null)
        throw MissingTokenException(
          message: "some or all tokens are missing from local storage",
        );
      headers = {
        ...headers,
        "Authorization": "Bearer ${tokens['access_token']}",
      };
      data = {...data, "csrf_token": tokens['csrf_token']};
    }
    try {
      final response = await client.post(
        fullPath,
        data: data,
        options: Options(headers: headers),
      );
      return response;
    } on DioException catch (e) {
      if (e.response == null) rethrow;
      final response = e.response!;
      final responseCode = response.statusCode;
      if (isAuth && authErrorCodes.contains(responseCode)) {
        final refreshResponse = await Auth.refreshTokens();
        if (refreshResponse == null || refreshResponse.data["type"] == "error")
          throw AuthenticationFailedException(
            message: refreshResponse?.data["message"] ?? "...",
          );
        await Tokens.setAll(
          accessToken: refreshResponse.data['access_token'],
          refreshToken: refreshResponse.data['refresh_token'],
          csrfToken: refreshResponse.data['csrf_token'],
        );
        debugPrint("fetching $endpoint again isAuth: $isAuth");
        return post(endpoint, data, isAuth: isAuth);
      }
      return response;
    }
  }
}
