import 'package:flutter/material.dart';
import 'package:app/values/app_routes.dart';
import 'package:app/utils/helpers/navigation_helper.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  final int currentIndex;

  const CustomBottomNavigationBar({super.key, required this.currentIndex});

  @override
  State<CustomBottomNavigationBar> createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  void _onItemTapped(int index) {
    switch (index) {
      case 0:
        NavigationHelper.pushNamed(AppRoutes.shopping);
        break;
      case 1:
        NavigationHelper.pushNamed(AppRoutes.addItem);
        break;
      case 2:
        NavigationHelper.pushNamed(AppRoutes.viewList);
        break;
      case 3:
        NavigationHelper.pushNamed(AppRoutes.myLists);
        break;
      case 4:
        NavigationHelper.pushNamed(AppRoutes.user);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).colorScheme.primary;
    final Color onPrimaryColor = Theme.of(context).colorScheme.onPrimary;

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
      currentIndex: widget.currentIndex,
      selectedItemColor: primaryColor,
      unselectedItemColor: onPrimaryColor.withOpacity(0.6),
      onTap: _onItemTapped,
    );
  }
}
