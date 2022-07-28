import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_planner/settings/settings.dart';

class SettingsBody extends StatelessWidget {
  const SettingsBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final selectedIndex = context.select(
      (SettingsBloc bloc) => bloc.state.selectedIndex,
    );

    return IndexedStack(
      index: selectedIndex,
      children: const [
        Center(
          child: MyDetailsPage(
            isPage: false,
          ),
        ),
        Center(
          child: Text('Appearance page'),
        ),
      ],
    );
  }
}
