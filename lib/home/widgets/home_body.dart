import 'package:flutter/material.dart';
import 'package:flutter_planner/planner/planner.dart';
import 'package:flutter_planner/schedule/schedule.dart';
import 'package:flutter_planner/settings/settings.dart';

class HomeBody extends StatefulWidget {
  const HomeBody({
    Key? key,
    required this.index,
  }) : super(key: key);

  final int index;

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  late int _index;

  final _pages = const <Widget>[
    PlannerPage(),
    SchedulePage(),
    SettingsPage(),
  ];

  @override
  void initState() {
    super.initState();
    _index = widget.index;
  }

  @override
  void didUpdateWidget(covariant HomeBody oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {
      _index = widget.index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return IndexedStack(
      index: _index,
      children: _pages,
    );
  }
}
