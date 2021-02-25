import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_quit_addiction_app/extensions/string_extension.dart';
import 'package:flutter_quit_addiction_app/models/addiction.dart';
import 'package:flutter_quit_addiction_app/models/addiction_item_screen_args.dart';
import 'package:flutter_quit_addiction_app/providers/settings_provider.dart';
import 'package:flutter_quit_addiction_app/screens/addiction_item_screen.dart';
import 'package:flutter_quit_addiction_app/widgets/addiction_progress.dart';
import 'package:flutter_quit_addiction_app/widgets/target_duration_indicator.dart';
import 'package:provider/provider.dart';

const Duration _kExpand = Duration(milliseconds: 200);

class AddictionItem extends StatefulWidget {
  const AddictionItem({
    @required this.addictionData,
    Key key,
  }) : super(key: key);

  final Addiction addictionData;

  @override
  _AddictionItemState createState() => _AddictionItemState();
}

class _AddictionItemState extends State<AddictionItem> {
  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context);

    final deviceSize = MediaQuery.of(context).size;
    final deviceWidth = deviceSize.width;
    final deviceHeight = deviceSize.height -
        (kToolbarHeight + MediaQuery.of(context).padding.top);

    final quitDate = DateTime.parse(widget.addictionData.quitDate);
    final abstinenceTime = DateTime.now().difference(quitDate);
    final notUsedCount =
        ((widget.addictionData.dailyConsumption / Duration.hoursPerDay) *
            (abstinenceTime.inHours));
    final consumptionType = (widget.addictionData.consumptionType == 1)
        ? local.hour(notUsedCount.toInt())
        : local.times(notUsedCount.toInt());

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Material(
        type: MaterialType.card,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
          side: BorderSide(
            width: 1,
            color: Theme.of(context).highlightColor,
          ),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(5),
          onTap: () {
            Navigator.of(context).pushNamed(
              AddictionItemScreen.routeName,
              arguments: AddictionItemScreenArgs(widget.addictionData),
            );
          },
          child: AnimatedContainer(
            duration: _kExpand,
            curve: Curves.fastOutSlowIn,
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 8.0),
                  height: deviceHeight * .05,
                  width: deviceWidth * .4,
                  alignment: Alignment.center,
                  child: Text(
                    widget.addictionData.name.toUpperCase(),
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: Theme.of(context).textTheme.headline5.fontSize,
                      color: Theme.of(context).hintColor,
                    ),
                  ),
                ),
                AddictionProgress(
                  local: local,
                  unitCost: widget.addictionData.unitCost,
                  notUsedCount: notUsedCount,
                  consumptionType: consumptionType,
                  abstinenceTime: abstinenceTime,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
