import 'package:flutter/material.dart';

typedef SignInWidgetBuilder = Widget Function();

class SignInLayoutBuilder extends StatelessWidget {
  const SignInLayoutBuilder({
    Key? key,
    required this.header,
    required this.error,
    required this.emailTextField,
    required this.passwordTextField,
    required this.button,
    required this.redirection,
  }) : super(key: key);

  final SignInWidgetBuilder header;
  final SignInWidgetBuilder error;
  final SignInWidgetBuilder emailTextField;
  final SignInWidgetBuilder passwordTextField;
  final SignInWidgetBuilder button;
  final SignInWidgetBuilder redirection;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 300,
            maxHeight: 500,
          ),
          child: Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                header(),
                const SizedBox(height: 20),
                error(),
                const SizedBox(height: 20),
                emailTextField(),
                const SizedBox(height: 10),
                passwordTextField(),
                const SizedBox(height: 20),
                button(),
                const SizedBox(height: 20),
                redirection(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
