import 'package:authentication_ui/authentication_ui.dart';
import 'package:flutter/material.dart';

/// {@template sign_up}
/// Customazable sign up widget
/// {@endtemplate}
class SignUp extends StatelessWidget {
  /// {@macro sign_up}
  const SignUp({
    Key? key,
    required this.onRequestSignUp,
    this.emailController,
    this.passwordController,
    this.confirmPasswordController,
    this.onChangedEmail,
    this.onChangedPassword,
    this.onChangedConfirmPassword,
    this.errorBuilder,
    this.onRequestSignIn,
  }) : super(key: key);

  ///
  final TextEditingController? emailController;

  ///
  final TextEditingController? passwordController;

  ///
  final TextEditingController? confirmPasswordController;

  ///
  final void Function(String email)? onChangedEmail;

  ///
  final void Function(String password)? onChangedPassword;

  ///
  final void Function(String confirmPassword)? onChangedConfirmPassword;

  ///
  final ErrorBuilder? errorBuilder;

  ///
  final void Function()? onRequestSignIn;

  ///
  final void Function() onRequestSignUp;

  @override
  Widget build(BuildContext context) {
    return Authentication(
      headerBuilder: (context, constraints) => const Text('Sign up'),
      errorBuilder: errorBuilder,
      bodyBuilder: (context, constraints) => AuthenticationSignUpBody(
        emailController: emailController,
        passwordController: passwordController,
        confirmPasswordController: confirmPasswordController,
        onChangedEmail: onChangedEmail,
        onChangedPassword: onChangedPassword,
        onChangedConfirmPassword: onChangedConfirmPassword,
      ),
      buttonBuilder: (context, constraints) => AuthenticationButton(
        text: 'Register',
        onPressed: onRequestSignUp,
      ),
      helperBuilder: (context, constraints) => AuthenticationSignUpHelper(
        onRequestSignIn: onRequestSignIn,
      ),
    );
  }
}
