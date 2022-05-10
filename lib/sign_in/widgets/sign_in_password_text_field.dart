import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_planner/sign_in/sign_in.dart';

class SignInPasswordTextField extends StatelessWidget {
  const SignInPasswordTextField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final passwordVisibility = context.select(
      (SignInBloc bloc) => bloc.state.passwordVisibility,
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
              .read<SignInBloc>()
              .add(SignInPasswordVisibilityChanged(!passwordVisibility)),
        ),
      ),
      onChanged: (password) => context.read<SignInBloc>().add(
            SignInPasswordChanged(password),
          ),
    );
  }
}
