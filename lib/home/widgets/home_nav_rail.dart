import 'package:flutter/material.dart';
import 'package:flutter_planner/home/home.dart';

class HomeNavRail extends StatelessWidget {
  const HomeNavRail({
    Key? key,
    required this.currentSize,
    required this.selectedIndex,
    required this.onDestinationSelected,
  }) : super(key: key);

  final HomeSize currentSize;
  final int selectedIndex;
  final void Function(int index) onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    final extended = currentSize == HomeSize.large;
    return NavigationRail(
      extended: extended,
      labelType: extended
          ? NavigationRailLabelType.none
          : NavigationRailLabelType.selected,
      onDestinationSelected: onDestinationSelected,
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
