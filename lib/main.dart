import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:quittle/helpers/db_helper.dart';
import 'package:quittle/models/addiction.dart';
import 'package:quittle/screens/addiction_item_screen.dart';
import 'package:provider/provider.dart';

import 'package:quittle/providers/addictions_provider.dart';
import 'package:quittle/providers/settings_provider.dart';
import 'package:quittle/screens/addictions_screen.dart';
import 'package:quittle/screens/create_addiction_screen.dart';
import 'package:quittle/util/custom_localizations.dart';
import 'package:quittle/util/quotes_constants.dart';
import 'package:quittle/widgets/playground.dart';
import 'package:rxdart/subjects.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:workmanager/workmanager.dart';
import 'package:quittle/util/progress_constants.dart';

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

  tz.initializeTimeZones();

  final NotificationAppLaunchDetails notificationAppLaunchDetails =
      await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

  _initialRoute = AddictionsScreen.routeName;
  if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
    selectedNotificationPayload = notificationAppLaunchDetails.payload;
    _initialRoute = AddictionItemScreen.routeName;
  }

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('font_awesome_chain');

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
          create: (_) => new SettingsProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => new AddictionsProvider(),
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
        title: 'Quittle',
        theme: ThemeData(
          fontFamily: 'Rubik',
          // https://coolors.co/3f2333-f7f4f3-564d4a-f24333-ba1b1d //old
          // https://coolors.co/d7efd7-c8c8c8-f0cf65-e14b51-bd4f6c //now
          primaryColorLight: Color.fromRGBO(230, 86, 81, .8),
          primaryColor: Color.fromRGBO(230, 86, 81, 1),
          primaryColorDark: Color.fromRGBO(182, 85, 81, 1),
          primarySwatch: Colors.red, //TODO custom swatch
          // accentColor: Color.fromRGBO(147, 181, 198, 1),
          accentColor: Color.fromRGBO(46, 105, 153, 1), // 74, 111, 134
          buttonColor: Color.fromRGBO(247, 244, 243, 1),
          canvasColor: Color.fromRGBO(247, 244, 243, 1),
          cardColor: Color.fromRGBO(220, 220, 220, 1),
          hintColor: Colors.blueGrey[800],
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        // initialRoute: _initialRoute,
        home: Builder(
          builder: (context) => FutureBuilder(
            future: _fetchStartupData(context),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              } else {
                _setDailyQuoteNotification(context);
                return AddictionsScreen();
              }
            },
          ),
        ),
        routes: {
          CreateAddictionScreen.routeName: (ctx) => CreateAddictionScreen(),
          AddictionsScreen.routeName: (ctx) => AddictionsScreen(),
          AddictionItemScreen.routeName: (ctx) => AddictionItemScreen(),
        },
      ),
    );
  }
}

Future<void> _fetchStartupData(BuildContext context) async {
  await Provider.of<AddictionsProvider>(context, listen: false)
      .fetchAddictions();
  await Provider.of<SettingsProvider>(context, listen: false).fetchSettings();
}

void _setDailyQuoteNotification(BuildContext context) {
  final today = DateTime.now();
  final tomorrowMorning =
      DateTime(today.year, today.month, (today.day + 1), 9, 0, 0);
  final timeTillTomorrowMorning = tomorrowMorning.difference(today);
  if (Provider.of<SettingsProvider>(context, listen: false)
      .receiveQuoteNotifs) {
    Workmanager.registerPeriodicTask(
      'quote-notification',
      'quote-notification',
      inputData: {
        'locale': AppLocalizations.of(context).localeName,
      },
      initialDelay: timeTillTomorrowMorning,
      frequency: Duration(days: 1),
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
    Workmanager.cancelByUniqueName('quote-notification');
  }
}

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
        final nextLevel = addiction.level + 1;
        if (addiction.abstinenceTime.inSeconds >=
            levelDurations[nextLevel].inSeconds) {
          await DBHelper.update(
            'addictions',
            'level',
            addiction.id,
            nextLevel,
          );
          showProgressNotification(
            addiction.name.toUpperCase(),
            progressNotificationMsg(nextLevel, inputData['locale']),
          );
        }
        // if last achievement level, cancel
        if (addiction.level == 8) {
          Workmanager.cancelByUniqueName(addiction.id);
        }
        break;
      case 'quote-notification':
        final quoteList = quotes[inputData['locale']];
        Random random = new Random(DateTime.now().millisecondsSinceEpoch);
        int rndi = random.nextInt(quoteList.length);
        showQuoteNotification(
          quoteOfTheDayLocs[inputData['locale']],
          quoteList[rndi]['quote'],
        );
        break;
      default:
    }
    return Future.value(true);
  });
}

void showProgressNotification(
    String notificationTitle, String notificationBody) {
  final androidDetails = AndroidNotificationDetails(
    'quitAllProgress',
    'progressNotifications',
    'quitAllProgressNotifications',
  );
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

void showQuoteNotification(String notificationTitle, String notificationBody) {
  final androidDetails = AndroidNotificationDetails(
    'quitAllProgress',
    'progressNotifications',
    'quitAllProgressNotifications',
    styleInformation: BigTextStyleInformation(''),
  );
  final genNotDetails = NotificationDetails(
    android: androidDetails,
  );
  flutterLocalNotificationsPlugin.show(
    3,
    notificationTitle,
    notificationBody,
    genNotDetails,
  );
}

// final androidDetails = AndroidNotificationDetails('quitAllProgress',
//         'progressNotifications', 'quitAllProgressNotifications');
//     final generalNotificationDetails = NotificationDetails(
//       android: androidDetails,
//     );

//     final tomorrow = tz.TZDateTime.now(tz.local).add(Duration(days: 1));
//     final tomorrowAtMorning = tz.TZDateTime.local(
//         tomorrow.year, tomorrow.month, tomorrow.day, 9, 0, 0);

//     final locale = AppLocalizations.of(context).localeName;
//     final quoteList = quotes[locale];
//     Random random = new Random();
//     final notificationTitle = quoteOfTheDayLocs[locale];
//     final notificationBody =
//         quoteList[random.nextInt(quoteList.length)]['quote'];

//     flutterLocalNotificationsPlugin.zonedSchedule(
//       3,
//       notificationTitle,
//       notificationBody,
//       tomorrowAtMorning,
//       generalNotificationDetails,
//       uiLocalNotificationDateInterpretation:
//           UILocalNotificationDateInterpretation.absoluteTime,
//       androidAllowWhileIdle: false,
//       matchDateTimeComponents: DateTimeComponents.time,
//     );
