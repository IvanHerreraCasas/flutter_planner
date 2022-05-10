import 'package:flutter/cupertino.dart';

/// Header builder typedef
typedef HeaderBuilder = Widget Function(
  BuildContext context,
  BoxConstraints constraints,
);

///
class AuthenticationHeader extends StatelessWidget {
  ///
  const AuthenticationHeader({Key? key, required this.title, this.titleStyle})
      : super(key: key);

  /// Title of the header
  final String title;

  /// Text style of the title
  final TextStyle? titleStyle;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: titleStyle,
    );
  }
}
