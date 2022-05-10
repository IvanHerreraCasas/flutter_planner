part of 'sign_in_bloc.dart';

enum SignInStatus { initial, loading, success, failure }

class SignInState extends Equatable {
  const SignInState({
    this.status = SignInStatus.initial,
    this.email = '',
    this.password = '',
    this.passwordVisibility = false,
    this.errorMessage,
  });

  final SignInStatus status;
  final String email;
  final String password;
  final bool passwordVisibility;
  final String? errorMessage;

  SignInState copyWith({
    SignInStatus? status,
    String? email,
    String? password,
    bool? passwordVisibility,
    String? errorMessage,
  }) {
    return SignInState(
      status: status ?? this.status,
      email: email ?? this.email,
      password: password ?? this.password,
      passwordVisibility: passwordVisibility ?? this.passwordVisibility,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        email,
        password,
        passwordVisibility,
        errorMessage,
      ];
}
