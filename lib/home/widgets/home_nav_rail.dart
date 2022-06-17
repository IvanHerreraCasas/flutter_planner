import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_planner/app/app.dart';
import 'package:flutter_planner/home/home.dart';
import 'package:go_router/go_router.dart';

class HomeNavRail extends StatelessWidget {
  const HomeNavRail({
    Key? key,
    required this.currentSize,
    required this.selectedIndex,
  }) : super(key: key);

  final HomeSize currentSize;
  final int selectedIndex;

  void _onDestinationSelected(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.read<AppBloc>().add(const AppRouteChanged('/home/planner'));
        context.go('/home/planner');
        break;
      case 1:
        context.read<AppBloc>().add(const AppRouteChanged('/home/schedule'));
        context.go('/home/schedule');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final extended = currentSize == HomeSize.large;
    return NavigationRail(
      extended: extended,
      labelType: extended
          ? NavigationRailLabelType.none
          : NavigationRailLabelType.selected,
      onDestinationSelected: (index) => _onDestinationSelected(context, index),
      destinations: const [
        NavigationRailDestination(
          icon: Icon(Icons.calendar_today),
          label: Text('Planner'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.schedule),
          label: Text('Schedule'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.checklist),
          label: Text('Projects'),
        ),
      ],
      selectedIndex: selectedIndex,
    );
  }
}
