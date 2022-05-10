import 'package:authentication_ui/authentication_ui.dart';
import 'package:flutter/material.dart';

/// {@template sign_in}
/// Customazable sign in widget
/// {@endtemplate}
class SignIn extends StatelessWidget {
  /// {@macro sign_in}
  const SignIn({
    Key? key,
    required this.onRequestSignIn,
    this.emailController,
    this.passwordController,
    this.onChangedEmail,
    this.onChangedPassword,
    this.errorBuilder,
    this.onRequestSignUp,
  }) : super(key: key);

  ///
  final TextEditingController? emailController;

  ///
  final TextEditingController? passwordController;

  ///
  final void Function(String email)? onChangedEmail;

  ///
  final void Function(String password)? onChangedPassword;

  ///
  final ErrorBuilder? errorBuilder;

  ///
  final void Function()? onRequestSignUp;

  ///
  final void Function() onRequestSignIn;

  @override
  Widget build(BuildContext context) {
    return Authentication(
      headerBuilder: (context, constraints) => const Text('Sign in'),
      errorBuilder: errorBuilder,
      bodyBuilder: (context, constraints) => AuthenticationSignInBody(
        emailController: emailController,
        passwordController: passwordController,
        onChangedEmail: onChangedEmail,
        onChangedPassword: onChangedPassword,
      ),
      buttonBuilder: (context, constraints) => Center(
        child: AuthenticationButton(
          text: 'Sign In',
          onPressed: onRequestSignIn,
        ),
      ),
      helperBuilder: (context, constraints) => AuthenticationSignInHelper(
        onRequestSignUp: onRequestSignUp,
      ),
    );
  }
}
