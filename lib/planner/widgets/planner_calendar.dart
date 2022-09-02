import 'package:activities_repository/activities_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_planner/planner/planner.dart';
import 'package:table_calendar/table_calendar.dart';

class PlannerCalendar extends StatelessWidget {
  const PlannerCalendar({
    Key? key,
    required this.currentSize,
  }) : super(key: key);

  final PlannerSize currentSize;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    late bool formatButtonVisible;

    if (currentSize == PlannerSize.large) {
      formatButtonVisible = false;
    } else {
      formatButtonVisible = true;
    }

    final calendarFormat = currentSize == PlannerSize.large
        ? CalendarFormat.month
        : CalendarFormat.week;

    final selectedDay = context.select(
      (PlannerBloc bloc) => bloc.state.selectedDay,
    );

    final focusedDay = context.select(
      (PlannerBloc bloc) => bloc.state.focusedDay,
    );

    final events = context.select((PlannerBloc bloc) => bloc.state.events);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(15),
      ),
      child: TableCalendar<Object?>(
        rowHeight: 40,
        startingDayOfWeek: StartingDayOfWeek.monday,
        headerStyle: HeaderStyle(
          formatButtonVisible: formatButtonVisible,
        ),
        calendarFormat: calendarFormat,
        calendarStyle: CalendarStyle(
          todayTextStyle: Theme.of(context)
              .textTheme
              .bodyText2!
              .copyWith(color: Theme.of(context).colorScheme.onPrimary),
          todayDecoration: BoxDecoration(
            color: Theme.of(context).primaryColorLight,
            shape: BoxShape.circle,
          ),
          selectedTextStyle: Theme.of(context)
              .textTheme
              .bodyText2!
              .copyWith(color: Theme.of(context).colorScheme.onPrimary),
          selectedDecoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            shape: BoxShape.circle,
          ),
        ),
        firstDay: DateTime.now().subtract(
          const Duration(days: 365 * 2),
        ),
        lastDay: DateTime.now().add(const Duration(days: 365 * 2)),
        focusedDay: focusedDay,
        eventLoader: (day) => _filterEvents(day: day, events: events),
        selectedDayPredicate: (day) => isSameDay(
          day,
          selectedDay,
        ),
        onDaySelected: (selectedDay, focusedDay) => context.read<PlannerBloc>()
          ..add(PlannerSelectedDayChanged(selectedDay))
          ..add(PlannerFocusedDayChanged(focusedDay)),
        onPageChanged: (focusedDay) => context
            .read<PlannerBloc>()
            .add(PlannerFocusedDayChanged(focusedDay)),
      ),
    );
  }

  List<Object> _filterEvents({
    required DateTime day,
    required List<Activity> events,
  }) {
    final _events = List.of(events)..retainWhere((event) => event.date == day);

    return _events;
  }
}
