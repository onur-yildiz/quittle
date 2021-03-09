import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:quittle/models/addiction.dart';
import 'package:quittle/providers/settings_provider.dart';
import 'package:quittle/util/progress_constants.dart';
import 'package:quittle/widgets/target_duration_indicator.dart';

class AddictionProgress extends StatelessWidget {
  const AddictionProgress({
    Key key,
    @required this.addictionData,
  }) : super(key: key);

  final Addiction addictionData;

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context);
    final consumptionType = (addictionData.consumptionType == 1)
        ? local.hour(addictionData.notUsedCount.toInt())
        : local.times(addictionData.notUsedCount.toInt());
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Flex(
        direction: Axis.horizontal,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DefaultTextStyle(
                  style: Theme.of(context).textTheme.bodyText1.copyWith(
                        fontSize:
                            Theme.of(context).textTheme.subtitle1.fontSize,
                        fontWeight: FontWeight.bold,
                      ),
                  child: Column(
                    children: [
                      Text(
                        local.level +
                            ' ' +
                            (addictionData.level + 1).toString(),
                      ),
                      Text(
                        getLevelNames(local.localeName)[addictionData.level],
                      )
                    ],
                  ),
                ),
                Divider(
                  color: Colors.transparent,
                  thickness: 0,
                ),
                DefaultTextStyle(
                  style: Theme.of(context).textTheme.bodyText1.copyWith(
                        fontSize:
                            Theme.of(context).textTheme.subtitle1.fontSize,
                        fontWeight: FontWeight.bold,
                      ),
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: addictionData.unitCost == 0
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(local.savedFor),
                              Text(
                                addictionData.consumptionType == 0
                                    ? addictionData.notUsedCount
                                        .toStringAsFixed(2)
                                    : addictionData.notUsedCount
                                            .toStringAsFixed(0) +
                                        ' ' +
                                        consumptionType,
                                style: TextStyle(
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                local.moneySaved,
                              ),
                              Consumer<SettingsProvider>(
                                builder: (_, settings, _ch) => Text(
                                  NumberFormat.simpleCurrency(
                                    name: settings.currency,
                                    locale: local.localeName,
                                    decimalDigits: 2,
                                  ).format(
                                    addictionData.totalSaved,
                                  ),
                                  style: TextStyle(
                                    color: Colors.green[800],
                                  ),
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ],
            ),
          ),
          Flexible(
            flex: 2,
            child: TargetDurationIndicator(
              data: addictionData,
              local: local,
            ),
          ),
        ],
      ),
    );
  }
}
