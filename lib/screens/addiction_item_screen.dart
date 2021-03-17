import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

import 'package:quittle/models/addiction_item_screen_args.dart';
import 'package:quittle/widgets/addiction_item.dart';
import 'package:quittle/widgets/gifts.dart';
import 'package:quittle/widgets/achievements.dart';

const _refreshInterval = Duration(seconds: 60);

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
  void initState() {
    Timer.periodic(_refreshInterval, (timer) {
      if (mounted) {
        setState(() {});
      } else {
        timer.cancel();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final AddictionItemScreenArgs args =
        ModalRoute.of(context).settings.arguments;
    final local = AppLocalizations.of(context);

    List<Widget> _buildScreens() {
      return [
        AddictionItem(args: args),
        Gifts(data: args.data),
        Achievements(data: args.data),
      ];
    }

    List<PersistentBottomNavBarItem> _navBarItems() {
      return [
        PersistentBottomNavBarItem(
          icon: FaIcon(FontAwesomeIcons.infoCircle),
          title: (local.overview),
          activeColor: Theme.of(context).primaryColor,
          inactiveColor: Theme.of(context).hintColor,
        ),
        PersistentBottomNavBarItem(
          icon: FaIcon(FontAwesomeIcons.gifts),
          title: (local.rewards),
          activeColor: Theme.of(context).primaryColor,
          inactiveColor: Theme.of(context).hintColor,
        ),
        PersistentBottomNavBarItem(
          icon: FaIcon(FontAwesomeIcons.trophy),
          title: (local.achievements),
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
          backgroundColor: Theme.of(context).cardColor,
          handleAndroidBackButtonPress: true,
          resizeToAvoidBottomInset: true,
          stateManagement: true,
          hideNavigationBarWhenKeyboardShows: true,
          decoration: NavBarDecoration(
            borderRadius: BorderRadius.circular(0.0),
            colorBehindNavBar: Theme.of(context).canvasColor,
          ),
          popAllScreensOnTapOfSelectedTab: true,
          popActionScreens: PopActionScreensType.all,
          itemAnimationProperties: ItemAnimationProperties(
            duration: Duration(milliseconds: 250),
            curve: Curves.ease,
          ),
          screenTransitionAnimation: ScreenTransitionAnimation(
            animateTabTransition: true,
            curve: Curves.ease,
            duration: Duration(milliseconds: 250),
          ),
          navBarStyle: NavBarStyle.style4,
        ),
      ),
    );
  }
}
