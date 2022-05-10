import 'package:flutter/material.dart';

class NameTextField extends StatefulWidget {
  const NameTextField({
    Key? key,
    this.initialText = '',
    this.hintText = '',
    this.onChanged,
  }) : super(key: key);

  final String initialText;
  final String hintText;
  final void Function(String)? onChanged;

  @override
  State<NameTextField> createState() => _NameTextFieldState();
}

class _NameTextFieldState extends State<NameTextField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialText);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      style: Theme.of(context).textTheme.headline6,
      decoration: InputDecoration(
        hintText: widget.hintText,
        fillColor: Colors.transparent,
        hoverColor: Colors.transparent,
        border: InputBorder.none,
      ),
      onChanged: widget.onChanged,
    );
  }
}
