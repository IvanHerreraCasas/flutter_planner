import 'package:flutter/material.dart';
import 'package:flutter_planner/sign_up/sign_up.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SignUpLayoutBuilder(
      header: SignUpHeader.new,
      error: SignUpError.new,
      emailTextField: SignUpEmailTextField.new,
      passwordTextField: SignUpPasswordTextField.new,
      button: SignUpButton.new,
      redirection: SignUpRedirection.new,
    );
  }
}
