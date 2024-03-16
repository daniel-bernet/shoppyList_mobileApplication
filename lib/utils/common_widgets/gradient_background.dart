import 'package:flutter/material.dart';

class GradientBackground extends StatelessWidget {
  final List<Widget> children;

  const GradientBackground({
    required this.children,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;

    return DecoratedBox(
      decoration: BoxDecoration(color: color),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.1),
            ...children,
          ],
        ),
      ),
    );
  }
}
