import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// Helper builder typedef
typedef HelperBuilder = Widget Function(
  BuildContext context,
  BoxConstraints constraints,
);

///
class AuthenticationSignInHelper extends StatelessWidget {
  ///
  const AuthenticationSignInHelper({
    Key? key,
    this.style,
    this.onRequestSignUp,
  }) : super(key: key);

  ///
  final TextStyle? style;

  ///
  final void Function()? onRequestSignUp;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: "Don't have an account? ",
            style: style ?? const TextStyle(color: Colors.black),
          ),
          TextSpan(
            text: 'Register',
            style: const TextStyle(
              color: Colors.blue,
            ),
            recognizer: TapGestureRecognizer()..onTap = onRequestSignUp,
          )
        ],
      ),
    );
  }
}

///
class AuthenticationSignUpHelper extends StatelessWidget {
  ///
  const AuthenticationSignUpHelper({
    Key? key,
    this.style,
    this.onRequestSignIn,
  }) : super(key: key);

  ///
  final TextStyle? style;

  ///
  final void Function()? onRequestSignIn;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: 'Already have an account? ',
            style: style ?? const TextStyle(color: Colors.black),
          ),
          TextSpan(
            text: 'Sign in',
            style: const TextStyle(
              color: Colors.blue,
            ),
            recognizer: TapGestureRecognizer()..onTap = onRequestSignIn,
          )
        ],
      ),
    );
  }
}
