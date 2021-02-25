import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_quit_addiction_app/extensions/string_extension.dart';
import 'package:flutter_quit_addiction_app/models/addiction_item_screen_args.dart';
import 'package:flutter_quit_addiction_app/providers/settings_provider.dart';
import 'package:flutter_quit_addiction_app/widgets/target_duration_indicator.dart';
import 'package:provider/provider.dart';

class AddictionProgress extends StatelessWidget {
  const AddictionProgress({
    Key key,
    @required this.local,
    @required this.unitCost,
    @required this.notUsedCount,
    @required this.consumptionType,
    @required this.abstinenceTime,
  }) : super(key: key);

  final AppLocalizations local;
  final double unitCost;
  final double notUsedCount;
  final String consumptionType;
  final Duration abstinenceTime;

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    return Container(
      height: deviceHeight * .25,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Flex(
            direction: Axis.vertical,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Flexible(
                flex: 1,
                child: Text(local.level.capitalizeWords() + '1'),
              ),
              Flexible(
                flex: 3,
                child: DefaultTextStyle(
                  style: TextStyle(
                    fontSize: Theme.of(context).textTheme.headline6.fontSize,
                    color: Theme.of(context).hintColor,
                    fontWeight: FontWeight.bold,
                  ),
                  child: unitCost == 0
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(local.savedFor.capitalizeFirstLetter()),
                            Text(
                              notUsedCount.toStringAsFixed(2) +
                                  ' ' +
                                  consumptionType,
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
                                (unitCost * notUsedCount).toStringAsFixed(2) +
                                    ' ' +
                                    settings.currency,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ],
          ),
          TargetDurationIndicator(duration: abstinenceTime),
        ],
      ),
    );
  }
}
