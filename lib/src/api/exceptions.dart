class NetworkError implements Exception {
  final String message;

  NetworkError(this.message);
}

class ServerError implements Exception {
  final String message;

  ServerError(this.message);
}
