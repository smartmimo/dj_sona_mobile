import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:djsona_mobile/cubits/app_state_cubit/app_state_cubit.dart';
import 'package:djsona_mobile/services/service_locator.dart';

class RequestInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    serviceLocator.get<AppStateCubit>().handleNetworkError(err);
  }

  Map<String, dynamic> getResponseBody(dynamic response) {
    if (response.runtimeType == String) {
      return json.decode(response.data);
    } else {
      return response.data;
    }
  }
}
