class RequestErrorObject {
  String? message;
  String urlAndMethod;
  Object? params;
  Object? response;
  dynamic type;
  RequestErrorObject({this.message, required this.urlAndMethod, this.params, this.type, this.response});
}
