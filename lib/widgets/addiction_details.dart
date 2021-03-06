import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:quittle/extensions/string_extension.dart';

import 'package:quittle/models/addiction.dart';
import 'package:quittle/widgets/duration_counter.dart';
import 'package:intl/intl.dart';

class AddictionDetails extends StatefulWidget {
  const AddictionDetails({
    @required this.addictionData,
  });

  final Addiction addictionData;

  @override
  _AddictionDetailsState createState() => _AddictionDetailsState();
}

class _AddictionDetailsState extends State<AddictionDetails> {
  double notUsedCount;
  Duration abstinenceTime;
  String quitDateFormatted;
  double dailySavings = 0;

  @override
  void initState() {
    notUsedCount = widget.addictionData.notUsedCount;
    abstinenceTime = widget.addictionData.abstinenceTime;
    dailySavings =
        widget.addictionData.dailyConsumption * widget.addictionData.unitCost;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context);
    quitDateFormatted = DateFormat.yMMMd(local.localeName)
        .format(widget.addictionData.quitDateTime);
    final consumptionType = ((widget.addictionData.consumptionType == 1)
            ? local.hour(
                notUsedCount.toInt(),
              )
            : local.times(
                notUsedCount.toInt(),
              ))
        .capitalizeWords();

    return DefaultTextStyle(
      style: TextStyle(
        color: Theme.of(context).canvasColor,
        fontWeight: FontWeight.bold,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Wrap(
          direction: Axis.horizontal,
          alignment: WrapAlignment.spaceBetween,
          runSpacing: 8.0,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(local.startDate.capitalizeWords()),
                Text(quitDateFormatted),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(local.duration.capitalizeWords()),
                DurationCounter(duration: abstinenceTime),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(local.dailyUse.capitalizeWords()),
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
            Divider(),
            Text('future savings'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('daily'),
                Text(
                  NumberFormat.simpleCurrency(locale: local.localeName)
                      .format(dailySavings),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('next week'),
                Text(
                  NumberFormat.simpleCurrency(locale: local.localeName)
                      .format(dailySavings * 7),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('next month'),
                Text(
                  NumberFormat.simpleCurrency(locale: local.localeName)
                      .format(dailySavings * 30),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
