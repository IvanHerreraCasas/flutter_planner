import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_planner/app/app.dart';
import 'package:flutter_planner/settings/settings.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/helpers.dart';

void main() {
  late AppBloc appBloc;

  setUp(() {
    appBloc = MockAppBloc();

    when(() => appBloc.state).thenReturn(const AppState());
  });
  group('SettingsRemindersPage', () {
    Widget buildSubject({bool isPage = true}) {
      return BlocProvider.value(
        value: appBloc,
        child: SettingsRemindersPage(
          isPage: isPage,
        ),
      );
    }

    testWidgets('renders SettingsRemindersView', (tester) async {
      await tester.pumpApp(buildSubject());

      expect(find.byType(SettingsRemindersView), findsOneWidget);
    });
  });

  group('SettingsRemindersView', () {
    Widget buildSubject({bool isPage = true}) {
      return BlocProvider.value(
        value: appBloc,
        child: SettingsRemindersView(isPage: isPage),
      );
    }

    testWidgets('renders correct widgets', (tester) async {
      await tester.pumpApp(buildSubject());

      expect(find.byType(SettingsRemindersHeader), findsOneWidget);
      expect(find.byType(SettingsRemindersTasks), findsOneWidget);
    });
  });
}
