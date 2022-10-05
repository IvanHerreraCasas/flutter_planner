import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_planner/activity/activity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';
import '../activity_mocks.dart';

void main() {
  group('ActivityDescriptionTextField', () {
    late ActivityBloc activityBloc;

    setUp(() {
      activityBloc = MockActivityBloc();

      when(() => activityBloc.state).thenReturn(mockActivityState);
    });

    Widget buildSubject({
      ActivitySize currentSize = ActivitySize.large,
    }) {
      return BlocProvider.value(
        value: activityBloc,
        child: ActivityDescriptionTextField(
          currentSize: currentSize,
        ),
      );
    }

    testWidgets('renders TextField with correct description', (tester) async {
      await tester.pumpApp(buildSubject());

      expect(find.byType(TextField), findsOneWidget);
      expect(find.text(mockActivityState.description), findsOneWidget);
    });

    testWidgets(
        'adds ActivityDescriptionChanged '
        'to ActivityBloc '
        'when a new value is entered', (tester) async {
      await tester.pumpApp(buildSubject());

      const newDescription = 'new description';

      await tester.enterText(find.byType(TextField), newDescription);

      verify(
        () =>
            activityBloc.add(const ActivityDescriptionChanged(newDescription)),
      ).called(1);
    });
  });
}
