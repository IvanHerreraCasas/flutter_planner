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

  @override
  Widget build(BuildContext context) {
    final selectedIndex = context.select(
      (AppBloc bloc) => bloc.state.settingsIndex,
    );

    final textTheme = Theme.of(context).textTheme;
    
    final areRemindersAllowed = context.watch<RemindersRepository>().areAllowed;

    if (widget.currentSize == SettingsSize.small) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              context.read<AppBloc>().add(
                    const AppRouteChanged('/home/settings/my-details'),
                  );
              context.goNamed(
                AppRoutes.myDetails,
                params: {'page': 'settings'},
              );
            },
            borderRadius: BorderRadius.circular(10),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 20,
                horizontal: 10,
              ),
              child: Row(
                children: [
                  Text(
                    'My details',
                    style: textTheme.titleMedium,
                  ),
                  const Spacer(),
                  const Icon(Icons.arrow_forward_ios)
                ],
              ),
            ),
          ),
          const Divider(),
          InkWell(
            onTap: () {
              context.read<AppBloc>().add(
                    const AppRouteChanged('/home/settings/appearance'),
                  );
              context.goNamed(
                AppRoutes.appearance,
                params: {'page': 'settings'},
              );
            },
            borderRadius: BorderRadius.circular(10),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 20,
                horizontal: 10,
              ),
              child: Row(
                children: [
                  Text(
                    'Appearance',
                    style: textTheme.titleMedium,
                  ),
                  const Spacer(),
                  const Icon(Icons.arrow_forward_ios)
                ],
              ),
            ),
          ),
          const Divider(),
          if (areRemindersAllowed)
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    context.read<AppBloc>().add(
                          const AppRouteChanged('/home/settings/reminders'),
                        );
                    context.goNamed(
                      AppRoutes.settingsReminders,
                      params: {'page': 'settings'},
                    );
                  },
                  borderRadius: BorderRadius.circular(10),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 10,
                    ),
                    child: Row(
                      children: [
                        Text(
                          'Reminders',
                          style: textTheme.titleMedium,
                        ),
                        const Spacer(),
                        const Icon(Icons.arrow_forward_ios)
                      ],
                    ),
                  ),
                ),
              ],
            ),
          const Spacer(),
          ElevatedButton(
            onPressed: context.read<AuthenticationBloc>().state.user!.isEditable
                ? () => context.read<AuthenticationBloc>().add(
                      const AuthenticationSignoutRequested(),
                    )
                : null,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 36),
            ),
            child: const Text('Log out'),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () => context.read<AppBloc>().add(
                const AppSettingsIndexChanged(0),
              ),
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 10,
            ),
            width: double.infinity,
            decoration: BoxDecoration(
              color:
                  selectedIndex == 0 ? Theme.of(context).highlightColor : null,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              'My details',
              style: textTheme.titleMedium,
            ),
          ),
        ),
        const SizedBox(height: 5),
        InkWell(
          onTap: () => context.read<AppBloc>().add(
                const AppSettingsIndexChanged(1),
              ),
          borderRadius: BorderRadius.circular(10),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 10,
            ),
            decoration: BoxDecoration(
              color:
                  selectedIndex == 1 ? Theme.of(context).highlightColor : null,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              'Appearance',
              style: textTheme.titleMedium,
            ),
          ),
        ),
        const SizedBox(height: 5),
        if (areRemindersAllowed)
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () => context.read<AppBloc>().add(
                      const AppSettingsIndexChanged(2),
                    ),
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: selectedIndex == 2
                        ? Theme.of(context).highlightColor
                        : null,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    'Reminders',
                    style: textTheme.titleMedium,
                  ),
                ),
              ),
            ],
          ),
        const Spacer(),
        ElevatedButton(
          onPressed: context.read<AuthenticationBloc>().state.user!.isEditable
              ? () => context.read<AuthenticationBloc>().add(
                    const AuthenticationSignoutRequested(),
                  )
              : null,
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 45),
          ),
          child: const Text('Log out'),
        ),
      ],
    );
  }
}
