abstract class Failure {
  final String message;

  Failure(this.message);

  @override
  String toString() => message;
}

class NetworkFailure extends Failure {
  NetworkFailure(String message) : super('Network Error: $message');
}

class ServerFailure extends Failure {
  final int? statusCode;

  ServerFailure(String message, {this.statusCode}) : super('Server Error: $message');
}

class CacheFailure extends Failure {
  CacheFailure(String message) : super('Cache Error: $message');
}

class AuthenticationFailure extends Failure {
  AuthenticationFailure(String message) : super('Authentication Error: $message');
}

class ValidationFailure extends Failure {
  ValidationFailure(String message) : super('Validation Error: $message');
}

class NotFoundFailure extends Failure {
  NotFoundFailure(String message) : super('Not Found: $message');
}

class UnknownFailure extends Failure {
  UnknownFailure(String message) : super('Unknown Error: $message');
}
