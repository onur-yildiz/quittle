import 'package:flutter/material.dart';
import 'package:flutter_quit_addiction_app/models/addiction_item_screen_args.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_quit_addiction_app/extensions/string_extension.dart';
import 'package:flutter_quit_addiction_app/providers/settings_provider.dart';
import 'package:flutter_quit_addiction_app/widgets/addiction_details.dart';
import 'package:flutter_quit_addiction_app/widgets/personal_notes_view.dart';
import 'package:flutter_quit_addiction_app/widgets/target_duration_indicator.dart';
import 'package:provider/provider.dart';

const Duration _kExpand = Duration(milliseconds: 200);

class AddictionItem extends StatelessWidget {
  const AddictionItem({
    @required this.args,
  });

  final AddictionItemScreenArgs args;

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context);

    final deviceSize = MediaQuery.of(context).size;
    final deviceWidth = deviceSize.width;
    final deviceHeight = deviceSize.height -
        (kToolbarHeight + MediaQuery.of(context).padding.top);

    final titleHeight = deviceHeight * .05;
    final infoHeight = deviceHeight * .25;

    final quitDate = DateTime.parse(args.data.quitDate);
    final abstinenceTime = DateTime.now().difference(quitDate);
    final notUsedCount = (args.data.dailyConsumption * (abstinenceTime.inDays));
    final consumptionType = (args.data.consumptionType == 1)
        ? local.hour(notUsedCount.toInt())
        : local.times(notUsedCount.toInt());

    return SingleChildScrollView(
      child: AnimatedContainer(
        duration: _kExpand,
        curve: Curves.fastOutSlowIn,
        color: Theme.of(context).canvasColor,
        // margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 24.0),
              height: titleHeight,
              width: deviceWidth,
              alignment: Alignment.center,
              child: Text(
                args.data.name.toUpperCase(),
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: Theme.of(context).textTheme.headline5.fontSize,
                  color: Theme.of(context).hintColor,
                ),
              ),
            ),
            Divider(),
            Container(
              height: infoHeight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: deviceWidth * .5,
                    child: Flex(
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
                              fontSize: Theme.of(context)
                                  .textTheme
                                  .headline6
                                  .fontSize,
                              color: Theme.of(context).hintColor,
                              fontWeight: FontWeight.bold,
                            ),
                            child: args.data.unitCost == 0
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(local.savedFor
                                          .capitalizeFirstLetter()),
                                      Text(
                                        notUsedCount.toStringAsFixed(0) +
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
                                          (args.data.unitCost * notUsedCount)
                                                  .toStringAsFixed(2) +
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
                  ),
                  SizedBox(
                    width: deviceWidth * .5,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                          flex: 3,
                          child:
                              TargetDurationIndicator(duration: abstinenceTime),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            AddictionDetails(
              addictionData: args.data,
            ),
            PersonalNotesView(
              addictionData: args.data,
            ),
          ],
        ),
      ),
    );
  }
}
