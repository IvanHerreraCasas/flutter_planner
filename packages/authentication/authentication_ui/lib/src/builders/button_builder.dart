import 'package:flutter/material.dart';

/// Button builder typedef
typedef ButtonBuilder = Widget Function(
  BuildContext context,
  BoxConstraints constraints,
);

///
class AuthenticationButton extends StatelessWidget {
  ///
  const AuthenticationButton({
    Key? key,
    required this.text,
    this.width = 300,
    required this.onPressed,
  }) : super(key: key);

  /// Text of the button
  final String text;

  /// width
  final double width;

  ///
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          backgroundColor: MaterialStateColor.resolveWith(
            (states) => Colors.blue,
          ),
          fixedSize: MaterialStateProperty.resolveWith(
            (states) => Size.fromWidth(width),
          ),
        ),
        child: Text(
          text,
        ),
      ),
    );
  }
}
