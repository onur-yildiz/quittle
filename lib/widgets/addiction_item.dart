import 'package:flutter/material.dart';
import 'package:flutter_quit_addiction_app/providers/addiction.dart';
import 'package:flutter_quit_addiction_app/widgets/duration_counter.dart';
import 'package:flutter_quit_addiction_app/widgets/target_duration_indicator.dart';
import 'package:intl/intl.dart';

class AddictionItem extends StatelessWidget {
  const AddictionItem(
    this.addictionData,
  );

  final Addiction addictionData;

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    final quitDate = DateTime.parse(addictionData.quitDate);
    final formattedQuitDate = DateFormat('dd/MM/yyyy').format(quitDate);
    final abstinenceTime = DateTime.now().difference(quitDate);
    final notUsedFor = (addictionData.dailyConsumption *
        (abstinenceTime.inDays)); // TODO CHANGE notusedfor NAME
    final consumptionType =
        (addictionData.consumptionType == 1) ? 'Hours' : 'Times';

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          width: .5,
          color: Theme.of(context).hintColor,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 3,
            spreadRadius: 2,
            offset: Offset(0, 3),
          ),
        ],
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(5),
      ),
      height: deviceSize.height * .4,
      // padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            width: deviceSize.width * .4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    addictionData.name.toUpperCase(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: Theme.of(context).textTheme.headline6.fontSize,
                      color: Theme.of(context).primaryColorDark,
                    ),
                  ),
                ),
                TargetDurationIndicator(duration: abstinenceTime),
                // Container(
                //   child: Column(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: [
                //       Row(
                //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //         children: [
                //           Text('Since '),
                //           Text(formattedQuitDate),
                //         ],
                //       ),
                //       Row(
                //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //         children: [
                //           Text('For '),
                //           DurationCounter(duration: abstinenceTime),
                //         ],
                //       ),
                //     ],
                //   ),
                // )
              ],
            ),
          ),
          Container(
            width: deviceSize.width * .4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Daily Use:'),
                          Text(
                            (addictionData.dailyConsumption % 1 == 0
                                    ? addictionData.dailyConsumption
                                        .toStringAsFixed(0)
                                    : addictionData.dailyConsumption
                                        .toString()) +
                                ' ' +
                                consumptionType,
                          ),
                        ],
                      ),
                    ),
                    if (addictionData.unitCost > 0)
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Total ' + consumptionType + ' Saved'),
                            Text(
                              notUsedFor % 1 == 0
                                  ? notUsedFor.toStringAsFixed(0)
                                  : notUsedFor.toString(),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                if (addictionData.unitCost == 0)
                  DefaultTextStyle(
                    style: TextStyle(
                      fontSize: Theme.of(context).textTheme.headline6.fontSize,
                      color: Theme.of(context).primaryColorLight,
                      fontWeight: FontWeight.bold,
                    ),
                    child: Container(
                      height: deviceSize.height * .25,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Total ' + consumptionType + ' Saved'),
                          Text(
                            notUsedFor % 1 == 0
                                ? notUsedFor.toStringAsFixed(0)
                                : notUsedFor.toString(),
                          ),
                        ],
                      ),
                    ),
                  ),
                if (addictionData.unitCost > 0)
                  DefaultTextStyle(
                    style: TextStyle(
                      fontSize: Theme.of(context).textTheme.headline6.fontSize,
                      color: Theme.of(context).primaryColorLight,
                      fontWeight: FontWeight.bold,
                    ),
                    child: Container(
                      height: deviceSize.height * .25,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Money Saved',
                          ),
                          Text(
                            (addictionData.unitCost * notUsedFor).toString() +
                                ' \$',
                          )
                        ],
                      ),
                    ),
                  )
              ],
            ),
          )
        ],
      ),
    );
  }
}
