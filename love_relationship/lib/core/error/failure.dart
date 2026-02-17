abstract class Failure {
  final String? message;

  Failure({this.message});
}

enum ServerErrorType {
  unknown,
  createUserError,
  updateUserError,
  network,
  timeout,
}

enum AuthErrorType {
  unknown,
  userNotFound,
  invalidCredentials,
  invalidEmail,
  wrongPassword,
  unauthenticated,
  emailAlreadyInUse,
  emailConfirmationRequired,
  invalidConfirmationCode,
}

class ServerFailure extends Failure {
  final ServerErrorType? type;
  ServerFailure(this.type, {super.message});
}

class AuthFailure extends Failure {
  final AuthErrorType? type;
  AuthFailure(this.type, {super.message});
}
