import 'dart:ui';

import 'package:djsona_mobile/constants/color_constants.dart';
import 'package:flutter/foundation.dart';

class AppState {
  final RequestErrorObject? error;
  final Color primaryColor;
  final Color secondaryColor;
  AppState({
    this.error,
    this.primaryColor = ColorConstants.primary,
    this.secondaryColor = ColorConstants.secondary,
  });

  AppState copyWith({
    ValueGetter<RequestErrorObject?>? error,
    Color? primaryColor,
    Color? secondaryColor,
  }) {
    return AppState(
      error: error != null ? error() : this.error,
      primaryColor: primaryColor ?? this.primaryColor,
      secondaryColor: secondaryColor ?? this.secondaryColor,
    );
  }
}

class RequestErrorObject {
  String? message;
  String urlAndMethod;
  Object? params;
  Object? response;
  dynamic type;
  RequestErrorObject({this.message, required this.urlAndMethod, this.params, this.type, this.response});
}
