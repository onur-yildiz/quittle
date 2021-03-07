import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:quittle/extensions/string_extension.dart';
import 'package:quittle/models/addiction.dart';
import 'package:quittle/providers/settings_provider.dart';
import 'package:quittle/util/progress_constants.dart';
import 'package:quittle/widgets/target_duration_indicator.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DefaultTextStyle(
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).hintColor,
                  fontSize: Theme.of(context).textTheme.subtitle1.fontSize,
                ),
                child: Column(
                  children: [
                    Text(
                      local.level.capitalizeWords() +
                          ' ' +
                          (addictionData.level + 1).toString(),
                    ),
                    Text(
                      getLevelNames(local.localeName)[addictionData.level]
                          .capitalizeWords(),
                    )
                  ],
                ),
              ),
              Divider(
                color: Colors.transparent,
                thickness: 0,
              ),
              DefaultTextStyle(
                style: TextStyle(
                  fontSize: Theme.of(context).textTheme.subtitle1.fontSize,
                  color: Theme.of(context).hintColor,
                  fontWeight: FontWeight.bold,
                ),
                child: addictionData.unitCost == 0
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(local.savedFor.capitalizeFirstLetter()),
                          Text(
                            addictionData.consumptionType == 0
                                ? addictionData.notUsedCount.toStringAsFixed(2)
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
                            local.moneySaved.capitalizeWords(),
                          ),
                          Consumer<SettingsProvider>(
                            builder: (_, settings, _ch) => Text(
                              NumberFormat.simpleCurrency(
                                name: settings.currency,
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
            ],
          ),
          TargetDurationIndicator(
            data: addictionData,
            local: local,
          ),
        ],
      ),
    );
  }
}
