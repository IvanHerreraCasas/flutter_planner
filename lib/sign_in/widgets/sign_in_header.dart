import 'package:flutter/material.dart';

class SignInHeader extends StatelessWidget {
  const SignInHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      'Sign in',
      style: Theme.of(context).textTheme.headline5,
    );
  }
}
