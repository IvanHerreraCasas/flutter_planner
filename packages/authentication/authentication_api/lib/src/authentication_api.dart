import 'package:authentication_api/authentication_api.dart';

/// {@template authentication_api}
/// A Very Good Project created by Very Good CLI.
/// {@endtemplate}
abstract class AuthenticationApi {
  /// {@macro authentication_api}
  const AuthenticationApi();

  /// Returns the user data, if there is a logged in user, otherwise null
  User? get user;

  /// Stream of AuthStatus
  Stream<AuthenticationStatus> get status;

  /// Creates a new user
  Future<void> signUp({
    required String email,
    required String password,
  });

  /// Log in an existing user
  Future<void> signIn({
    required String email,
    required String password,
  });

  /// Changes the name of the current user
  Future<void> changeName({required String name});

  /// Changes the email of the current user
  Future<void> changeEmail({required String email});

  /// Signs out the current user, if there is a logged in user.
  Future<void> signOut();

  /// Dispose the controller if exists one
  void dispose();
}
