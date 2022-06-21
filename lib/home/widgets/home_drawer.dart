import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_planner/app/app.dart';
import 'package:go_router/go_router.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({Key? key}) : super(key: key);

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
              context
                  .read<AppBloc>()
                  .add(const AppRouteChanged('/home/planner'));
              context.go('/home/planner');
            },
          ),
          ListTile(
            leading: const Icon(Icons.schedule),
            title: const Text('Schedule'),
            onTap: () {
              Navigator.pop(context);
              context
                  .read<AppBloc>()
                  .add(const AppRouteChanged('/home/schedule'));
              context.go('/home/schedule');
            },
          ),
        ],
      ),
    );
  }
}
