import 'package:flutter/material.dart';

extension TimeOfDayExtension on TimeOfDay {
  Duration get asDuration {
    return Duration(hours: this.hour, minutes: this.minute);
  }
}
