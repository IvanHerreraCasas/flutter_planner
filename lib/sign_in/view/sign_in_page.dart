import 'package:flutter/material.dart';
import 'package:flutter_planner/sign_in/sign_in.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SignInLayoutBuilder(
      header: SignInHeader.new,
      error: SignInError.new,
      emailTextField: SignInEmailTextField.new,
      passwordTextField: SignInPasswordTextField.new,
      button: SignInButton.new,
      redirection: SignInRedirection.new,
    );
  }
}
