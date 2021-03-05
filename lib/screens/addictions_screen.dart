import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:quittle/extensions/string_extension.dart';
import 'package:quittle/models/addiction.dart';
import 'package:quittle/providers/addictions_provider.dart';
import 'package:quittle/providers/settings_provider.dart';
import 'package:quittle/screens/create_addiction_screen.dart';
import 'package:quittle/util/achievement_constants.dart';
import 'package:quittle/widgets/addiction_item_card.dart';
import 'package:quittle/widgets/settings_view.dart';
import 'package:provider/provider.dart';
import 'package:shrink_sidemenu/shrink_sidemenu.dart';
import 'package:workmanager/workmanager.dart';

class AddictionsScreen extends StatefulWidget {
  static const routeName = '/addictions';

  @override
  _AddictionsScreenState createState() => _AddictionsScreenState();
}

class _AddictionsScreenState extends State<AddictionsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  final GlobalKey<SideMenuState> _sideMenuKey = GlobalKey<SideMenuState>();

  _setProgNotifTasks(List<Addiction> addictions) {
    if (Provider.of<SettingsProvider>(context, listen: false)
        .receiveProgressNotifs) {
      for (var addiction in addictions) {
        if (addiction.level < getAchievementDurations.length - 1) {
          Workmanager.registerPeriodicTask(
            addiction.id,
            'progress-notification',
            inputData: {
              'id': addiction.id,
              'locale': AppLocalizations.of(context).localeName,
            },
            frequency: Duration(minutes: 15),
            existingWorkPolicy: ExistingWorkPolicy.keep,
          );
        } else {
          Workmanager.cancelByUniqueName(addiction.id);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    void pushCreateAddictionScreen() {
      Navigator.of(context).push(
        PageRouteBuilder(
          transitionDuration: Duration(milliseconds: 400),
          reverseTransitionDuration: Duration(milliseconds: 250),
          pageBuilder: (_, __, ___) => CreateAddictionScreen(),
        ),
      );
    }

    return WillPopScope(
      onWillPop: () async {
        final _state = _sideMenuKey.currentState;
        if (_state.isOpened) {
          _state.closeSideMenu();
          return false;
        }
        return true;
      },
      child: SideMenu(
        key: _sideMenuKey,
        menu: SettingsView(),
        type: SideMenuType.slideNRotate,
        background: Theme.of(context).primaryColor,
        maxMenuWidth: deviceSize.width * .8,
        child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
              leading: IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              final _state = _sideMenuKey.currentState;
              if (_state.isOpened)
                _state.closeSideMenu();
              else
                _state.openSideMenu();
            },
          )),
          floatingActionButton: Consumer<AddictionsProvider>(
            child: FloatingActionButton(
              heroTag: 'newAddiction',
              onPressed: pushCreateAddictionScreen,
              backgroundColor: Theme.of(context).primaryColor,
              tooltip: 'New',
              child: Icon(Icons.add),
            ),
            builder: (_, addictionsData, child) {
              return addictionsData.addictions.length == 0
                  ? SizedBox()
                  : SizedBox(
                      child: child,
                    );
            },
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          // bottomNavigationBar: Builder(
          //   builder: (context) => BottomAppBar(
          //     child: Row(
          //       mainAxisAlignment: MainAxisAlignment.start,
          //       children: [
          //         IconButton(
          //           onPressed: () {
          //             // Scaffold.of(context).openDrawer();
          //             final _state = _sideMenuKey.currentState;
          //             if (_state.isOpened)
          //               _state.closeSideMenu(); // close side menu
          //             else
          //               _state.openSideMenu(); // open side menu
          //           },
          //           color: Theme.of(context).primaryColor,
          //           tooltip: 'Menu',
          //           icon: Icon(Icons.menu),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
          drawer: SettingsView(),
          body: Consumer<AddictionsProvider>(
            builder: (ctx, addictionsData, child) {
              _setProgNotifTasks(addictionsData.addictions);
              return RefreshIndicator(
                onRefresh: () async {
                  await addictionsData.fetchAddictions();
                },
                child: addictionsData.addictions.length > 0
                    ? ListView.builder(
                        itemCount: addictionsData.addictions.length,
                        itemBuilder: (ctx, index) {
                          return AddictionItem(
                            addictionData: addictionsData.addictions[index],
                          );
                        },
                      )
                    : InkWell(
                        onTap: pushCreateAddictionScreen,
                        child: Container(
                          height: deviceSize.height,
                          width: deviceSize.width,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Center(
                                child: SizedBox.fromSize(
                                  size: Size.square(deviceSize.width * .5),
                                  child: FloatingActionButton(
                                    heroTag: 'newAddiction',
                                    elevation: 0,
                                    backgroundColor:
                                        Theme.of(context).primaryColor,
                                    foregroundColor:
                                        Theme.of(context).canvasColor,
                                    child: Icon(
                                      Icons.add,
                                      size: Theme.of(context)
                                          .textTheme
                                          .headline1
                                          .fontSize,
                                    ),
                                    onPressed: null,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Text(
                                    'Quittle',
                                    style: TextStyle(
                                      fontSize: Theme.of(context)
                                          .textTheme
                                          .headline2
                                          .fontSize,
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
              );
            },
          ),
        ),
      ),
    );
  }
}
