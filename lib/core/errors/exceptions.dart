abstract class AppException implements Exception {
  final String message;

  AppException(this.message);

  @override
  String toString() => message;
}

class NetworkException extends AppException {
  NetworkException(String message) : super('Network Error: $message');
}

class ServerException extends AppException {
  final int? statusCode;

  ServerException(String message, {this.statusCode}) : super('Server Error: $message');
}

class CacheException extends AppException {
  CacheException(String message) : super('Cache Error: $message');
}

class AuthenticationException extends AppException {
  AuthenticationException(String message) : super('Authentication Error: $message');
}

class ValidationException extends AppException {
  ValidationException(String message) : super('Validation Error: $message');
}

class NotFoundException extends AppException {
  NotFoundException(String message) : super('Not Found: $message');
}
