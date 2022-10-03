import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_planner/app/app.dart';
import 'package:flutter_planner/settings/settings.dart';

class SettingsBody extends StatelessWidget {
  const SettingsBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final selectedIndex = context.select(
      (AppBloc bloc) => bloc.state.settingsIndex,
    );

    return IndexedStack(
      index: selectedIndex,
      children: const [
        MyDetailsPage(
          isPage: false,
        ),
        AppearancePage(
          isPage: false,
        ),
        SettingsRemindersPage(
          isPage: false,
        ),
      ],
    );
  }
}
