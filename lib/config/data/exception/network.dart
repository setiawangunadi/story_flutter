class Network implements Exception {
  dynamic httpStatus;
  dynamic responseCode;
  dynamic responseMessage;

  Network({
    this.httpStatus = 401,
    this.responseCode = "",
    this.responseMessage = "",
  });

  @override
  String toString() {
    return '{ httpStatus : $httpStatus, responseCode : $responseCode, responseMessage $responseMessage } ';
  }
}
