import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:quittle/extensions/string_extension.dart';
import 'package:quittle/helpers/db_helper.dart';
import 'package:quittle/models/addiction.dart';
import 'package:quittle/providers/addictions_provider.dart';
import 'package:quittle/providers/settings_provider.dart';
import 'package:quittle/screens/create_addiction_screen.dart';
import 'package:quittle/util/progress_constants.dart';
import 'package:quittle/widgets/addiction_item_card.dart';
import 'package:quittle/widgets/settings_view.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:workmanager/workmanager.dart';

class AddictionsScreen extends StatefulWidget {
  static const routeName = '/addictions';

  @override
  _AddictionsScreenState createState() => _AddictionsScreenState();
}

class _AddictionsScreenState extends State<AddictionsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  _setProgNotifTasks(List<Addiction> addictions) {
    if (Provider.of<SettingsProvider>(context, listen: false)
        .receiveProgressNotifs) {
      for (var addiction in addictions) {
        if (addiction.level < levelDurations.length - 1) {
          Workmanager.registerPeriodicTask(
            addiction.id,
            'progress-notification',
            inputData: {
              'id': addiction.id,
              'locale': AppLocalizations.of(context).localeName,
            },
            frequency: Duration(minutes: 15),
            existingWorkPolicy: ExistingWorkPolicy.keep,
            constraints: Constraints(
              requiresDeviceIdle: false,
              requiresBatteryNotLow: false,
              requiresCharging: false,
              requiresStorageNotLow: false,
              networkType: NetworkType.not_required,
            ),
          );
        } else {
          Workmanager.cancelByUniqueName(addiction.id);
        }
      }
    }
  }

  void _onDelete(String id) async {
    final removedAddiction =
        await Provider.of<AddictionsProvider>(context, listen: false)
            .deleteAddiction(id);
    setState(() {
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(
              '${removedAddiction.name} deleted.',
            ),
            action: SnackBarAction(
              label: 'Undo',
              onPressed: () {
                Provider.of<AddictionsProvider>(context, listen: false)
                    .insertAddiction(removedAddiction);
              },
            ),
          ),
        );
    });
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex--;
      }
      Provider.of<AddictionsProvider>(context, listen: false)
          .reorderAddictions(oldIndex, newIndex);
    });
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

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            _scaffoldKey.currentState.openDrawer();
          },
        ),
      ),
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      drawer: SettingsView(),
      body: Consumer<AddictionsProvider>(
        builder: (ctx, addictionsData, child) {
          _setProgNotifTasks(addictionsData.addictions);
          return addictionsData.addictions.length > 0
              ? Theme(
                  data: Theme.of(context).copyWith(
                    canvasColor: Colors.transparent,
                    shadowColor: Colors.black26,
                  ),
                  child: ReorderableListView(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    children: [
                      for (Addiction addiction in addictionsData.addictions)
                        AddictionItemCard(
                          addictionData: addiction,
                          onDelete: _onDelete,
                          key: ValueKey(addiction.id),
                        ),
                    ],
                    onReorder: _onReorder,
                  ),
                )
              : child;
        },
        child: InkWell(
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
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Theme.of(context).canvasColor,
                      child: Icon(
                        Icons.add,
                        size: Theme.of(context).textTheme.headline1.fontSize,
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
                        fontSize:
                            Theme.of(context).textTheme.headline2.fontSize,
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
      ),
    );
  }
}
