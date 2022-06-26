import 'package:flutter/material.dart';
import 'package:flutter_planner/home/home.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    Key? key,
    this.index = 0,
    this.homeViewKey,
  }) : super(key: key);

  final int index;
  final Key? homeViewKey;

  @override
  Widget build(BuildContext context) {
    return HomeLayoutBuilder(
      appBar: AppBar(),
      drawer: (_) => const HomeDrawer(),
      body: (_) => HomeBody(index: index),
      navRail: (currentSize) => HomeNavRail(
        currentSize: currentSize,
        selectedIndex: index,
      ),
    );
  }
}
