import 'dart:async';

import 'package:flutter/material.dart';

class DurationCounter extends StatefulWidget {
  const DurationCounter({
    required this.duration,
  });

  final Duration duration;

  @override
  _DurationCounterState createState() => _DurationCounterState();
}

class _DurationCounterState extends State<DurationCounter> {
  String durationAsString = '';
  late Duration updatedDuration;

  String durationString(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitHours = twoDigits(duration.inHours.remainder(24));
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return '${duration.inDays} | $twoDigitHours:$twoDigitMinutes:$twoDigitSeconds';
  }

  @override
  void initState() {
    updatedDuration = widget.duration;
    durationAsString = durationString(updatedDuration);

    Timer.periodic(Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          updatedDuration = updatedDuration + Duration(seconds: 1);
          durationAsString = durationString(updatedDuration);
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      durationAsString,
    );
  }
}
