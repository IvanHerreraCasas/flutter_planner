import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_planner/app/app.dart';
import 'package:flutter_planner/settings/settings.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/helpers.dart';

void main() {
  group('AppearanceTimeline', () {
    late AppBloc appBloc;

    setUp(() {
      appBloc = MockAppBloc();

      when(() => appBloc.state).thenReturn(const AppState());
    });

    Widget buildSubject() {
      return BlocProvider.value(
        value: appBloc,
        child: const AppearanceTimeline(),
      );
    }

    testWidgets('renders Timeline title', (tester) async {
      await tester.pumpApp(buildSubject());

      expect(find.text('Timeline'), findsOneWidget);
    });

    group('Start time', () {
      const key = Key('start time hour');
      testWidgets('is rendered with correct start hour', (tester) async {
        await tester.pumpApp(buildSubject());

        final starTimeDropdown = tester.widget<DropdownButton2<int>>(
          find.byKey(key),
        );

        expect(find.text('Start time: '), findsOneWidget);
        expect(starTimeDropdown.value, equals(7));
      });

      testWidgets(
          'adds AppTimelineStartHourChanged to AppBloc '
          'when a new hour is selected', (tester) async {
        await tester.pumpApp(buildSubject());

        await tester.tap(
          find.descendant(
            of: find.byKey(key),
            matching: find.text('7 h').hitTestable(),
          ),
        );

        await tester.pump();

        final newHourFinder = find.text('8 h').hitTestable();

        await tester.ensureVisible(newHourFinder);

        await tester.pumpAndSettle();

        await tester.tap(newHourFinder);

        await tester.pump();

        verify(
          () => appBloc.add(const AppTimelineStartHourChanged(8)),
        ).called(1);
      });
    });

    group('End time', () {
      const key = Key('end time hour');
      testWidgets('is rendered with correct end hour', (tester) async {
        await tester.pumpApp(buildSubject());

        final starTimeDropdown = tester.widget<DropdownButton2<int>>(
          find.byKey(key),
        );

        expect(find.text('End time: '), findsOneWidget);
        expect(starTimeDropdown.value, equals(22));
      });

      testWidgets(
          'adds AppTimelineStartHourChanged to AppBloc '
          'when a new hour is selected', (tester) async {
        await tester.pumpApp(buildSubject());

        await tester.tap(
          find.descendant(
            of: find.byKey(key),
            matching: find.text('22 h').hitTestable(),
          ),
        );

        await tester.pump();

        final newHourFinder = find.text('21 h').hitTestable();

        await tester.ensureVisible(newHourFinder);

        await tester.pumpAndSettle();

        await tester.tap(newHourFinder);

        await tester.pump();

        verify(
          () => appBloc.add(const AppTimelineEndHourChanged(21)),
        ).called(1);
      });
    });
  });
}
