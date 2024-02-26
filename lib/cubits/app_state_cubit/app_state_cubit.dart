import 'package:djsona_mobile/cubits/app_state_cubit/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';

class AppStateCubit extends Cubit<AppState> {
  AppStateCubit() : super(AppState());

  void handleNetworkError(DioException error) {
    emit(state.copyWith(
      error: () => RequestErrorObject(
        message: error.message,
        urlAndMethod: "[${error.requestOptions.method.toUpperCase()}] ${error.requestOptions.uri}",
        params: error.requestOptions.data,
        response: error.response?.data,
        type: error.type,
      ),
    ));
  }

  void reset() {
    emit(state.copyWith(error: () => null));
  }

  void updateColors({required Color primary, required Color secondary}) {
    emit(state.copyWith(primaryColor: primary, secondaryColor: secondary));
  }
}
