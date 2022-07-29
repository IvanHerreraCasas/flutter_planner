import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_planner/app/app.dart';
import 'package:flutter_planner/settings/settings.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/helpers.dart';

void main() {
  group('ApperanceTheme', () {
    late AppBloc appBloc;

    setUp(() {
      appBloc = MockAppBloc();

      when(() => appBloc.state).thenReturn(const AppState());
    });

    Widget buildSubject() {
      return BlocProvider.value(
        value: appBloc,
        child: const AppearanceTheme(),
      );
    }

    testWidgets('renders Theme title', (tester) async {
      await tester.pumpApp(buildSubject());

      expect(find.text('Theme'), findsOneWidget);
    });

    group('System radio listTile', () {
      testWidgets('is rendered', (tester) async {
        await tester.pumpApp(buildSubject());

        expect(
          find.widgetWithText(RadioListTile<int>, 'System'),
          findsOneWidget,
        );
      });

      testWidgets(
          'adds AppThemeModeChanged(0) to AppBloc '
          'when is pressed', (tester) async {
        when(() => appBloc.state).thenReturn(const AppState(themeModeIndex: 1));
        await tester.pumpApp(buildSubject());

        await tester.tap(find.widgetWithText(RadioListTile<int>, 'System'));

        verify(
          () => appBloc.add(const AppThemeModeChanged(0)),
        ).called(1);
      });
    });

    group('Light radio listTile', () {
      testWidgets('is rendered', (tester) async {
        await tester.pumpApp(buildSubject());

        expect(
          find.widgetWithText(RadioListTile<int>, 'Light'),
          findsOneWidget,
        );
      });

      testWidgets(
          'adds AppThemeModeChanged(1) to AppBloc '
          'when is pressed', (tester) async {
        await tester.pumpApp(buildSubject());

        await tester.tap(find.widgetWithText(RadioListTile<int>, 'Light'));

        verify(
          () => appBloc.add(const AppThemeModeChanged(1)),
        ).called(1);
      });
    });

    group('Dark radio listTile', () {
      testWidgets('is rendered', (tester) async {
        await tester.pumpApp(buildSubject());

        expect(
          find.widgetWithText(RadioListTile<int>, 'Dark'),
          findsOneWidget,
        );
      });

      testWidgets(
          'adds AppThemeModeChanged(2) to AppBloc '
          'when is pressed', (tester) async {
        await tester.pumpApp(buildSubject());

        await tester.tap(find.widgetWithText(RadioListTile<int>, 'Dark'));

        verify(
          () => appBloc.add(const AppThemeModeChanged(2)),
        ).called(1);
      });
    });
  });
}
