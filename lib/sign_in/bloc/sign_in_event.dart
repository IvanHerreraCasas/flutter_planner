part of 'sign_in_bloc.dart';

abstract class SignInEvent extends Equatable {
  const SignInEvent();

  @override
  List<Object?> get props => [];
}

class SignInEmailChanged extends SignInEvent {
  const SignInEmailChanged(this.email);

  final String email;

  @override
  List<Object?> get props => [email];
}

class SignInPasswordChanged extends SignInEvent {
  const SignInPasswordChanged(this.password);

  final String password;

  @override
  List<Object?> get props => [password];
}

class SignInPasswordVisibilityChanged extends SignInEvent {
  // ignore: avoid_positional_boolean_parameters
  const SignInPasswordVisibilityChanged(this.passwordVisibility);

  final bool passwordVisibility;

  @override
  List<Object?> get props => [passwordVisibility];
}

class SignInRequested extends SignInEvent {
  const SignInRequested();
}
