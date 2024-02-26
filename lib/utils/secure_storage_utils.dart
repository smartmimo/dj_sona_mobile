import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageUtils {
  static const String tokenKey = "token";
  static const String basePathKey = "basePath";

  FlutterSecureStorage flutterStorage = const FlutterSecureStorage();

  Future<String?> getToken() async {
    return await flutterStorage.read(key: tokenKey);
  }

  Future<void> persistToken(String token) async {
    flutterStorage.write(key: tokenKey, value: token);
  }

  Future<void> clearTokenAndBasePath() async {
    await flutterStorage.delete(key: tokenKey);
    await flutterStorage.delete(key: basePathKey);
  }
}
