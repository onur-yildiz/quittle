import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_quit_addiction_app/extensions/string_extension.dart';
import 'package:flutter_quit_addiction_app/providers/addictions_provider.dart';
import 'package:flutter_quit_addiction_app/providers/settings_provider.dart';
import 'package:flutter_quit_addiction_app/screens/create_addiction_screen.dart';
import 'package:flutter_quit_addiction_app/widgets/addiction_item_card.dart';
import 'package:flutter_quit_addiction_app/widgets/settings_view.dart';
import 'package:provider/provider.dart';

class AddictionsScreen extends StatefulWidget {
  static const routeName = '/addictions';

  @override
  _AddictionsScreenState createState() => _AddictionsScreenState();
}

class _AddictionsScreenState extends State<AddictionsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  Future<void> _fetchData() async {
    await Provider.of<AddictionsProvider>(context, listen: false)
        .fetchAddictions();
    await Provider.of<SettingsProvider>(context, listen: false).fetchSettings();
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context);
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      floatingActionButton: Consumer<AddictionsProvider>(
        child: FloatingActionButton(
          heroTag: 'newAddiction',
          onPressed: () {
            Navigator.of(context).pushNamed(CreateAddictionScreen.routeName);
          },
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Builder(
        builder: (context) => BottomAppBar(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                color: Theme.of(context).primaryColor,
                tooltip: 'Menu',
                icon: Icon(Icons.menu),
              ),
            ],
          ),
        ),
      ),
      drawer: SettingsView(),
      body: FutureBuilder(
        future: _fetchData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (snapshot.error != null) {
              return Center(
                child: Text(local.genericErrorMessage.capitalizeFirstLetter()),
              );
            }
            return Consumer<AddictionsProvider>(
              builder: (ctx, addictionsData, child) => RefreshIndicator(
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
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed(CreateAddictionScreen.routeName);
                        },
                        child: Container(
                          height: deviceSize.height,
                          width: deviceSize.width,
                          child: Center(
                            child: SizedBox.fromSize(
                              size: Size.square(deviceSize.width * .5),
                              child: FloatingActionButton(
                                heroTag: 'newAddiction',
                                elevation: 0,
                                backgroundColor: Theme.of(context).primaryColor,
                                foregroundColor: Theme.of(context).canvasColor,
                                splashColor:
                                    Theme.of(context).primaryColorLight,
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
                        ),
                      ),
              ),
            );
          }
        },
      ),
    );
  }
}
