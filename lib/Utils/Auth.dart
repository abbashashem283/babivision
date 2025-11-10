import 'dart:convert';
//import 'dart:nativewrappers/_internal/vm/lib/internal_patch.dart';

import 'package:babivision/Utils/Http.dart';
import 'package:babivision/Utils/Tokens.dart';
import 'package:babivision/data/storage/SecureStorage.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:babivision/data/ValueNotifiers.dart' as Notifiers;

class Auth {
  static Future<Response<dynamic>?> refreshTokens() async {
    //debugPrint("...attempting token refresh");
    final tokens = await Tokens.getAll();
    if (tokens == null) return null;
    try {
      final response = await Http.post(
        '/api/auth/refresh',
        {'refresh_token': tokens['refresh_token']},
        headers: {"Authorization": "Bearer ${tokens['access_token']}"},
      );
      ////debugPrint("...response got ${response.data.toString()}");
      return response;
    } on DioException catch (e) {
      //debugPrint("refresh error ${e.response?.data.toString()}");
      return e.response;
    }
  }

  static Future<Map<String, dynamic>?> user() async {
    //debugPrint("**1");
    String? storedUser = await SecureStorage().read("user");
    //debugPrint("stored user is ${storedUser.toString()}");
    if (storedUser != null) {
      //debugPrint("attempting to decode stored user ${storedUser}");
      Map<String, dynamic> localUser = jsonDecode(storedUser);
      Notifiers.user.value = localUser;
      //debugPrint("decode successfull returning $localUser)");
      return localUser;
    }
    try {
      final userResponse = await Http.get("/api/auth/user", isAuth: true);
      //debugPrint("**2 ${userResponse.data.toString()}");
      final user = userResponse.data['user'];
      //debugPrint("**3");
      if (user == null) return user;
      await SecureStorage().write("user", jsonEncode(user));
      Notifiers.user.value = user;
      //debugPrint("**4");
      return user;
    } catch (e) {
      if (e is MissingTokenException || e is AuthenticationFailedException) {
        return null;
      }
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> logout() async {
    final response = await Http.post("/api/auth/logout", {}, isAuth: true);
    final data = response.data;
    if (data["type"] == "success") {
      await Tokens.removeAll();
      Notifiers.user.value = null;
    }
    return data;
  }
}
