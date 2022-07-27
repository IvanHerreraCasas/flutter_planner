import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_planner/settings/settings.dart';

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
      (SettingsBloc bloc) => bloc.state.selectedIndex,
    );

    final textTheme = Theme.of(context).textTheme;

    if (widget.currentSize == SettingsSize.small) {
      return ListView(
        controller: _scrollController,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'My details',
                  style: textTheme.titleLarge,
                ),
                const SizedBox(
                  height: 500,
                  child: Center(
                    child: Text('My details content'),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Appearance',
                  style: textTheme.titleLarge,
                ),
                const SizedBox(
                  height: 500,
                  child: Center(
                    child: Text('Appearance content'),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () => context.read<SettingsBloc>().add(
                const SettingsSelectedIndexChanged(0),
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
          onTap: () => context.read<SettingsBloc>().add(
                const SettingsSelectedIndexChanged(1),
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
