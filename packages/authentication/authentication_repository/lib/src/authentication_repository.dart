import 'package:authentication_api/authentication_api.dart';

/// {@template authentication_repository}
/// A Very Good Project created by Very Good CLI.
/// {@endtemplate}
class AuthenticationRepository {
  /// {@macro authentication_repository}
  const AuthenticationRepository({
    required AuthenticationApi authenticationApi,
  }) : _authenticationApi = authenticationApi;

  final AuthenticationApi _authenticationApi;

  /// Returns the user data, if there is a logged in user, otherwise null
  User? get user => _authenticationApi.user;

  /// Stream of AuthStatus
  Stream<AuthenticationStatus> get status =>
      _authenticationApi.status.asBroadcastStream();

  /// Creates a new user
  Future<void> signUp({
    required String email,
    required String password,
  }) =>
      _authenticationApi.signUp(email: email, password: password);

  /// Log in an existing user
  Future<void> signIn({
    required String email,
    required String password,
  }) =>
      _authenticationApi.signIn(email: email, password: password);

  /// Changes the name of the current user
  Future<void> changeName({required String name}) =>
      _authenticationApi.changeName(name: name);

  /// Changes the email of the current user
  Future<void> changeEmail({required String email}) =>
      _authenticationApi.changeEmail(email: email);

  /// Signs out the current user, if there is a logged in user.
  Future<void> signOut() => _authenticationApi.signOut();

  /// Dispose the controller if exists one
  void dispose() => _authenticationApi.dispose();
}
