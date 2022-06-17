import 'package:flutter/material.dart';
import 'package:flutter_planner/sign_in/sign_in.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/helpers.dart';

void main() {
  group('SignInHeader', () {
    Widget buildSubject() {
      return const SignInHeader();
    }

    testWidgets('renders Sign in text', (tester) async {
      await tester.pumpApp(buildSubject());

      expect(find.text('Sign in'), findsOneWidget);
    });
  });
}
