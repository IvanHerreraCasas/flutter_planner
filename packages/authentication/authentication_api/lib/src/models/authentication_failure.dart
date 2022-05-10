/// {@template authentication_failure}
/// Thrown if during the sign in/up process a failure occurs.
/// {@endtemplate}
class AuthenticationFailure implements Exception {
  /// {@macro authentication_failure}
  const AuthenticationFailure({
    this.message = 'An unknown exception occurred.',
  });

  /// The associated error message.
  final String message;
}
