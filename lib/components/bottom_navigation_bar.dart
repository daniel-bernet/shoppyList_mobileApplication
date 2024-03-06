import 'package:app/values/app_colors.dart';
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
    // Logic to navigate to different screens based on index
    // You should modify this logic to actually navigate to different screens
    // based on your app's routing mechanism
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
      selectedItemColor: AppColors.lightOnPrimaryColor,
      unselectedItemColor: Colors.grey,
      onTap: _onItemTapped,
    );
  }
}
