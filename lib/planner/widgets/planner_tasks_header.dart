import 'package:flutter/material.dart';

class PlannerTasksHeader extends StatelessWidget {
  const PlannerTasksHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          'Tasks',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const Spacer(),
        ElevatedButton(
          onPressed: () {},
          child: Text(
            '+ new',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
      ],
    );
  }
}
