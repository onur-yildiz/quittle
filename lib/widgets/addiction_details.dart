import 'package:flutter/material.dart';
import 'package:flutter_quit_addiction_app/models/addiction.dart';
import 'package:intl/intl.dart';

import 'duration_counter.dart';

class AddictionDetails extends StatefulWidget {
  const AddictionDetails({
    @required this.addictionData,
  });

  final Addiction addictionData;

  @override
  _AddictionDetailsState createState() => _AddictionDetailsState();
}

class _AddictionDetailsState extends State<AddictionDetails> {
  var formattedStartDate;
  var quitDate;
  var abstinenceTime;
  var consumptionType;
  var notUsedCount;
  @override
  void initState() {
    quitDate = DateTime.parse(widget.addictionData.quitDate);
    abstinenceTime = DateTime.now().difference(quitDate);
    formattedStartDate = DateFormat('dd/MM/yyyy').format(quitDate);
    consumptionType =
        (widget.addictionData.consumptionType == 1) ? 'Hours' : 'Times';
    notUsedCount =
        (widget.addictionData.dailyConsumption * (abstinenceTime.inDays));
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
              DurationCounter(duration: abstinenceTime),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Daily Use:'),
              Text(
                (widget.addictionData.dailyConsumption % 1 == 0
                        ? widget.addictionData.dailyConsumption
                            .toStringAsFixed(0)
                        : widget.addictionData.dailyConsumption.toString()) +
                    ' ' +
                    consumptionType,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total ' + consumptionType + ' Saved'),
              Text(
                notUsedCount % 1 == 0
                    ? notUsedCount.toStringAsFixed(0)
                    : notUsedCount.toString(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
