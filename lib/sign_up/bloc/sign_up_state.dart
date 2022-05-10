part of 'sign_up_bloc.dart';

enum SignUpStatus { initial, loading, success, failure }

class SignUpState extends Equatable {
  const SignUpState({
    this.status = SignUpStatus.initial,
    this.email = '',
    this.password = '',
    this.passwordVisibility = false,
    this.errorMessage,
  });

  final SignUpStatus status;
  final String email;
  final String password;
  final bool passwordVisibility;
  final String? errorMessage;

  SignUpState copyWith({
    SignUpStatus? status,
    String? email,
    String? password,
    bool? passwordVisibility,
    String? errorMessage,
  }) {
    return SignUpState(
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
