part of 'authentication_bloc.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

class AuthenticationSubscriptionRequested extends AuthenticationEvent {
  const AuthenticationSubscriptionRequested();
}

class AuthenticationSignoutRequested extends AuthenticationEvent {
  const AuthenticationSignoutRequested();
}
