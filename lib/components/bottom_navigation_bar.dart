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
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart),
          label: 'Shopping',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add_box),
          label: 'Add Item',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.view_list),
          label: 'View List',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.list),
          label: 'My Lists',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'User',
        ),
      ],
      currentIndex: currentIndex,
      selectedItemColor: theme.colorScheme.primary,
      unselectedItemColor: theme.colorScheme.onSurface.withOpacity(0.6),
      onTap: onIndexSelected,
    );
  }
}

