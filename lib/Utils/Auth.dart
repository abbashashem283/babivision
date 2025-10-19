import 'package:babivision/Utils/Http.dart';
import 'package:babivision/Utils/Tokens.dart';
import 'package:babivision/data/storage/SecureStorage.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class Auth {
  static Future<Response<dynamic>?> refreshTokens() async {
    debugPrint("...attempting token refresh");
    final tokens = await Tokens.getAll();
    if (tokens == null) return null;
    try {
      final response = await Http.post(
        '/api/auth/refresh',
        {'refresh_token': tokens['refresh_token']},
        headers: {"Authorization": "Bearer ${tokens['access_token']}"},
      );
      //debugPrint("...response got ${response.data.toString()}");
      return response;
    } on DioException catch (e) {
      debugPrint("refresh error ${e.response?.data.toString()}");
      return e.response;
    }
  }

  static Future<Map<String, dynamic>?> user() async {
    Map<String, dynamic>? localUser = await SecureStorage().read("user");
    if (localUser != null) return localUser;
    final userResponse = await Http.get("/api/auth/user", isAuth: true);
    final user = userResponse.data['user'];
    return user;
  }
}
