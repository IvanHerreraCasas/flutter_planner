import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_planner/app/app.dart';
import 'package:go_router/go_router.dart';

class SignUpRedirection extends StatelessWidget {
  const SignUpRedirection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: 'Already have an account? ',
            style: Theme.of(context).textTheme.bodyText2,
          ),
          TextSpan(
            text: 'Login',
            style: const TextStyle(
              color: Colors.blue,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () => context.goNamed(AppRoutes.signIn),
          )
        ],
      ),
    );
  }
}
