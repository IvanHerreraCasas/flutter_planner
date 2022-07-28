import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_planner/authentication/authentication.dart';
import 'package:flutter_planner/settings/features/my_details/my_details.dart';
import 'package:go_router/go_router.dart';

class MyDetailsHeader extends StatelessWidget {
  const MyDetailsHeader({
    Key? key,
    required this.isPage,
  }) : super(key: key);

  final bool isPage;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (isPage)
          IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(Icons.arrow_back),
          ),
        Text(
          'My details',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const Spacer(),
        ElevatedButton(
          onPressed: context.watch<AuthenticationBloc>().state.user!.isEditable
              ? () => context.read<MyDetailsBloc>().add(const MyDetailsSaved())
              : null,
          child: const Text('Save'),
        ),
      ],
    );
  }
}
