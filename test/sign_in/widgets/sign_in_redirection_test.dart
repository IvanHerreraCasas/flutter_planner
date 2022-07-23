import 'package:flutter/material.dart';
import 'package:flutter_planner/app/app.dart';
import 'package:flutter_planner/sign_in/sign_in.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

void main() {
  group('SignInRedirection', () {
    late GoRouter goRouter;

    setUp(() {
      goRouter = MockGoRouter();
    });

    Widget buildSubject() {
      return InheritedGoRouter(
        goRouter: goRouter,
        child: const SignInRedirection(),
      );
    }

    testWidgets('renders correct text', (tester) async {
      await tester.pumpApp(buildSubject());

      final richText = tester.widget(find.byType(RichText)) as RichText;

      final textSpan = richText.text as TextSpan;

      final registerTextSpan = textSpan.children![1] as TextSpan;

      expect(registerTextSpan.text, equals('Register'));

      expect(
        find.text(
          "Don't have an account? Register",
          findRichText: true,
        ),
        findsOneWidget,
      );
    });

    testWidgets('goes to SignUpPage when register is pressed', (tester) async {
      await tester.pumpApp(buildSubject());

      fireOnTap(
        find.text(
          "Don't have an account? Register",
          findRichText: true,
        ),
        'Register',
      );

      verify(() => goRouter.goNamed(AppRoutes.signUp)).called(1);
    });
  });
}
