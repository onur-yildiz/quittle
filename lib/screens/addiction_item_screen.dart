import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quittle/models/addiction_item_screen_args.dart';
import 'package:quittle/widgets/addiction_item.dart';
import 'package:quittle/widgets/gifts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:quittle/widgets/achievements.dart';

class AddictionItemScreen extends StatefulWidget {
  static const routeName = '/addiction-item';

  @override
  _AddictionItemState createState() => _AddictionItemState();
}

class _AddictionItemState extends State<AddictionItemScreen> {
  PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);
  final tabLength = 3;

  @override
  Widget build(BuildContext context) {
    final AddictionItemScreenArgs args =
        ModalRoute.of(context).settings.arguments;

    List<Widget> _buildScreens() {
      return [
        AddictionItem(args: args),
        Gifts(id: args.data.id),
        Achievements(data: args.data),
        // Playground(),
      ];
    }

    List<PersistentBottomNavBarItem> _navBarItems() {
      return [
        PersistentBottomNavBarItem(
          icon: FaIcon(FontAwesomeIcons.infoCircle),
          title: ("Overview"),
          activeColor: Theme.of(context).primaryColor,
          inactiveColor: Theme.of(context).hintColor,
        ),
        PersistentBottomNavBarItem(
          icon: FaIcon(FontAwesomeIcons.gifts),
          title: ("Rewards"),
          activeColor: Theme.of(context).primaryColor,
          inactiveColor: Theme.of(context).hintColor,
        ),
        PersistentBottomNavBarItem(
          icon: FaIcon(FontAwesomeIcons.trophy),
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
      body: GestureDetector(
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity < -400 &&
              _controller.index < tabLength - 1) {
            _controller.jumpToTab(_controller.index + 1);
          } else if (details.primaryVelocity > 400 && _controller.index > 0) {
            _controller.jumpToTab(_controller.index - 1);
          }
        },
        child: PersistentTabView(
          context,
          controller: _controller,
          screens: _buildScreens(),
          items: _navBarItems(),
          confineInSafeArea: true,
          backgroundColor: Colors.white,
          handleAndroidBackButtonPress: true, //pop all or one by one
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
            duration: Duration(milliseconds: 250),
            curve: Curves.ease,
          ),
          screenTransitionAnimation: ScreenTransitionAnimation(
            // Screen transition animation on change of selected tab.
            animateTabTransition: true,
            curve: Curves.ease,
            duration: Duration(milliseconds: 250),
          ),
          navBarStyle: NavBarStyle
              .style4, // Choose the nav bar style with this property.
        ),
      ),
    );
  }
}
