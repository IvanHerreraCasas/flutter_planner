import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppearanceHeader extends StatelessWidget {
  const AppearanceHeader({Key? key, required this.isPage}) : super(key: key);

  final bool isPage;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (isPage)
          IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(Icons.arrow_back),
          ),
        Expanded(
          child: Text(
            'Appearance',
            style: Theme.of(context).textTheme.titleLarge,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
