import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_planner/sign_up/sign_up.dart';
import 'package:go_router/go_router.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({Key? key}) : super(key: key);

  static GoRoute route() {
    return GoRoute(
      path: '/sign-up',
      builder: (context, state) => BlocProvider(
        create: (context) => SignUpBloc(
          authenticationRepository: context.read<AuthenticationRepository>(),
        ),
        child: const SignUpPage(),
      ),
    );
  }

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
