import 'dart:async';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:flutter/material.dart';

class TargetDurationIndicator extends StatefulWidget {
  TargetDurationIndicator({
    @required this.duration,
  });

  final Duration duration;

  @override
  _TargetDurationIndicatorState createState() =>
      _TargetDurationIndicatorState();
}

class _TargetDurationIndicatorState extends State<TargetDurationIndicator> {
  Duration updatedDuration;
  String targetUnit;
  int targetValue;
  String counterUnit;
  int counterValue;
  double percentage = 0.0;
  final int refreshInterval = 15;

  // final daysInMonth = DateTimeRange(
  //   start: DateTime(
  //     DateTime.now().year,
  //     DateTime.now().month,
  //   ),
  //   end: DateTime(
  //     DateTime.now().year,
  //     DateTime.now().month + 1,
  //   ),
  // ).duration.inDays;

  void setValues(Duration time, [AppLocalizations local]) {
    if (time.inHours < 24) {
      if (time.inHours < 1) {
        targetValue = 1;
        targetUnit = local.hour(1);
        counterValue = time.inMinutes;
        counterUnit = local.minute(counterValue);
        percentage = counterValue / 60;
      } else {
        targetValue = 24;
        targetUnit = local.hour(targetValue);
        counterValue = time.inHours;
        counterUnit = local.hour(counterValue);
        percentage = time.inMinutes.remainder(Duration.minutesPerDay) /
            Duration.minutesPerDay;
      }
    } else if (time.inDays < 30) {
      if (time.inDays < 7) {
        targetValue = 1;
        targetUnit = local.week(targetValue);
        counterValue = time.inDays % 7;
        counterUnit = local.day(counterValue);
        percentage = counterValue * 24 / (7 * 24);
      } else {
        targetValue = 1;
        targetUnit = local.month(targetValue);
        counterValue = time.inDays % 30;
        counterUnit = local.day(counterValue);
        percentage = counterValue * 24 / (30 * 24);
      }
    } else if (time.inDays ~/ 30 < 12) {
      targetValue = (time.inDays ~/ 30) + 1;
      targetUnit = local.month(targetValue);
      counterValue = ((time.inDays % 360) ~/ 30);
      counterUnit = local.month(counterValue);
      percentage = time.inDays / (targetValue * 30);
    } else {
      targetValue = (time.inDays ~/ 360) + 1;
      if (time.inDays / 360 < 1) {
        targetUnit = local.year(targetValue);
        counterValue = (time.inDays ~/ 30);
        counterUnit = local.month(counterValue);
        percentage = time.inDays / 360;
      } else {
        targetUnit = local.year(targetValue);
        counterValue = (time.inDays ~/ 360);
        counterUnit = local.year(counterValue);
      }
      percentage = time.inDays / (360 * targetValue);
    }
  } // todo: do better, can be better

  @override
  void initState() {
    updatedDuration = widget.duration;
    Future.delayed(Duration.zero, () {
      final local = AppLocalizations.of(context);
      if (mounted) {
        setState(() {
          setValues(updatedDuration, local);
        });
      }
      Timer.periodic(
        Duration(seconds: refreshInterval),
        (timer) {
          if (mounted) {
            setState(() {
              updatedDuration =
                  updatedDuration + Duration(seconds: refreshInterval);
              setValues(updatedDuration, local);
            });
          } else {
            timer.cancel();
          }
        },
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return Center(
      child: Wrap(
        direction: Axis.vertical,
        spacing: 10,
        runSpacing: 10,
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          SizedBox.fromSize(
            size: Size.square(deviceSize.height * .15),
            child: Stack(
              fit: StackFit.expand,
              children: [
                TweenAnimationBuilder(
                    tween: Tween<double>(
                      begin: 0,
                      end: percentage,
                    ),
                    duration: Duration(milliseconds: 800),
                    builder: (_, value, _ch) {
                      return CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).accentColor,
                        ),
                        value: value,
                        strokeWidth:
                            Theme.of(context).textTheme.bodyText1.fontSize,
                        backgroundColor:
                            Theme.of(context).accentColor.withAlpha(100),
                      );
                    }),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        (percentage * 100).toStringAsFixed(1),
                        style: TextStyle(
                          fontSize:
                              Theme.of(context).textTheme.bodyText1.fontSize *
                                  1.3,
                          color: Theme.of(context).primaryColorLight,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '%',
                        style: TextStyle(
                          color: Theme.of(context).primaryColorLight,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            child: Text(
              (targetValue != null && targetUnit != null)
                  ? (targetValue.toString() + ' ' + targetUnit)
                  : '',
              style: TextStyle(
                color: Theme.of(context).hintColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
