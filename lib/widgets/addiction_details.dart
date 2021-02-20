import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'duration_counter.dart';

class AddictionDetails extends StatefulWidget {
  const AddictionDetails({
    @required this.startDate,
    @required this.totalTime,
  });

  final DateTime startDate;
  final Duration totalTime;

  @override
  _AddictionDetailsState createState() => _AddictionDetailsState();
}

class _AddictionDetailsState extends State<AddictionDetails> {
  var formattedStartDate;

  @override
  void initState() {
    formattedStartDate = DateFormat('dd/MM/yyyy').format(widget.startDate);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Since '),
              Text(formattedStartDate),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('For '),
              DurationCounter(duration: widget.totalTime),
            ],
          ),
        ],
      ),
    );
  }
}
