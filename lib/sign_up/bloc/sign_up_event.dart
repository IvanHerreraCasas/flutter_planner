part of 'sign_up_bloc.dart';

abstract class SignUpEvent extends Equatable {
  const SignUpEvent();

  @override
  List<Object?> get props => [];
}

class SignUpEmailChanged extends SignUpEvent {
  const SignUpEmailChanged(this.email);

  final String email;

  @override
  List<Object?> get props => [email];
}

class SignUpPasswordChanged extends SignUpEvent {
  const SignUpPasswordChanged(this.password);

  final String password;

  @override
  List<Object?> get props => [password];
}

class SignUpPasswordVisibilityChanged extends SignUpEvent {
  // ignore: avoid_positional_boolean_parameters
  const SignUpPasswordVisibilityChanged(this.passwordVisibility);

  final bool passwordVisibility;

  @override
  List<Object?> get props => [passwordVisibility];
}

class SignUpRequested extends SignUpEvent {
  const SignUpRequested();
}
