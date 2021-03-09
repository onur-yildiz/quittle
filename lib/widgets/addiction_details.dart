import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:quittle/extensions/string_extension.dart';

import 'package:quittle/models/addiction.dart';
import 'package:quittle/widgets/duration_counter.dart';
import 'package:intl/intl.dart';

class AddictionDetails extends StatelessWidget {
  const AddictionDetails({
    @required this.addictionData,
  });

  final Addiction addictionData;

  @override
  Widget build(BuildContext context) {
    final double notUsedCount = addictionData.notUsedCount;
    final Duration abstinenceTime = addictionData.abstinenceTime;
    final double dailySavings =
        addictionData.dailyConsumption * addictionData.unitCost;
    final local = AppLocalizations.of(context);
    final String quitDateFormatted =
        DateFormat.yMMMd(local.localeName).format(addictionData.quitDateTime);
    final consumptionType = ((addictionData.consumptionType == 1)
            ? local.hour(
                notUsedCount.toInt(),
              )
            : local.times(
                notUsedCount.toInt(),
              ))
        .capitalizeWords();

    return DefaultTextStyle(
      style: Theme.of(context).textTheme.bodyText2.copyWith(
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
                  (addictionData.dailyConsumption % 1 == 0
                          ? addictionData.dailyConsumption.toStringAsFixed(0)
                          : addictionData.dailyConsumption.toString()) +
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
                Text('weekly'),
                Text(
                  NumberFormat.simpleCurrency(locale: local.localeName)
                      .format(dailySavings * 7),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('monthly'),
                Text(
                  NumberFormat.simpleCurrency(locale: local.localeName)
                      .format(dailySavings * 30),
                ),
              ],
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('not used total'),
                Text(
                  addictionData.consumptionType == 1
                      ? addictionData.notUsedCount.toStringAsFixed(0)
                      : addictionData.notUsedCount.toStringAsFixed(1) +
                          ' ' +
                          consumptionType,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
