import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_planner/sign_up/sign_up.dart';

class SignUpPasswordTextField extends StatelessWidget {
  const SignUpPasswordTextField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final passwordVisibility = context.select(
      (SignUpBloc bloc) => bloc.state.passwordVisibility,
    );

    return TextField(
      enableSuggestions: false,
      obscureText: !passwordVisibility,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: 'Password',
        suffixIcon: IconButton(
          splashRadius: 5,
          icon: Icon(
            passwordVisibility ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: () => context
              .read<SignUpBloc>()
              .add(SignUpPasswordVisibilityChanged(!passwordVisibility)),
        ),
      ),
      onChanged: (password) => context.read<SignUpBloc>().add(
            SignUpPasswordChanged(password),
          ),
    );
  }
}
