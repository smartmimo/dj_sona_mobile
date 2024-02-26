import 'package:djsona_mobile/constants/app_constants.dart';
import 'package:dio/dio.dart';
import 'package:djsona_mobile/services/api/request_interceptor.dart';

class ApiService {
  ApiService();

  String get basePath {
    return AppConstants.youtubeBasePath;
  }

  static const Duration _connectTimeout = Duration(milliseconds: 10000);
  static const Duration _receiveTimeout = Duration(milliseconds: 10000);

  final dio = Dio();
  void init() {
    dio.interceptors.add(RequestInterceptor());
    dio.options.connectTimeout = _connectTimeout;
    dio.options.receiveTimeout = _receiveTimeout;
  }

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) {
    late final String urlString;
    if (Uri.tryParse(path)?.hasScheme == false) {
      urlString = "$basePath/$path";
    } else {
      urlString = path;
    }
    return dio.get<T>(
      urlString,
      queryParameters: {...?queryParameters, "hl": "en"},
      options: Options(
        headers: headers,
      ),
    );
  }

  Future<Response<T>> post<T>(
    String path, {
    Map<String, dynamic>? body,
    Map<String, dynamic>? headers,
  }) {
    return dio.post<T>(
      "$basePath/$path",
      data: body,
      options: Options(
        headers: headers,
      ),
    );
  }
}
