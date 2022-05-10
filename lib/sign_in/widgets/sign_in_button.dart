import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_planner/sign_in/sign_in.dart';

class SignInButton extends StatelessWidget {
  const SignInButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final status = context.select((SignInBloc bloc) => bloc.state.status);

    return ElevatedButton(
      onPressed: () => context.read<SignInBloc>().add(const SignInRequested()),
      style: ButtonStyle(
        fixedSize: MaterialStateProperty.resolveWith(
          (states) => const Size.fromWidth(300),
        ),
      ),
      child: status == SignInStatus.loading
          ? CircularProgressIndicator(
              color: theme.colorScheme.onPrimary,
            )
          : Text(
              'Sign in',
              style: theme.textTheme.bodyText1!
                  .copyWith(color: Theme.of(context).colorScheme.onPrimary),
            ),
    );
  }
}
