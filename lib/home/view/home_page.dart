import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_planner/activity/activity.dart';
import 'package:flutter_planner/app/app.dart';
import 'package:flutter_planner/home/home.dart';
import 'package:flutter_planner/routine/routine.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    Key? key,
    this.index = 0,
    this.homeViewKey,
  }) : super(key: key);

  static GoRoute route() {
    return GoRoute(
      path: '/home/:page',
      builder: (context, state) {
        var index = 0;
        switch (state.params['page']) {
          case 'planner':
            index = 0;
            break;
          case 'schedule':
            index = 1;
            break;
        }
        return HomePage(homeViewKey: state.pageKey, index: index);
      },
      routes: [
        ActivityPage.route(),
        RoutinePage.route(),
      ],
    );
  }

  final int index;
  final Key? homeViewKey;

  void _navigate(BuildContext context, int index) {
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
    return HomeLayoutBuilder(
      appBar: AppBar(),
      drawer: (_) => HomeDrawer(
        onDestinationSelected: (index) => _navigate(context, index),
      ),
      body: (_) => HomeBody(index: index),
      navRail: (currentSize) => HomeNavRail(
        currentSize: currentSize,
        selectedIndex: index,
        onDestinationSelected: (index) => _navigate(context, index),
      ),
    );
  }
}
