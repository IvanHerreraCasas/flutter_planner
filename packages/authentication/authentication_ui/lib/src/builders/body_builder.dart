import 'package:flutter/material.dart';

/// Body builder typedef
typedef BodyBuilder = Widget Function(
  BuildContext context,
  BoxConstraints constraints,
);

///
class AuthenticationSignInBody extends StatelessWidget {
  ///
  const AuthenticationSignInBody({
    Key? key,
    this.emailController,
    this.onChangedEmail,
    this.passwordController,
    this.onChangedPassword,
  }) : super(key: key);

  ///
  final TextEditingController? emailController;

  ///
  final TextEditingController? passwordController;

  ///
  final void Function(String email)? onChangedEmail;

  ///
  final void Function(String password)? onChangedPassword;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        EmailTextField(
          controller: emailController,
          onChanged: onChangedEmail,
        ),
        const SizedBox(height: 10),
        PasswordTextField(
          controller: passwordController,
          onChanged: onChangedPassword,
        ),
      ],
    );
  }
}

///
class AuthenticationSignUpBody extends StatelessWidget {
  ///
  const AuthenticationSignUpBody({
    Key? key,
    this.emailController,
    this.onChangedEmail,
    this.passwordController,
    this.onChangedPassword,
    this.confirmPasswordController,
    this.onChangedConfirmPassword,
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

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        EmailTextField(
          controller: emailController,
          onChanged: onChangedEmail,
        ),
        const SizedBox(height: 10),
        PasswordTextField(
          controller: passwordController,
          onChanged: onChangedPassword,
        ),
        const SizedBox(height: 10),
        PasswordTextField(
          controller: confirmPasswordController,
          onChanged: onChangedConfirmPassword,
          labelText: 'Confirm Password',
        ),
      ],
    );
  }
}

///
class EmailTextField extends StatelessWidget {
  ///
  const EmailTextField({
    Key? key,
    this.controller,
    this.onChanged,
    this.labelText = 'Email',
  }) : super(key: key);

  /// controller for the email
  final TextEditingController? controller;

  /// onChanged function
  final void Function(String email)? onChanged;

  /// labelText, default Email
  final String? labelText;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: labelText,
      ),
      onChanged: onChanged,
    );
  }
}

///
class PasswordTextField extends StatelessWidget {
  ///
  const PasswordTextField({
    Key? key,
    this.controller,
    this.onChanged,
    this.labelText = 'Password',
  }) : super(key: key);

  /// controller for the password
  final TextEditingController? controller;

  /// onChanged function
  final void Function(String email)? onChanged;

  /// labelText, default Password
  final String? labelText;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      enableSuggestions: false,
      obscureText: true,
      obscuringCharacter: '*',
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: labelText,
      ),
      onChanged: onChanged,
    );
  }
}
