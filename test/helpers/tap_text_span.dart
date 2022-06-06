import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';

/// Runs the onTap handler for the [TextSpan] which matches the search-string.
void fireOnTap(Finder finder, String text) {
  final element = finder.evaluate().single;
  final paragraph = element.renderObject! as RenderParagraph;
  // The children are the individual TextSpans which have GestureRecognizers
  paragraph.text.visitChildren((InlineSpan span) {
    final textSpan = span as TextSpan;
    if (textSpan.toPlainText() != text) return true; // continue iterating.

    (textSpan.recognizer! as TapGestureRecognizer).onTap!();
    return false; // stop iterating, we found the one.
  });
}
