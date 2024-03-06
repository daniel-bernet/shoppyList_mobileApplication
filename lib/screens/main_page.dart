import 'package:flutter/material.dart';
import 'package:app/values/app_colors.dart';
import 'package:app/components/custom_app_bar.dart'; // Ensure this path is correct
import 'shopping_page.dart';
import 'add_item_page.dart';
import 'view_list_page.dart';
import 'my_lists_page.dart';
import 'user_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  final List<Widget> _pageOptions = [
    const ShoppingPage(),
    const AddItemPage(),
    const ViewListPage(),
    const MyListsPage(),
    const UserPage(),
  ];

  final List<String> _pageTitles = [
    'Shopping',
    'Add Item',
    'View List',
    'My Lists',
    'User',
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        pageTitle: _pageTitles[_selectedIndex],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _pageOptions,
      ),
      bottomNavigationBar: BottomNavigationBar(
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
        currentIndex: _selectedIndex,
        selectedItemColor: AppColors.lightPrimaryColor,
        unselectedItemColor: AppColors.lightSecondaryColor,
        onTap: _onItemTapped,
      ),
    );
  }
}
