import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_planner/app/app.dart';
import 'package:flutter_planner/settings/settings.dart';
import 'package:go_router/go_router.dart';

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

    if (widget.currentSize == SettingsSize.small) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () => context.goNamed(
              AppRoutes.myDetails,
              params: {'page': 'settings'},
            ),
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
            onTap: () {},
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
      ],
    );
  }
}