import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_planner/sign_in/sign_in.dart';
import 'package:go_router/go_router.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({Key? key}) : super(key: key);

  static GoRoute route() {
    return GoRoute(
      path: '/sign-in',
      builder: (context, state) => BlocProvider(
        create: (context) => SignInBloc(
          authenticationRepository: context.read<AuthenticationRepository>(),
        ),
        child: const SignInPage(),
      ),
    );
  }

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
