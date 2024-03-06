import 'package:app/screens/add_item_page.dart';
import 'package:app/screens/my_lists_page.dart';
import 'package:app/screens/shopping_page.dart';
import 'package:app/screens/user_page.dart';
import 'package:app/screens/view_list_page.dart';
import 'package:flutter/material.dart';

import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'utils/common_widgets/invalid_route.dart';
import 'values/app_routes.dart';

class Routes {
  const Routes._();

  static Route<dynamic> generateRoute(RouteSettings settings) {
    Route<dynamic> getRoute({
      required Widget widget,
      bool fullscreenDialog = false,
    }) {
      return MaterialPageRoute<void>(
        builder: (context) => widget,
        settings: settings,
        fullscreenDialog: fullscreenDialog,
      );
    }

    switch (settings.name) {
      case AppRoutes.login:
        return getRoute(widget: const LoginPage());

      case AppRoutes.register:
        return getRoute(widget: const RegisterPage());

      case AppRoutes.shopping:
        return getRoute(widget: const ShoppingPage());

      case AppRoutes.addItem:
        return getRoute(widget: const AddItemPage());

      case AppRoutes.viewList:
        return getRoute(widget: const ViewListPage());

      case AppRoutes.myLists:
        return getRoute(widget: const MyListsPage());

      case AppRoutes.user:
        return getRoute(widget: const UserPage());
        
      default:
        return getRoute(widget: const InvalidRoute());
    }
  }
}
