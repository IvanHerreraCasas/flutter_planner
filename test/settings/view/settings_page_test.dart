import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_planner/settings/settings.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

void main() {
  group('SettingsPage', () {
    Widget buildSubject() {
      return const SettingsPage();
    }

    testWidgets('renders SettingsView', (tester) async {
      await tester.pumpApp(buildSubject());

      expect(find.byType(SettingsView), findsOneWidget);
    });
  });
  group('SettingsView', () {
    late SettingsBloc settingsBloc;

    setUp(() {
      settingsBloc = MockSettingsBloc();

      when(() => settingsBloc.state).thenReturn(const SettingsState());
    });

    Widget buildSubject() {
      return BlocProvider.value(
        value: settingsBloc,
        child: const SettingsView(),
      );
    }

    group('SettingsLayoutBuilder', () {
      final optionFinder = find.byType(SettingsOptions);
      final bodyFinder = find.byType(SettingsBody);

      testWidgets('is rendered', (tester) async {
        await tester.pumpApp(buildSubject());

        expect(find.byType(SettingsLayoutBuilder), findsOneWidget);
      });

      testWidgets(
          'renders correct small size widgets '
          'when width is less or equal than 576', (tester) async {
        await tester.binding.setSurfaceSize(const Size(576, 600));

        await tester.pumpApp(buildSubject());

        final options = tester.widget<SettingsOptions>(optionFinder);

        expect(options.currentSize, SettingsSize.small);
      });

      testWidgets(
          'render correct large size widgets '
          'when width is greater than 576', (tester) async {
        await tester.binding.setSurfaceSize(const Size(800, 600));

        await tester.pumpApp(buildSubject());

        final options = tester.widget<SettingsOptions>(optionFinder);

        expect(options.currentSize, SettingsSize.large);
        expect(bodyFinder, findsOneWidget);
      });
    });
  });
}
