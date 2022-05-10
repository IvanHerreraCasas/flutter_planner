import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_planner/sign_up/sign_up.dart';

class SignUpEmailTextField extends StatelessWidget {
  const SignUpEmailTextField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: TextInputType.emailAddress,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Email',
      ),
      onChanged: (email) => context.read<SignUpBloc>().add(
            SignUpEmailChanged(email),
          ),
    );
  }
}
