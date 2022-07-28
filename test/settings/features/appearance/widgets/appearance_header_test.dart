import 'package:flutter/material.dart';
import 'package:flutter_planner/settings/features/features.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/helpers.dart';

void main() {
  group('AppearanceHeader', () {
    late GoRouter goRouter;

    setUp(() {
      goRouter = MockGoRouter();
    });

    Widget buildSubject({bool isPage = true}) {
      return InheritedGoRouter(
        goRouter: goRouter,
        child: AppearanceHeader(isPage: isPage),
      );
    }

    testWidgets('renders Appearance title', (tester) async {
      await tester.pumpApp(buildSubject());

      expect(find.text('Appearance'), findsOneWidget);
    });

    group('Leading icon', () {
      testWidgets('is rendered when appearance is a page', (tester) async {
        await tester.pumpApp(buildSubject());

        expect(find.byIcon(Icons.arrow_back), findsOneWidget);
      });

      testWidgets('is not rendered when appearance is not a page',
          (tester) async {
        await tester.pumpApp(buildSubject(isPage: false));

        expect(find.byIcon(Icons.arrow_back), findsNothing);
      });

      testWidgets('pops when is pressed', (tester) async {
        await tester.pumpApp(buildSubject());

        await tester.tap(find.byIcon(Icons.arrow_back));

        verify(() => goRouter.pop()).called(1);
      });
    });
  });
}
