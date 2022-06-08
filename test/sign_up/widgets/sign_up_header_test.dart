import 'package:flutter/material.dart';
import 'package:flutter_planner/sign_up/sign_up.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/helpers.dart';

void main() {
  group('SignUpHeader', () {
    Widget buildSubject() {
      return const SignUpHeader();
    }

    testWidgets('renders SignUp text', (tester) async {
      await tester.pumpApp(buildSubject());

      expect(find.text('Sign up'), findsOneWidget);
    });
  });
}
