import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_planner/app/app.dart';
import 'package:flutter_planner/authentication/bloc/authentication_bloc.dart';
import 'package:flutter_planner/settings/settings.dart';
import 'package:go_router/go_router.dart';
import 'package:reminders_repository/reminders_repository.dart';

class SettingsOptions extends StatefulWidget {
  const SettingsOptions({
    Key? key,
    required this.currentSize,
  }) : super(key: key);

  final SettingsSize currentSize;

  @override
  State<SettingsOptions> createState() => _SettingsOptionsState();
}

class _SettingsOptionsState extends State<SettingsOptions> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onTapOption({
    required BuildContext context,
    required int index,
    required bool isLarge,
  }) {
    if (isLarge) {
      context.read<AppBloc>().add(AppSettingsIndexChanged(index));
    } else {
      late String name;
      switch (index) {
        case 0:
          name = AppRoutes.myDetails;
          break;
        case 1:
          name = AppRoutes.appearance;
          break;
        case 2:
          name = AppRoutes.settingsReminders;
          break;
        default:
          break;
      }

      final route = context.namedLocation(
        name,
        params: {'page': 'settings'},
      );

      context.read<AppBloc>().add(
            AppRouteChanged(route),
          );
      context.go(route);
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = context.select(
      (AppBloc bloc) => bloc.state.settingsIndex,
    );

    final areRemindersAllowed = context.watch<RemindersRepository>().areAllowed;

    if (widget.currentSize == SettingsSize.small) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SmallSettingOption(
            onTap: () =>
                _onTapOption(context: context, index: 0, isLarge: false),
            title: 'My details',
          ),
          const Divider(),
          SmallSettingOption(
            onTap: () =>
                _onTapOption(context: context, index: 1, isLarge: false),
            title: 'Appearance',
          ),
          const Divider(),
          if (areRemindersAllowed)
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SmallSettingOption(
                  onTap: () =>
                      _onTapOption(context: context, index: 2, isLarge: false),
                  title: 'Reminders',
                ),
              ],
            ),
          const Spacer(),
          const LogOutButton(),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LargeSettingOption(
          onTap: () => _onTapOption(context: context, index: 0, isLarge: true),
          title: 'My details',
          isSelected: selectedIndex == 0,
        ),
        const SizedBox(height: 5),
        LargeSettingOption(
          onTap: () => _onTapOption(context: context, index: 1, isLarge: true),
          title: 'Appearance',
          isSelected: selectedIndex == 1,
        ),
        const SizedBox(height: 5),
        if (areRemindersAllowed)
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LargeSettingOption(
                onTap: () =>
                    _onTapOption(context: context, index: 2, isLarge: true),
                title: 'Reminders',
                isSelected: selectedIndex == 2,
              ),
            ],
          ),
        const Spacer(),
        const LogOutButton(),
      ],
    );
  }
}

class SmallSettingOption extends StatelessWidget {
  const SmallSettingOption({
    Key? key,
    required this.onTap,
    required this.title,
  }) : super(key: key);

  final void Function() onTap;

  final String title;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 10,
        ),
        child: Row(
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios)
          ],
        ),
      ),
    );
  }
}

class LargeSettingOption extends StatelessWidget {
  const LargeSettingOption({
    Key? key,
    required this.onTap,
    required this.title,
    required this.isSelected,
  }) : super(key: key);

  final void Function() onTap;

  final bool isSelected;

  final String title;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 10,
        ),
        width: double.infinity,
        decoration: BoxDecoration(
          color: isSelected ? Theme.of(context).highlightColor : null,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          title,
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
    );
  }
}

class LogOutButton extends StatelessWidget {
  const LogOutButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: context.read<AuthenticationBloc>().state.user!.isEditable
          ? () => context.read<AuthenticationBloc>().add(
                const AuthenticationSignoutRequested(),
              )
          : null,
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 36),
      ),
      child: const Text('Log out'),
    );
  }
}
