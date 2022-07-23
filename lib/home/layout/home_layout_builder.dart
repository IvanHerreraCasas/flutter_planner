import 'package:flutter/material.dart';
import 'package:flutter_planner/home/home.dart';

enum HomeSize { small, medium, large }

typedef HomeWidgetBuilder = Widget Function(HomeSize currentSize);

class HomeLayoutBuilder extends StatelessWidget {
  const HomeLayoutBuilder({
    Key? key,
    required this.appBar,
    required this.drawer,
    required this.body,
    required this.navRail,
  }) : super(key: key);

  final PreferredSizeWidget? appBar;
  final HomeWidgetBuilder drawer;
  final HomeWidgetBuilder body;
  final HomeWidgetBuilder navRail;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        late final HomeSize currentSize;

        if (constraints.maxWidth <= HomeBreakpoints.small) {
          currentSize = HomeSize.small;
          return Scaffold(
            appBar: appBar,
            drawer: drawer(currentSize),

            // to have the same widget tree and avoid
            // unnessary rebuilds on resize
            // Scaffold -> Row -> Expanded -> body
            body: Row(
              children: [
                Expanded(
                  child: body(currentSize),
                ),
              ],
            ),
          );
        } else if (constraints.maxWidth <= HomeBreakpoints.medium) {
          currentSize = HomeSize.medium;

          return Scaffold(
            body: Row(
              children: [
                navRail(currentSize),
                const VerticalDivider(thickness: 2),
                Expanded(
                  child: body(currentSize),
                ),
              ],
            ),
          );
        }
        currentSize = HomeSize.large;

        return Scaffold(
          body: Row(
            children: [
              navRail(currentSize),
              const VerticalDivider(thickness: 2),
              Expanded(
                child: body(currentSize),
              ),
            ],
          ),
        );
      },
    );
  }
}
