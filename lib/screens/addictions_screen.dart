import 'package:flutter/material.dart';
import 'package:flutter_quit_addiction_app/providers/addictions.dart';
import 'package:flutter_quit_addiction_app/screens/create_addiction_screen.dart';
import 'package:flutter_quit_addiction_app/widgets/addiction_item.dart';
import 'package:flutter_quit_addiction_app/widgets/settings_view.dart';
import 'package:provider/provider.dart';

class AddictionsScreen extends StatefulWidget {
  static const routeName = '/addictions';

  @override
  _AddictionsScreenState createState() => _AddictionsScreenState();
}

class _AddictionsScreenState extends State<AddictionsScreen> {
  Future<void> _fetchAddictions() async {
    await Provider.of<Addictions>(context, listen: false).fetchAddictions();
  }

  @override
  Widget build(BuildContext context) {
    // final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('QuitAll'),
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
                child: Text('An error occured'),
              );
            }
            return Consumer<Addictions>(
              builder: (ctx, addictionsData, child) => RefreshIndicator(
                onRefresh: () async {
                  await addictionsData.fetchAddictions();
                },
                child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: addictionsData.addictions.length,
                  itemBuilder: (ctx, index) {
                    return AddictionItem(
                      addictionData: addictionsData.addictions[index],
                    );
                  },
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
