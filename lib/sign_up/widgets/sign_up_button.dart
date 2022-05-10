import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_planner/sign_up/sign_up.dart';

class SignUpButton extends StatelessWidget {
  const SignUpButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final status = context.select((SignUpBloc bloc) => bloc.state.status);
    return ElevatedButton(
      onPressed: () => context.read<SignUpBloc>().add(const SignUpRequested()),
      style: ButtonStyle(
        fixedSize: MaterialStateProperty.resolveWith(
          (states) => const Size.fromWidth(300),
        ),
      ),
      child: status == SignUpStatus.loading
          ? CircularProgressIndicator(
              color: theme.colorScheme.onPrimary,
            )
          : Text(
              'Sign up',
              style: theme.textTheme.bodyText1!
                  .copyWith(color: Theme.of(context).colorScheme.onPrimary),
            ),
    );
  }
}
