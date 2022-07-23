import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_planner/app/app.dart';
import 'package:go_router/go_router.dart';

class SignInRedirection extends StatelessWidget {
  const SignInRedirection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: "Don't have an account? ",
            style: Theme.of(context).textTheme.bodyText2,
          ),
          TextSpan(
            text: 'Register',
            style: const TextStyle(
              color: Colors.blue,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () => context.goNamed(AppRoutes.signUp),
          )
        ],
      ),
    );
  }
}
