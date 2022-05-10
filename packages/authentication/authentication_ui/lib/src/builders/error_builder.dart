import 'package:flutter/material.dart';

/// Error builder type def
typedef ErrorBuilder = Widget Function(
  BuildContext context,
  BoxConstraints constraints,
);

///
class AuthenticationError extends StatelessWidget {
  ///
  const AuthenticationError({
    Key? key,
    required this.message,
    this.style,
    this.color,
    this.padding,
  }) : super(key: key);

  /// Error's message
  final String message;

  /// Error's text style
  final TextStyle? style;

  /// Error's bacground color, default red.shade100
  final Color? color;

  /// Padding, default 15
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(color: color ?? Colors.red.shade100),
      child: Text(
        message,
        style: style ?? TextStyle(color: color),
      ),
    );
  }
}
