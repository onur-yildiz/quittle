import 'package:flutter/material.dart';
import 'package:flutter_quit_addiction_app/providers/addictions.dart';
import 'package:flutter_quit_addiction_app/screens/addictions_screen.dart';
import 'package:flutter_quit_addiction_app/screens/create_addiction_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => Addictions(),
      child: MaterialApp(
        title: 'Quit Addiction',
        theme: ThemeData(
          // https://coolors.co/3f2333-f7f4f3-564d4a-f24333-ba1b1d
          primaryColorLight: Color.fromRGBO(134, 70, 102, 1),
          primaryColor: Color.fromRGBO(91, 35, 51, 1),
          primaryColorDark: Color.fromRGBO(82, 35, 51, 1),
          primarySwatch: Colors.red,
          accentColor: Color.fromRGBO(186, 27, 29, 1),
          buttonColor: Color.fromRGBO(247, 244, 243, 1),
          // dialogBackgroundColor: Color.fromRGBO(247, 244, 243, .4),
          canvasColor: Color.fromRGBO(247, 244, 243, 1),
          cardColor: Color.fromRGBO(247, 244, 243, 1),
          hintColor: Colors.grey[750],
          visualDensity: VisualDensity.adaptivePlatformDensity,
          accentTextTheme: TextTheme(
            button: TextStyle(
              color: Colors.blueGrey[900],
            ),
          ),
        ),
        home: CreateAddictionScreen(),
        routes: {
          CreateAddictionScreen.routeName: (ctx) => CreateAddictionScreen(),
          AddictionsScreen.routeName: (ctx) => AddictionsScreen(),
          // SettingsScreen.routeName: (ctx) => SetttingsScreen(),
        },
      ),
    );
  }
}

/*

Settings {
  startOfWeek: String = 'monday',
  theme: ThemeMode = ThemeMode.system  // LOOK FOR ALREADY IMPLEMENTED STANDART
}

User {
  addictions: List<Addiction>,
  achievementSummary: AchievementSummary,
  achievements = {

  }
}

Addiction {
  name: String,
  quitDate: DateTime = DateTime.now,
  consumptionType: ComsumptionType = ConsumptionType.quantity,
  dailyConsumption: double,
  comsumptionUnitCost: double,
  personalNotes: List<PersonalNote>,
}

AchievementSummary {
  bronzeTrophies: int,
  silverTrophies: int,
  goldTrophies: int,
  diamondTrophies: int,
  platinumTrophies: int,
}

PersonalNote {
  title: String,
  text: String,
  date: DateTime = DateTime.now,
}

*/
