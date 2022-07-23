import 'package:flutter/material.dart';
import 'package:flutter_planner/app/app.dart';
import 'package:flutter_planner/sign_up/sign_up.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

void main() {
  group('SignUpRedirection', () {
    late GoRouter goRouter;

    setUp(() {
      goRouter = MockGoRouter();
    });

    Widget buildSubject() {
      return InheritedGoRouter(
        goRouter: goRouter,
        child: const SignUpRedirection(),
      );
    }

    testWidgets('renders correct text', (tester) async {
      await tester.pumpApp(buildSubject());

      expect(
        find.text(
          'Already have an account? Login',
          findRichText: true,
        ),
        findsOneWidget,
      );
    });

    testWidgets('goes to SignInPage when Login is pressed', (tester) async {
      await tester.pumpApp(buildSubject());

      fireOnTap(
        find.text(
          'Already have an account? Login',
          findRichText: true,
        ),
        'Login',
      );

      verify(() => goRouter.goNamed(AppRoutes.signIn)).called(1);
    });
  });
}
