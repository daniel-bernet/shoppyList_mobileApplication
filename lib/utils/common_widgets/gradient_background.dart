import 'package:flutter/material.dart';
import '../../values/app_colors.dart';
import '../extensions.dart';

class GradientBackground extends StatelessWidget {
  final List<Widget> children;

  const GradientBackground({
    required this.children,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    final colors = isDarkTheme ? AppColors.darkGradient : AppColors.lightGradient;

    return DecoratedBox(
      decoration: BoxDecoration(gradient: LinearGradient(colors: colors)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: context.heightFraction(sizeFraction: 0.1)),
            ...children,
          ],
        ),
      ),
    );
  }
}
