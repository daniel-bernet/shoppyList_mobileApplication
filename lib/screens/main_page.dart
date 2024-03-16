import 'package:app/components/bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:app/components/custom_app_bar.dart';
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

  final List<String> _pageTitle = [
    'shoppingPage',
    'addItemPage',
    'viewListPage',
    'myListsPage',
    'userPage',
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
        pageTitle: _pageTitle[_selectedIndex],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _pageOptions,
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _selectedIndex,
        onIndexSelected: _onItemTapped,
      ),
    );
  }
}
