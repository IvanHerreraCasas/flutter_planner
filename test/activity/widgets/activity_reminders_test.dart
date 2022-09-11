import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_planner/activity/activity.dart';
import 'package:flutter_planner/reminders/reminders.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:reminders_repository/reminders_repository.dart';

import '../../helpers/helpers.dart';
import '../activity_mocks.dart';

void main() {
  group('ActivityReminders', () {
    late ActivityBloc activityBloc;
    late RemindersRepository remindersRepository;

    setUp(() {
      activityBloc = MockActivityBloc();
      remindersRepository = MockRemindersRepository();

      when(() => activityBloc.state).thenReturn(mockActivityState);
      when(() => remindersRepository.areAllowed).thenReturn(true);
    });

    Widget buildSubject({
      ActivitySize currentSize = ActivitySize.small,
    }) {
      return BlocProvider.value(
        value: activityBloc,
        child: ActivityReminders(currentSize: currentSize),
      );
    }

    testWidgets('when reminders are not allowed not show reminders',
        (tester) async {
      when(() => remindersRepository.areAllowed).thenReturn(false);
      await tester.pumpApp(
        buildSubject(),
        remindersRepository: remindersRepository,
      );

      expect(find.text('Reminders: '), findsNothing);
    });

    testWidgets('when reminderValues are empty not show reminders',
        (tester) async {
      await tester.pumpApp(
        buildSubject(),
        remindersRepository: remindersRepository,
      );

      expect(find.text('Reminders: '), findsNothing);
    });

    group('when reminder are allowed and have values', () {
      final reminderValues = List.generate(20, (index) => index.isEven);
      setUp(() {
        when(() => activityBloc.state).thenReturn(
          mockActivityState.copyWith(reminderValues: reminderValues),
        );
      });

      testWidgets('renders Reminders text', (tester) async {
        await tester.pumpApp(
          buildSubject(),
          remindersRepository: remindersRepository,
        );

        expect(find.text('Reminders: '), findsOneWidget);
      });

      testWidgets('renders number of active reminders', (tester) async {
        await tester.pumpApp(
          buildSubject(),
          remindersRepository: remindersRepository,
        );

        expect(find.text('10'), findsOneWidget);
      });

      testWidgets(
          'renders notification_active icon '
          'when it number of active reminders is greater than 0',
          (tester) async {
        await tester.pumpApp(
          buildSubject(),
          remindersRepository: remindersRepository,
        );
        expect(find.byIcon(Icons.notifications_active), findsOneWidget);
      });

      testWidgets(
          'renders notification_none icon '
          'when it doesnt have active reminders', (tester) async {
        when(() => activityBloc.state).thenReturn(
          mockActivityState.copyWith(
            reminderValues: List.generate(20, (index) => false),
          ),
        );
        await tester.pumpApp(
          buildSubject(),
          remindersRepository: remindersRepository,
        );
        expect(find.byIcon(Icons.notifications_none), findsOneWidget);
      });

      testWidgets('shows remindersPage when is pressed', (tester) async {
        await tester.pumpApp(
          buildSubject(),
          remindersRepository: remindersRepository,
        );

        await tester.tap(find.text('Reminders: '));

        await tester.pumpAndSettle();

        expect(find.byType(RemindersPage), findsOneWidget);
      });
    });
  });
}
