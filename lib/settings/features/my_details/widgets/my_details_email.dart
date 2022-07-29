import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_planner/authentication/authentication.dart';
import 'package:flutter_planner/settings/features/my_details/my_details.dart';

class MyDetailsEmail extends StatefulWidget {
  const MyDetailsEmail({
    Key? key,
    required this.initialEmail,
  }) : super(key: key);

  final String initialEmail;

  @override
  State<MyDetailsEmail> createState() => _MyDetailsEmailState();
}

class _MyDetailsEmailState extends State<MyDetailsEmail> {
  late final TextEditingController controller;
  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.initialEmail);
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
          'Email',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 20),
        TextField(
          controller: controller,
          keyboardType: TextInputType.text,
          enabled: context.read<AuthenticationBloc>().state.user!.isEditable,
          decoration: const InputDecoration(
            hintText: 'email...',
            border: OutlineInputBorder(),
          ),
          onChanged: (value) => context.read<MyDetailsBloc>().add(
                MyDetailsEmailChanged(value),
              ),
          onSubmitted: (_) =>
              context.read<MyDetailsBloc>().add(const MyDetailsEmailSaved()),
        ),
      ],
    );
  }
}
