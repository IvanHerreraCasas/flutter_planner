import 'package:authentication_api/authentication_api.dart';

/// {@template isar_authentication_api}
/// A Very Good Project created by Very Good CLI.
/// {@endtemplate}
class IsarAuthenticationApi extends AuthenticationApi {
  /// {@macro isar_authentication_api}
  const IsarAuthenticationApi();

  @override
  Stream<AuthenticationStatus> get status =>
      Stream.value(AuthenticationStatus.authenticated);

  @override
  User? get user => const User(
        id: 'id',
        name: 'local-user',
        email: 'loca-user@example.com',
        isEditable: false,
      );

  @override
  Future<void> signIn({required String email, required String password}) async {
    throw UnimplementedError();
  }

  @override
  Future<void> signOut() {
    throw UnimplementedError();
  }

  @override
  Future<void> signUp({required String email, required String password}) {
    throw UnimplementedError();
  }

  @override
  Future<void> changeName({required String name}) async {}

  @override
  Future<void> changeEmail({required String email}) async {}

  @override
  void dispose() {}
}
