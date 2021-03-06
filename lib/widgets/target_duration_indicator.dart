import 'dart:async';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:flutter/material.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

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
  Timer timer;
  Duration updatedDuration;
  String targetUnit = '';
  int targetValue = 0;
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
        percentage = time.inMinutes / 60;
      } else {
        targetValue = 24;
        targetUnit = local.hour(targetValue);
        percentage = time.inMinutes.remainder(Duration.minutesPerDay) /
            Duration.minutesPerDay;
      }
    } else if (time.inDays < 30) {
      if (time.inDays < 7) {
        targetValue = 1;
        targetUnit = local.week(targetValue);
        percentage = (time.inDays % 7) * 24 / (7 * 24);
      } else {
        targetValue = 1;
        targetUnit = local.month(targetValue);
        percentage = (time.inDays % 30) * 24 / (30 * 24);
      }
    } else if (time.inDays ~/ 30 < 12) {
      targetValue = (time.inDays ~/ 30) + 1;
      targetUnit = local.month(targetValue);
      percentage = time.inDays / (targetValue * 30);
    } else {
      targetValue = (time.inDays ~/ 360) + 1;
      if (time.inDays / 360 < 1) {
        targetUnit = local.year(targetValue);
        percentage = time.inDays / 360;
      } else {
        targetUnit = local.year(targetValue);
        percentage = time.inDays / (360 * targetValue);
      }
    }
  } // TODO: do better, can be better

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
      timer = Timer.periodic(
        Duration(seconds: refreshInterval),
        (timer) {
          if (mounted) {
            setState(() {
              updatedDuration =
                  updatedDuration + Duration(seconds: refreshInterval);
              setValues(updatedDuration, local);
            });
          }
        },
      );
    });
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SleekCircularSlider(
      appearance: CircularSliderAppearance(
        infoProperties: InfoProperties(
          bottomLabelText: targetValue.toString() + ' ' + targetUnit,
          bottomLabelStyle: TextStyle(
            color: Theme.of(context).hintColor,
            fontWeight: FontWeight.bold,
          ),
          mainLabelStyle: TextStyle(
            color: Theme.of(context).primaryColor,
            fontSize: Theme.of(context).textTheme.headline5.fontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
        customWidths: CustomSliderWidths(
          handlerSize: 0,
          progressBarWidth: Theme.of(context).textTheme.bodyText1.fontSize,
          trackWidth: Theme.of(context).textTheme.bodyText1.fontSize,
        ),
        customColors: CustomSliderColors(
          hideShadow: true,
          progressBarColors: [
            Theme.of(context).accentColor,
            Theme.of(context).accentColor.withOpacity(.5),
          ],
          trackColor: Theme.of(context).accentColor.withAlpha(100),
        ),
      ),
      min: 0,
      max: 100,
      initialValue: percentage * 100,
    );
  }
}
