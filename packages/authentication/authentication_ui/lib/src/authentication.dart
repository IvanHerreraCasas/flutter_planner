import 'package:authentication_ui/authentication_ui.dart';
import 'package:flutter/material.dart';

/// {@template authentication}
/// Base widget for authentication proccesses.
/// {@endtemplate}
class Authentication extends StatelessWidget {
  /// {@macro authentication}
  const Authentication({
    Key? key,
    this.headerBuilder,
    this.bodyBuilder,
    this.buttonBuilder,
    this.errorBuilder,
    this.helperBuilder,
    this.padding,
    this.backgroundColor = Colors.white,
    this.borderRadius,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.spacing = 15,
    this.maxWidth = 300,
    this.maxHeight = 500,
  }) : super(key: key);

  /// Padding of the widget, default 15
  final EdgeInsetsGeometry? padding;

  /// Color used for the background.
  final Color? backgroundColor;

  /// border radius used in all the components, default circular(15)
  final BorderRadiusGeometry? borderRadius;

  /// Cross axis alignment of the content.
  final CrossAxisAlignment? crossAxisAlignment;

  /// Header builder
  final HeaderBuilder? headerBuilder;

  /// Body builder
  final BodyBuilder? bodyBuilder;

  /// Button builder
  final ButtonBuilder? buttonBuilder;

  /// Error builder
  final ErrorBuilder? errorBuilder;

  /// Helper builder
  final HelperBuilder? helperBuilder;

  /// Spacing between components.
  final double? spacing;

  /// Max width constraint
  final double maxWidth;

  /// Max height constraint
  final double maxHeight;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: maxHeight, maxWidth: maxWidth),
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: borderRadius ?? BorderRadius.circular(15),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) => Padding(
            padding: padding ?? const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (headerBuilder != null) headerBuilder!(context, constraints),
                SizedBox(height: spacing),
                if (errorBuilder != null) errorBuilder!(context, constraints),
                SizedBox(height: spacing),
                if (bodyBuilder != null) bodyBuilder!(context, constraints),
                SizedBox(height: spacing),
                if (buttonBuilder != null) buttonBuilder!(context, constraints),
                SizedBox(height: spacing),
                if (helperBuilder != null) helperBuilder!(context, constraints),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
