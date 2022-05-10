import 'package:flutter/material.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({
    Key? key,
    required this.onDestinationSelected,
  }) : super(key: key);

  final void Function(int index) onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.calendar_today),
            title: const Text('Planner'),
            onTap: () {
              Navigator.pop(context);
              onDestinationSelected(0);
            },
          ),
          ListTile(
            leading: const Icon(Icons.schedule),
            title: const Text('Schedule'),
            onTap: () {
              Navigator.pop(context);
              onDestinationSelected(1);
            },
          ),
          ListTile(
            leading: const Icon(Icons.checklist),
            title: const Text('Projects'),
            onTap: () {
              Navigator.pop(context);
              onDestinationSelected(2);
            },
          ),
        ],
      ),
    );
  }
}
