import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quit_addiction_app/models/addiction_item_screen_args.dart';
import 'package:flutter_quit_addiction_app/widgets/addiction_item.dart';
import 'package:flutter_quit_addiction_app/widgets/gifts.dart';
import 'package:flutter_quit_addiction_app/widgets/settings_view.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class AddictionItemScreen extends StatefulWidget {
  static const routeName = '/addiction-item';

  @override
  _AddictionItemState createState() => _AddictionItemState();
}

class _AddictionItemState extends State<AddictionItemScreen> {
  PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);

  @override
  Widget build(BuildContext context) {
    final AddictionItemScreenArgs args =
        ModalRoute.of(context).settings.arguments;

    List<Widget> _buildScreens() {
      return [
        AddictionItem(args: args),
        Gifts(data: args.data),
        SettingsView(),
      ];
    }

    List<PersistentBottomNavBarItem> _navBarsItems() {
      return [
        PersistentBottomNavBarItem(
          icon: Icon(Icons.home),
          title: ("Home"),
          activeColor: Theme.of(context).primaryColor,
          inactiveColor: Theme.of(context).hintColor,
        ),
        PersistentBottomNavBarItem(
          icon: Icon(Icons.wallet_giftcard),
          title: ("Gifts"),
          activeColor: Theme.of(context).primaryColor,
          inactiveColor: Theme.of(context).hintColor,
        ),
        PersistentBottomNavBarItem(
          icon: Icon(Icons.fact_check_rounded),
          title: ("Achievements"),
          activeColor: Theme.of(context).primaryColor,
          inactiveColor: Theme.of(context).hintColor,
        ),
      ];
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          args.data.name.toUpperCase(),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: PersistentTabView(
        context,
        controller: _controller,
        screens: _buildScreens(),
        items: _navBarsItems(),
        confineInSafeArea: true,
        backgroundColor: Colors.white,
        handleAndroidBackButtonPress: false, //pop all or one by one
        resizeToAvoidBottomInset:
            true, // This needs to be true if you want to move up the screen when keyboard appears.
        stateManagement: true,
        hideNavigationBarWhenKeyboardShows:
            true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument.
        decoration: NavBarDecoration(
          borderRadius: BorderRadius.circular(0.0),
          colorBehindNavBar: Colors.white,
        ),
        popAllScreensOnTapOfSelectedTab: true,
        popActionScreens: PopActionScreensType.all,
        itemAnimationProperties: ItemAnimationProperties(
          // Navigation Bar's items animation properties.
          duration: Duration(milliseconds: 200),
          curve: Curves.ease,
        ),
        screenTransitionAnimation: ScreenTransitionAnimation(
          // Screen transition animation on change of selected tab.
          animateTabTransition: true,
          curve: Curves.ease,
          duration: Duration(milliseconds: 200),
        ),
        navBarStyle:
            NavBarStyle.style4, // Choose the nav bar style with this property.
      ),
    );
  }
}
