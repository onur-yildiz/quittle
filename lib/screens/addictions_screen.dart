import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_quit_addiction_app/providers/addictions.dart';
import 'package:flutter_quit_addiction_app/screens/create_addiction_screen.dart';
import 'package:flutter_quit_addiction_app/widgets/addiction_item.dart';
import 'package:provider/provider.dart';

class AddictionsScreen extends StatefulWidget {
  static const routeName = '/addictions';

  @override
  _AddictionsScreenState createState() => _AddictionsScreenState();
}

class _AddictionsScreenState extends State<AddictionsScreen> {
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => Navigator.pushNamed(
              context,
              CreateAddictionScreen.routeName,
            ),
          ),
        ],
      ),
      // ? MAKE DRAWER THE SETTINGS SCREEN MAYBE ??
      drawer: Container(
        height: deviceSize.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Placeholder'),
            Text('Placeholder'),
            Text('Placeholder'),
            Text('Placeholder'),
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).canvasColor,
              Theme.of(context).accentColor.withAlpha(30),
            ],
            stops: [.4, 1],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: FutureBuilder(
          future:
              Provider.of<Addictions>(context, listen: false).fetchAddictions(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              if (snapshot.error != null) {
                return Center(
                  child: Text('An error occured.'),
                );
              }
              return Consumer<Addictions>(
                builder: (ctx, addictionData, child) => RefreshIndicator(
                  onRefresh: () async {
                    await addictionData.fetchAddictions();
                  },
                  child: ListView.builder(
                    itemCount: addictionData.addictions.length,
                    itemBuilder: (ctx, index) => AddictionItem(
                      addictionData.addictions[index],
                    ),
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
