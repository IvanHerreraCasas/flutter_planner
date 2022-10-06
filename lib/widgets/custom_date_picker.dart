import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomDatePicker extends StatelessWidget {
  const CustomDatePicker({
    Key? key,
    required this.date,
    required this.onChangeDate,
    this.enabled = true,
  }) : super(key: key);

  final DateTime date;
  final void Function(DateTime selectedDate) onChangeDate;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    const fiveYearsDuration = Duration(days: 365 * 5);

    return Row(
      children: [
        Expanded(
          child: Text(
            'Date: ',
            style: Theme.of(context).textTheme.bodyText1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 20),
        ElevatedButton(
          style: ButtonStyle(
            foregroundColor: MaterialStateColor.resolveWith((states) {
              if (states.contains(MaterialState.disabled)) {
                return Colors.grey;
              }
              return Theme.of(context).colorScheme.onPrimary;
            }),
            textStyle: MaterialStateProperty.resolveWith<TextStyle?>(
              (states) {
                if (states.contains(MaterialState.disabled)) {
                  return Theme.of(context).textTheme.bodyText1;
                } else {
                  return Theme.of(context).primaryTextTheme.bodyText1;
                }
              },
            ),
          ),
          onPressed: enabled
              ? () async {
                  final selectedDate = await showDatePicker(
                    context: context,
                    initialDate: date,
                    firstDate: DateTime.now().subtract(fiveYearsDuration),
                    lastDate: DateTime.now().add(fiveYearsDuration),
                  );
                  if (selectedDate != null) {
                    onChangeDate(selectedDate);
                  }
                }
              : null,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.event,
              ),
              const SizedBox(width: 10),
              Text(
                DateFormat('MM-dd-yyyy').format(date),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
