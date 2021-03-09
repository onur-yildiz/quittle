import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import 'package:quittle/models/addiction.dart';
import 'package:quittle/providers/settings_provider.dart';
import 'package:quittle/widgets/duration_counter.dart';

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
    final currency = Provider.of<SettingsProvider>(context).currency;
    final String quitDateFormatted =
        DateFormat.yMMMd(local.localeName).format(addictionData.quitDateTime);
    final consumptionType = ((addictionData.consumptionType == 1)
        ? local.hour(
            notUsedCount.toInt(),
          )
        : local.times(
            notUsedCount.toInt(),
          ));

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
                Text(local.startDate),
                Text(quitDateFormatted),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(local.duration),
                DurationCounter(duration: abstinenceTime),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(local.dailyUse),
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
            Text(local.futureSavings),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(local.daily),
                Text(
                  NumberFormat.simpleCurrency(
                    name: currency,
                    locale: local.localeName,
                  ).format(dailySavings),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(local.weekly),
                Text(
                  NumberFormat.simpleCurrency(
                    name: currency,
                    locale: local.localeName,
                  ).format(dailySavings * 7),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(local.monthly),
                Text(
                  NumberFormat.simpleCurrency(
                    name: currency,
                    locale: local.localeName,
                  ).format(dailySavings * 30),
                ),
              ],
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(local.totalNotUsed),
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
