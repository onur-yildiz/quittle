import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_quit_addiction_app/extensions/string_extension.dart';

import 'package:flutter_quit_addiction_app/models/addiction.dart';
import 'package:flutter_quit_addiction_app/widgets/duration_counter.dart';

class AddictionDetails extends StatefulWidget {
  const AddictionDetails({
    @required this.addictionData,
    @required this.notUsedCount,
    @required this.abstinenceTime,
    @required this.quitDateFormatted,
  });

  final Addiction addictionData;
  final double notUsedCount;
  final Duration abstinenceTime;
  final String quitDateFormatted;

  @override
  _AddictionDetailsState createState() => _AddictionDetailsState();
}

class _AddictionDetailsState extends State<AddictionDetails> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context);
    final consumptionType = ((widget.addictionData.consumptionType == 1)
            ? local.hour(
                widget.notUsedCount.toInt(),
              )
            : local.times(
                widget.notUsedCount.toInt(),
              ))
        .capitalizeWords();

    return DefaultTextStyle(
      style: TextStyle(
        color: Theme.of(context).hintColor,
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
                Text(widget.quitDateFormatted),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(local.duration.capitalizeWords()),
                DurationCounter(duration: widget.abstinenceTime),
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
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     Text(local.savedFor.capitalizeWords()),
            //     Text(
            //       (notUsedCount % 1 == 0
            //               ? notUsedCount.toStringAsFixed(0)
            //               : notUsedCount.toString()) +
            //           ' ' +
            //           consumptionType,
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }
}
