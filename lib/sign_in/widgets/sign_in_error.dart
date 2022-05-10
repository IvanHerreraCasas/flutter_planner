import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_planner/sign_in/sign_in.dart';

class SignInError extends StatelessWidget {
  const SignInError({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final status = context.select((SignInBloc bloc) => bloc.state.status);

    final errorMessage = context.select(
      (SignInBloc bloc) => bloc.state.errorMessage,
    );

    return status == SignInStatus.failure
        ? Container(
            padding: const EdgeInsets.all(10),
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: theme.colorScheme.errorContainer,
            ),
            child: Text(
              errorMessage ?? 'Authentication error',
              style: theme.textTheme.bodyText2!
                  .copyWith(color: theme.colorScheme.onErrorContainer),
            ),
          )
        : const SizedBox();
  }
}
