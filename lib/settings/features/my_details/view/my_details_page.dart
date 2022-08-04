import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_planner/authentication/authentication.dart';
import 'package:flutter_planner/settings/features/my_details/my_details.dart';

class MyDetailsPage extends StatelessWidget {
  const MyDetailsPage({
    Key? key,
    required this.isPage,
  }) : super(key: key);

  final bool isPage;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MyDetailsBloc(
        user: context.read<AuthenticationBloc>().state.user!,
        authenticationRepository: context.read<AuthenticationRepository>(),
      ),
      child: MyDetailsView(
        isPage: isPage,
      ),
    );
  }
}

class MyDetailsView extends StatelessWidget {
  const MyDetailsView({Key? key, required this.isPage}) : super(key: key);

  final bool isPage;

  @override
  Widget build(BuildContext context) {
    return BlocListener<MyDetailsBloc, MyDetailsState>(
      listenWhen: (previous, current) =>
          previous.status != current.status ||
          previous.errorMessage != current.errorMessage,
      listener: (context, state) {
        switch (state.status) {
          case MyDetailsStatus.initial:
            break;
          case MyDetailsStatus.loading:
            break;
          case MyDetailsStatus.failure:
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage),
                behavior: SnackBarBehavior.floating,
                margin: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
              ),
            );
            break;
          case MyDetailsStatus.success:
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('details changed'),
                behavior: SnackBarBehavior.floating,
                margin: EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
              ),
            );
            break;
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          minimum: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 30,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MyDetailsHeader(
                isPage: isPage,
              ),
              const SizedBox(height: 40),
              Expanded(
                child: ListView(
                  children: [
                    MyDetailsUserName(
                      initialUserName:
                          context.read<AuthenticationBloc>().state.user!.name ??
                              '',
                    ),
                    const SizedBox(height: 30),
                    MyDetailsEmail(
                      initialEmail: context
                              .read<AuthenticationBloc>()
                              .state
                              .user!
                              .email ??
                          '',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
