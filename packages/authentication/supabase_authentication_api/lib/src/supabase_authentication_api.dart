import 'dart:async';
import 'package:authentication_api/authentication_api.dart';
import 'package:supabase/supabase.dart' as sb;

/// {@template api}
/// A Very Good Project created by Very Good CLI.
/// {@endtemplate}
class SupabaseAuthenticationApi extends AuthenticationApi {
  /// {@macro api}
  SupabaseAuthenticationApi({
    required sb.SupabaseClient supabaseClient,
  }) : _supabaseClient = supabaseClient;

  final sb.SupabaseClient _supabaseClient;

  final _statusStreamController = StreamController<AuthenticationStatus>();

  @override
  User? get user {
    final sbUser = _supabaseClient.auth.user();

    if (sbUser == null) return null;
    return User(
      id: sbUser.id,
      email: sbUser.email,
      name: sbUser.userMetadata['name'] as String?,
    );
  }

  @override
  Stream<AuthenticationStatus> get status async* {
    if (user == null) {
      yield AuthenticationStatus.unauthenticated;
    } else {
      yield AuthenticationStatus.authenticated;
    }
    yield* _statusStreamController.stream;
  }

  @override
  Future<void> signUp({
    required String email,
    required String password,
  }) async {
    final res = await _supabaseClient.auth.signUp(email, password);

    if (res.error != null) {
      throw AuthenticationFailure(message: res.error!.message);
    } else {
      _statusStreamController.add(AuthenticationStatus.authenticated);
    }
  }

  @override
  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    final res = await _supabaseClient.auth.signIn(
      email: email,
      password: password,
    );

    if (res.error != null) {
      throw AuthenticationFailure(message: res.error!.message);
    } else {
      _statusStreamController.add(AuthenticationStatus.authenticated);
    }
  }

  @override
  Future<void> signOut() async {
    final res = await _supabaseClient.auth.signOut();
    if (res.error != null) {
      throw AuthenticationFailure(message: res.error!.message);
    } else {
      _statusStreamController.add(AuthenticationStatus.unauthenticated);
    }
  }

  @override
  Future<void> changeName({required String name}) async {
    final res = await _supabaseClient.auth.update(
      sb.UserAttributes(
        data: {'name': name},
      ),
    );

    if (res.error != null) {
      throw Exception(res.error!.message);
    }
  }

  @override
  Future<void> changeEmail({required String email}) async {
    final res = await _supabaseClient.auth.update(
      sb.UserAttributes(email: email),
    );

    if (res.error != null) {
      throw Exception(res.error!.message);
    }
  }

  @override
  void dispose() => _statusStreamController.close();
}
