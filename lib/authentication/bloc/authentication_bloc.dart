import 'dart:async';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc({
    required AuthenticationRepository authenticationRepository,
  })  : _authenticationRepository = authenticationRepository,
        super(
          authenticationRepository.user == null
              ? const AuthenticationState.unknown()
              : AuthenticationState.authenticated(
                  authenticationRepository.user!,
                ),
        ) {
    on<AuthenticationSignoutRequested>(_onAuthenticationSignoutRequested);
    on<AuthenticationSubscriptionRequested>(
      _onAuthenticationSubscriptionRequested,
    );
  }

  final AuthenticationRepository _authenticationRepository;

  @override
  Future<void> close() {
    _authenticationRepository.dispose();
    return super.close();
  }

  Future<void> _onAuthenticationSubscriptionRequested(
    AuthenticationSubscriptionRequested event,
    Emitter<AuthenticationState> emit,
  ) async {
    await emit.forEach<AuthenticationStatus>(
      _authenticationRepository.status,
      onData: (status) {
        switch (status) {
          case AuthenticationStatus.authenticated:
            final user = _authenticationRepository.user;
            return user != null
                ? AuthenticationState.authenticated(user)
                : const AuthenticationState.unauthenticated();
          case AuthenticationStatus.unauthenticated:
            return const AuthenticationState.unauthenticated();
          case AuthenticationStatus.unknown:
            return const AuthenticationState.unknown();
        }
      },
    );
  }

  void _onAuthenticationSignoutRequested(
    AuthenticationSignoutRequested event,
    Emitter<AuthenticationState> emit,
  ) {
    _authenticationRepository.signOut();
  }
}
