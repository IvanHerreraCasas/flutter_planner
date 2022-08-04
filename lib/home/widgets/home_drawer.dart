import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_planner/app/app.dart';
import 'package:go_router/go_router.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        minimum: const EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 10,
        ),
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: const Text('Planner'),
              onTap: () {
                Navigator.pop(context);
                context
                    .read<AppBloc>()
                    .add(const AppRouteChanged('/home/planner'));
                context.goNamed(
                  AppRoutes.home,
                  params: {'page': 'planner'},
                );
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
                context.goNamed(
                  AppRoutes.home,
                  params: {'page': 'schedule'},
                );
              },
            ),
            const Spacer(),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(context);
                context
                    .read<AppBloc>()
                    .add(const AppRouteChanged('/home/settings'));
                context.goNamed(
                  AppRoutes.home,
                  params: {'page': 'settings'},
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
