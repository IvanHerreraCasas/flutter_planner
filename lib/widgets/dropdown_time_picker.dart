import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

class DropdownTimePicker extends StatelessWidget {
  const DropdownTimePicker({
    Key? key,
    required this.time,
    required this.enableHour,
    required this.enableMinute,
    required this.onChanged,
    required this.title,
  }) : super(key: key);

  final DateTime time;
  final bool Function(int hour) enableHour;
  final bool Function(int minute) enableMinute;

  final void Function(DateTime dateTime) onChanged;

  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.bodyText1,
        ),
        const SizedBox(width: 20),
        const Spacer(),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Hour
            DropdownButton2<int>(
              value: time.hour,
              dropdownWidth: 60,
              onChanged: (value) {
                if (value != null) {
                  onChanged(
                    DateTime(
                      time.year,
                      time.month,
                      time.day,
                      value,
                      time.minute,
                      time.second,
                      time.millisecond,
                      time.microsecond,
                    ),
                  );
                }
              },
              items: List.generate(
                25,
                (index) => DropdownMenuItem(
                  value: index,
                  enabled: enableHour(index),
                  child: Text(index.toString()),
                ),
              ),
              dropdownMaxHeight: 200,
            ),
            const SizedBox(width: 10),
            // Minute
            DropdownButton2<int>(
              value: (time.minute ~/ 10) * 10,
              dropdownWidth: 60,
              onChanged: (value) {
                if (value != null) {
                  onChanged(
                    DateTime(
                      time.year,
                      time.month,
                      time.day,
                      time.hour,
                      value,
                      time.second,
                      time.millisecond,
                      time.microsecond,
                    ),
                  );
                }
              },
              items: List.generate(
                7,
                (index) => DropdownMenuItem(
                  value: index * 10,
                  enabled: enableMinute(index * 10),
                  child: Text((index * 10).toString()),
                ),
              ),
              dropdownMaxHeight: 200,
            ),
          ],
        )
      ],
    );
  }
}
