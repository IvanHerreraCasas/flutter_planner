import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_planner/authentication/authentication.dart';
import 'package:flutter_planner/settings/features/my_details/my_details.dart';

class MyDetailsUserName extends StatefulWidget {
  const MyDetailsUserName({
    Key? key,
    required this.initialUserName,
  }) : super(key: key);

  final String initialUserName;

  @override
  State<MyDetailsUserName> createState() => _MyDetailsUserNameState();
}

class _MyDetailsUserNameState extends State<MyDetailsUserName> {
  late final TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.initialUserName);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'User name',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 20),
        TextField(
          controller: controller,
          keyboardType: TextInputType.text,
          enabled: context.read<AuthenticationBloc>().state.user!.isEditable,
          decoration: const InputDecoration(
            hintText: 'user name ...',
            border: OutlineInputBorder(),
          ),
          onChanged: (value) => context.read<MyDetailsBloc>().add(
                MyDetailsUserNameChanged(value),
              ),
          onSubmitted: (_) =>
              context.read<MyDetailsBloc>().add(const MyDetailsUserNameSaved()),
        ),
      ],
    );
  }
}
