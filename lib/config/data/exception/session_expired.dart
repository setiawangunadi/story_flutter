class SessionExpired implements Exception {
  final String message;
  final dynamic statusCode;

  SessionExpired({this.message = '', this.statusCode});

  @override
  String toString() => "message :$message statusCode : $statusCode";
}
