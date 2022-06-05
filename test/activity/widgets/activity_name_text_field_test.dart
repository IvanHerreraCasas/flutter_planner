import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_planner/activity/activity.dart';
import 'package:flutter_planner/widgets/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';
import '../activity_mocks.dart';

void main() {
  group('ActivityNameTextField', () {
    late ActivityBloc activityBloc;

    setUp(() {
      activityBloc = MockActivityBloc();

      when(() => activityBloc.state).thenReturn(mockActivityState);
    });

    Widget buildSubject() {
      return BlocProvider.value(
        value: activityBloc,
        child: const ActivityNameTextField(),
      );
    }

    testWidgets('renders NameTextField with correct name', (tester) async {
      await tester.pumpApp(buildSubject());

      expect(find.byType(NameTextField), findsOneWidget);
      expect(find.text(mockActivityState.name), findsOneWidget);
    });

    testWidgets(
        'add ActivityNameChanged '
        'to ActivityBloc '
        'when a new value is entered', (tester) async {
      await tester.pumpApp(buildSubject());

      const newName = 'new name';

      await tester.enterText(find.byType(NameTextField), newName);

      verify(() => activityBloc.add(const ActivityNameChanged(newName)))
          .called(1);
    });
  });
}
