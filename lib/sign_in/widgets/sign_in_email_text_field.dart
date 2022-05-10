import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_planner/sign_in/sign_in.dart';

class SignInEmailTextField extends StatelessWidget {
  const SignInEmailTextField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: TextInputType.emailAddress,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Email',
      ),
      onChanged: (email) => context.read<SignInBloc>().add(
            SignInEmailChanged(email),
          ),
    );
  }
}
