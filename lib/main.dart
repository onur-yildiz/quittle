import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_quit_addiction_app/helpers/db_helper.dart';
import 'package:flutter_quit_addiction_app/models/addiction.dart';
import 'package:flutter_quit_addiction_app/screens/addiction_item_screen.dart';
import 'package:provider/provider.dart';

import 'package:flutter_quit_addiction_app/providers/addictions_provider.dart';
import 'package:flutter_quit_addiction_app/providers/settings_provider.dart';
import 'package:flutter_quit_addiction_app/screens/addictions_screen.dart';
import 'package:flutter_quit_addiction_app/screens/create_addiction_screen.dart';
import 'package:rxdart/subjects.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:workmanager/workmanager.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject =
    BehaviorSubject<ReceivedNotification>();

final BehaviorSubject<String> selectNotificationSubject =
    BehaviorSubject<String>();

// const MethodChannel platform = MethodChannel('flutter_quit_addiction');

class ReceivedNotification {
  ReceivedNotification({
    @required this.id,
    @required this.title,
    @required this.body,
    @required this.payload,
  });

  final int id;
  final String title;
  final String body;
  final String payload;
}

String selectedNotificationPayload;
String _initialRoute;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Workmanager.initialize(
    callbackDispatcher,
  );

  await _configureLocalTimeZone();

  final NotificationAppLaunchDetails notificationAppLaunchDetails =
      await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

  _initialRoute = AddictionsScreen.routeName;
  if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
    selectedNotificationPayload = notificationAppLaunchDetails.payload;
    _initialRoute = AddictionItemScreen.routeName;
  }

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('ic_launcher');

  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (String payload) async {
    if (payload != null) {
      debugPrint('notification payload: $payload');
    }
    selectedNotificationPayload = payload;
    selectNotificationSubject.add(payload);
  });

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => new AddictionsProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => new SettingsProvider(),
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
          // accentColor: Color.fromRGBO(147, 181, 198, 1),
          accentColor: Color.fromRGBO(74, 111, 134, 1),
          buttonColor: Color.fromRGBO(247, 244, 243, 1),
          canvasColor: Color.fromRGBO(247, 244, 243, 1),
          cardColor: Color.fromRGBO(220, 220, 220, 1),
          hintColor: Colors.blueGrey[700],
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: _initialRoute,
        // home: Builder(
        //   builder: (context) => FutureBuilder(
        //     future: startup(context),
        //     builder: (_, snapshot) => AddictionsScreen(),
        //   ),
        // ),
        routes: {
          CreateAddictionScreen.routeName: (ctx) => CreateAddictionScreen(),
          AddictionsScreen.routeName: (ctx) => AddictionsScreen(),
          AddictionItemScreen.routeName: (ctx) => AddictionItemScreen(),
        },
      ),
    );
  }
}

// Future<void> startup(BuildContext context) async {
//   await Provider.of<AddictionsProvider>(context).fetchAddictions();
//   await Provider.of<SettingsProvider>(context, listen: false).fetchSettings();
//   return Future.value(null);
// }

void callbackDispatcher() {
  Workmanager.executeTask((taskName, inputData) async {
    switch (taskName) {
      case 'progress-notification':
        final addictionData =
            await DBHelper.getData('addictions', 'id', inputData['id']);
        final addiction = Addiction(
          id: addictionData[0]['id'],
          name: addictionData[0]['name'],
          quitDate: addictionData[0]['quit_date'],
          consumptionType: addictionData[0]['consumption_type'],
          dailyConsumption: addictionData[0]['daily_consumption'],
          unitCost: addictionData[0]['unit_cost'],
          level: addictionData[0]['level'],
        );
        final nextLevel =
            addiction.level + 1; // next level index = current level's index + 1
        if (addiction.abstinenceTime.inSeconds >=
            getAchievementDurations[nextLevel].inSeconds) {
          await DBHelper.update(
            'addictions',
            'level',
            addiction.id,
            nextLevel,
          );
          showProgressNotification(addiction.name.toUpperCase(),
              'You reached level ${(nextLevel + 1)}!'); // next level index + 1 to show real level value
        }
        // if last achievement level, cancel
        if (addiction.level == 8) {
          Workmanager.cancelByUniqueName(addiction.id);
        }
        break;
      default:
    }
    return Future.value(true);
  });
}

Future<void> _configureLocalTimeZone() async {
  tz.initializeTimeZones();
  // final String timeZoneName = await platform.invokeMethod('getTimeZoneName');
  // // final String timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
  // tz.setLocalLocation(tz.getLocation(timeZoneName));
}

void showProgressNotification(
    String notificationTitle, String notificationBody) {
  final androidDetails = AndroidNotificationDetails('quitAllProgress',
      'progressNotifications', 'quitAllProgressNotifications');
  final genNotDetails = NotificationDetails(
    android: androidDetails,
  );
  flutterLocalNotificationsPlugin.show(
    2,
    notificationTitle,
    notificationBody,
    genNotDetails,
  );
}

// void showProgressNotification(
//     String notificationTitle, String notificationBody) {
//   final androidDetails = AndroidNotificationDetails('quitAllProgress',
//       'progressNotifications', 'quitAllProgressNotifications');
//   final genNotDetails = NotificationDetails(
//     android: androidDetails,
//   );
//   final scheduledDate =
//       tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5));
//   flutterLocalNotificationsPlugin.zonedSchedule(
//     1,
//     notificationTitle,
//     notificationBody,
//     scheduledDate,
//     genNotDetails,
//     uiLocalNotificationDateInterpretation:
//         UILocalNotificationDateInterpretation.wallClockTime,
//     androidAllowWhileIdle: false,
//   );
// }

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
