import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:flutter/material.dart';
import 'package:quittle/models/addiction.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class TargetDurationIndicator extends StatelessWidget {
  TargetDurationIndicator({
    @required this.data,
    @required this.local,
  });

  final Addiction data;
  final AppLocalizations local;

  @override
  Widget build(BuildContext context) {
    final Duration time = data.abstinenceTime;
    String targetUnit;
    int targetValue;
    double percentage;

    if (time.inHours < 24) {
      if (time.inHours < 1) {
        targetValue = 1;
        targetUnit = local.hour(1);
        percentage = time.inMinutes / Duration.minutesPerHour;
      } else {
        targetValue = 24;
        targetUnit = local.hour(targetValue);
        percentage = time.inMinutes / Duration.minutesPerDay;
      }
    } else if (time.inDays < 30) {
      if (time.inDays < 3) {
        targetValue = 3;
        targetUnit = local.day(targetValue);
        percentage = time.inMinutes / (3 * Duration.minutesPerDay);
      } else if (time.inDays < 7) {
        targetValue = 1;
        targetUnit = local.week(targetValue);
        percentage = time.inMinutes / (7 * Duration.minutesPerDay);
      } else {
        targetValue = 1;
        targetUnit = local.month(targetValue);
        percentage = time.inMinutes / (30 * Duration.minutesPerDay);
      }
    } else if (time.inDays ~/ 30 < 12) {
      targetValue = (time.inDays ~/ 30) + 1;
      targetUnit = local.month(targetValue);
      percentage = time.inMinutes / (targetValue * 30 * Duration.minutesPerDay);
    } else {
      targetValue = (time.inDays ~/ 360) + 1;
      if (time.inDays / 360 < 1) {
        targetUnit = local.year(targetValue);
        percentage = time.inMinutes / 360 * Duration.minutesPerDay;
      } else {
        targetUnit = local.year(targetValue);
        percentage =
            time.inMinutes / (360 * Duration.minutesPerDay * targetValue);
      }
    }

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
        animationEnabled: false,
      ),
      min: 0,
      max: 100,
      initialValue: percentage * 100,
    );
  }
}
