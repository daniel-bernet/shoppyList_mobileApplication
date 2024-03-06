import 'package:app/values/app_colors.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String pageTitle;
  final String logoAssetPath; // Path to the logo image asset

  const CustomAppBar({
    super.key,
    required this.pageTitle,
    this.logoAssetPath = 'assets/images/logo.png', // Ensure this path is correct.
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        pageTitle,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(color:AppColors.lightOnPrimaryColor) // Optional specification for visibility.
      ),
      centerTitle: true,
      backgroundColor: Theme.of(context).colorScheme.primary,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Image.asset(logoAssetPath), // Ensure your asset path is correct.
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
