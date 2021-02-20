import 'dart:async';

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
  var updatedDuration;
  var targetUnit;
  var targetValue;
  var counterUnit;
  var counterValue;
  var percentage;
  final refreshInterval = 15;

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

  void setValues(Duration time) {
    if (time.inHours < 24) {
      if (time.inHours < 1) {
        targetUnit = 'An Hour';
        counterUnit = 'Minutes';
        counterValue = time.inMinutes;
        percentage = counterValue / 60;
      } else {
        targetUnit = '24 Hours';
        counterUnit = 'Hours';
        counterValue = time.inHours;
        percentage = time.inMinutes.remainder(Duration.minutesPerDay) /
            Duration.minutesPerDay;
      }
      targetValue = null;
    } else if (time.inDays < 30) {
      if (time.inDays < 7) {
        targetUnit = 'A Week';
        counterUnit = 'Days';
        counterValue = time.inDays % 7;
        percentage = counterValue / 7;
      } else {
        targetUnit = 'A Month';
        counterUnit = 'Days';
        counterValue = time.inDays % 30;
        percentage = counterValue / 30;
      }
      targetValue = null;
    } else if (time.inDays ~/ 30 < 12) {
      targetUnit = 'Months';
      targetValue = (time.inDays ~/ 30) + 1;
      counterUnit = 'Months';
      counterValue = (time.inDays ~/ 30);
      percentage = time.inDays / (targetValue * 30);
    } else {
      if (time.inDays / 365 < 1) {
        targetUnit = 'Year';
        counterUnit = 'Months';
        counterValue = (time.inDays ~/ 30);
        percentage = time.inDays / 365;
      } else {
        targetUnit = 'Years';
        counterUnit = 'Years';
        counterValue = (time.inDays ~/ 365);
      }
      targetValue = (time.inDays ~/ 365) + 1;
      percentage = time.inDays / (365 * targetValue);
    }
  }

  @override
  void initState() {
    updatedDuration = widget.duration;
    setValues(updatedDuration);
    Timer.periodic(
      Duration(seconds: refreshInterval),
      (timer) {
        if (mounted) {
          setState(() {
            updatedDuration =
                updatedDuration + Duration(seconds: refreshInterval);
            setValues(updatedDuration);
          });
        } else {
          timer.cancel();
        }
      },
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return Container(
      // color: Colors.red,
      height: 140,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Stack(
            // alignment: Alignment.bottomCenter,
            children: [
              Center(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  height: 120,
                  width: 120,
                  child: CircularProgressIndicator(
                    value: percentage,
                    strokeWidth: Theme.of(context).textTheme.headline6.fontSize,
                    backgroundColor: Colors.white,
                  ),
                ),
              ),
              Center(
                child: SizedBox(
                  height: 120,
                  // width: deviceSize.width * .25,
                  child: Center(
                    child: Text(
                      counterValue.toString() + ' ' + counterUnit,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Container(
            child: Text(
                (targetValue != null ? (targetValue.toString() + ' ') : '') +
                    targetUnit),
          ),
        ],
      ),
    );
  }
}
