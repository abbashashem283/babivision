import 'package:babivision/data/storage/SecureStorage.dart';

class TokenTypes {
  static const String ACCESS = "access_token";
  static const String REFRESH = "refresh_token";
  static const String CSRF = "csrf_token";
}

class Tokens {
  static Future<String?> get(String type) async {
    final String? token = await SecureStorage().read(type);
    return token;
  }

  static Future<void> set(String type, String token) async {
    await SecureStorage().write(type, token);
  }

  static Future<void> setAll({
    required String accessToken,
    required String refreshToken,
    required String csrfToken,
  }) async {
    await SecureStorage().write(TokenTypes.ACCESS, accessToken);
    await SecureStorage().write(TokenTypes.REFRESH, refreshToken);
    await SecureStorage().write(TokenTypes.CSRF, csrfToken);
  }

  static Future<Map<String, String>?> getAll() async {
    String? access = await get(TokenTypes.ACCESS);
    String? refresh = await get(TokenTypes.REFRESH);
    String? csrf = await get(TokenTypes.CSRF);
    if (access == null || refresh == null || csrf == null) return null;
    return {
      TokenTypes.ACCESS: access,
      TokenTypes.REFRESH: refresh,
      TokenTypes.CSRF: csrf,
    };
  }
}
