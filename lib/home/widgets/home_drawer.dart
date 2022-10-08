import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_planner/app/app.dart';
import 'package:go_router/go_router.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({Key? key}) : super(key: key);

  void _onTap({
    required BuildContext context,
    required String page,
  }) {
    Navigator.pop(context);
    final route = context.namedLocation(
      AppRoutes.home,
      params: {'page': page},
    );

    context.read<AppBloc>().add(AppRouteChanged(route));
    context.go(route);
  }

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
              onTap: () => _onTap(context: context, page: 'planner'),
            ),
            ListTile(
              leading: const Icon(Icons.schedule),
              title: const Text('Schedule'),
              onTap: () => _onTap(context: context, page: 'schedule'),
            ),
            const Spacer(),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () => _onTap(context: context, page: 'settings'),
            ),
          ],
        ),
      ),
    );
  }
}
