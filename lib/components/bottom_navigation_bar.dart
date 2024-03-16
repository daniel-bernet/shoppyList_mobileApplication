import 'package:app/l10n/app_localization.dart';
import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onIndexSelected;

  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onIndexSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appLocalizations = AppLocalizations.of(context);
    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: const Icon(Icons.shopping_cart),
          label: appLocalizations.translate('shoppingPage'),
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.add_box),
          label: appLocalizations.translate('addItemPage'),
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.view_list),
          label: appLocalizations.translate('viewListPage'),
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.list),
          label: appLocalizations.translate('myListsPage'),
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.person),
          label: appLocalizations.translate('userPage'),
        ),
      ],
      currentIndex: currentIndex,
      selectedItemColor: theme.colorScheme.primary,
      unselectedItemColor: theme.colorScheme.onSurface.withOpacity(0.6),
      onTap: onIndexSelected,
    );
  }
}

