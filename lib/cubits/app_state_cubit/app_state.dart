abstract class AppState {}

class AppStateInitial extends AppState {}

class AppStateError extends AppState {
  final RequestErrorObject error;
  AppStateError(this.error);
}

class RequestErrorObject {
  String? message;
  String urlAndMethod;
  Object? params;
  Object? response;
  dynamic type;
  RequestErrorObject({this.message, required this.urlAndMethod, this.params, this.type, this.response});
}
