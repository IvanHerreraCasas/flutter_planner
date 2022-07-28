import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_planner/app/app.dart';

class AppearanceTheme extends StatelessWidget {
  const AppearanceTheme({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final themeModeIndex = context.select(
      (AppBloc bloc) => bloc.state.themeModeIndex,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Theme',
          style: textTheme.titleLarge,
        ),
        const SizedBox(height: 20),
        RadioListTile<int>(
          value: 0,
          groupValue: themeModeIndex,
          onChanged: (value) {
            context.read<AppBloc>().add(AppThemeModeChanged(value ?? 0));
          },
          title: Text(
            'System',
            style: textTheme.titleMedium,
          ),
        ),
        RadioListTile<int>(
          value: 1,
          groupValue: themeModeIndex,
          onChanged: (value) {
            context.read<AppBloc>().add(AppThemeModeChanged(value ?? 1));
          },
          title: Text(
            'Light',
            style: textTheme.titleMedium,
          ),
        ),
        RadioListTile<int>(
          value: 2,
          groupValue: themeModeIndex,
          onChanged: (value) {
            context.read<AppBloc>().add(AppThemeModeChanged(value ?? 2));
          },
          title: Text(
            'Dark',
            style: textTheme.titleMedium,
          ),
        ),
      ],
    );
  }
}
