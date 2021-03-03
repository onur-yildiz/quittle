import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_quit_addiction_app/extensions/string_extension.dart';
import 'package:flutter_quit_addiction_app/main.dart';
import 'package:flutter_quit_addiction_app/providers/addictions_provider.dart';
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

  Future<void> _fetchAddictions() async {
    await Provider.of<AddictionsProvider>(context, listen: false)
        .fetchAddictions();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context);
    // final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      floatingActionButton: FloatingActionButton(
        heroTag: 'newAddiction',
        onPressed: () {
          Navigator.of(context).pushNamed(CreateAddictionScreen.routeName);
        },
        backgroundColor: Theme.of(context).primaryColor,
        tooltip: 'New',
        child: Icon(Icons.add),
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
        future: _fetchAddictions(),
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
                    : Material(
                        type: MaterialType.canvas,
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context)
                                .pushNamed(CreateAddictionScreen.routeName);
                          },
                          child: Center(
                            child: Icon(
                              Icons.add,
                              size: Theme.of(context)
                                  .textTheme
                                  .headline1
                                  .fontSize,
                              color: Theme.of(context).primaryColor,
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
