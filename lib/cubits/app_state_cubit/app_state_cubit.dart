import 'package:djsona_mobile/cubits/app_state_cubit/app_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';

class AppStateCubit extends Cubit<AppState> {
  AppStateCubit() : super(AppStateInitial());

  void initialize() {
    emit(AppStateInitial());
  }

  void handleNetworkError(DioException error) {
    emit(AppStateError(
      RequestErrorObject(
        message: error.message,
        urlAndMethod: "[${error.requestOptions.method.toUpperCase()}] ${error.requestOptions.uri}",
        params: error.requestOptions.data,
        response: error.response?.data,
        type: error.type,
      ),
    ));
  }
}
