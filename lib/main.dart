import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_quit_addiction_app/screens/addiction_item_screen.dart';
import 'package:provider/provider.dart';

import 'package:flutter_quit_addiction_app/providers/addictions.dart';
import 'package:flutter_quit_addiction_app/providers/settings.dart';
import 'package:flutter_quit_addiction_app/screens/addictions_screen.dart';
import 'package:flutter_quit_addiction_app/screens/create_addiction_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => new Addictions(),
        ),
        ChangeNotifierProvider(
          create: (_) => new Settings(),
        ),
      ],
      child: MaterialApp(
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          AppLocalizations.delegate
        ],
        supportedLocales: [
          const Locale('en', 'US'),
          const Locale('tr', 'TR'),
        ],
        title: 'Quit Addiction',
        theme: ThemeData(
          fontFamily: 'Rubik',
          // https://coolors.co/3f2333-f7f4f3-564d4a-f24333-ba1b1d //old
          // https://coolors.co/d7efd7-c8c8c8-f0cf65-e14b51-bd4f6c //now
          primaryColorLight: Color.fromRGBO(230, 86, 81, .8),
          primaryColor: Color.fromRGBO(230, 86, 81, 1),
          primaryColorDark: Color.fromRGBO(182, 85, 81, 1),
          primarySwatch: Colors.red,
          accentColor: Color.fromRGBO(147, 181, 198, 1),
          buttonColor: Color.fromRGBO(247, 244, 243, 1),
          canvasColor: Color.fromRGBO(247, 244, 243, 1),
          cardColor: Color.fromRGBO(230, 230, 230, 1),
          hintColor: Colors.blueGrey[700],
          visualDensity: VisualDensity.adaptivePlatformDensity,
          textTheme: TextTheme(
            headline6: TextStyle(
              // TODO: FIND A BETTER WAY TO CHANGE THIS
              fontSize: Theme.of(context).textTheme.headline6.fontSize * .9,
            ),
            bodyText2: TextStyle(
              color: Theme.of(context).hintColor,
            ),
          ),
          accentTextTheme: TextTheme(
            button: TextStyle(
              color: Theme.of(context).hintColor,
            ),
          ),
        ),
        home: AddictionsScreen(), // todo startup page logic
        routes: {
          CreateAddictionScreen.routeName: (ctx) => CreateAddictionScreen(),
          AddictionsScreen.routeName: (ctx) => AddictionsScreen(),
          AddictionItemScreen.routeName: (ctx) => AddictionItemScreen(),
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
