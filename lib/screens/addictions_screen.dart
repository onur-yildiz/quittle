import 'package:flutter/material.dart';
import 'package:flutter_quit_addiction_app/screens/create_addiction_screen.dart';

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
    );
  }
}
