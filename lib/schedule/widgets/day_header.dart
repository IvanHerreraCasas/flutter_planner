import 'package:flutter/material.dart';

class DayHeader extends StatelessWidget {
  const DayHeader({
    Key? key,
    required this.day,
  }) : super(key: key);

  final int day;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    late final String dayString;

    switch (day) {
      case 0:
        dayString = 'Monday';
        break;
      case 1:
        dayString = 'Tuesday';
        break;
      case 2:
        dayString = 'Wednesday';
        break;
      case 3:
        dayString = 'Thursday';
        break;
      case 4:
        dayString = 'Friday';
        break;
      case 5:
        dayString = 'Saturday';
        break;
      case 6:
        dayString = 'Sunday';
        break;
    }
    return Container(
      margin: const EdgeInsets.only(left: 20),
      width: 100,
      height: 30,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(
          color: theme.colorScheme.onBackground,
        ),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        dayString,
        style: Theme.of(context).textTheme.bodyText1,
        overflow: TextOverflow.clip,
      ),
    );
  }
}
