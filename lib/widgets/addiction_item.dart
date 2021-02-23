import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_quit_addiction_app/extensions/string_extension.dart';
import 'package:flutter_quit_addiction_app/models/addiction.dart';
import 'package:flutter_quit_addiction_app/providers/settings.dart';
import 'package:flutter_quit_addiction_app/widgets/personal_notes_view.dart';
import 'package:flutter_quit_addiction_app/widgets/target_duration_indicator.dart';
import 'package:provider/provider.dart';

import 'addiction_details.dart';

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
  var _isPanelExpanded = false;

  @override
  void didUpdateWidget(covariant AddictionItem oldWidget) {
    _isPanelExpanded = false;
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context);
    final expansionTileTheme = Theme.of(context).copyWith(
      textTheme: TextTheme(
        bodyText2: TextStyle(
          color: Theme.of(context).primaryColorLight,
          fontWeight: FontWeight.w500,
        ),
      ),
    );

    final deviceSize = MediaQuery.of(context).size;
    final deviceWidth = deviceSize.width;
    final deviceHeight = deviceSize.height -
        (kToolbarHeight + MediaQuery.of(context).padding.top);
    final expansionHeight = deviceHeight * .5;

    final quitDate = DateTime.parse(widget.addictionData.quitDate);
    final abstinenceTime = DateTime.now().difference(quitDate);
    final notUsedCount =
        (widget.addictionData.dailyConsumption * (abstinenceTime.inDays));
    final consumptionType = (widget.addictionData.consumptionType == 1)
        ? local.hour(notUsedCount.toInt())
        : local.times(notUsedCount.toInt());

    return AnimatedContainer(
      duration: _kExpand,
      curve: Curves.fastOutSlowIn,
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
        color: Theme.of(context).canvasColor,
        borderRadius: BorderRadius.circular(5),
      ),
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
                // color: Theme.of(context).hintColor,
              ),
            ),
          ),
          Container(
            height: deviceHeight * .25,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: deviceWidth * .4,
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
                            fontSize:
                                Theme.of(context).textTheme.headline6.fontSize,
                            color: Theme.of(context).hintColor,
                            fontWeight: FontWeight.bold,
                          ),
                          child: widget.addictionData.unitCost == 0
                              ? Container(
                                  child: Column(
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
                                  ),
                                )
                              : Container(
                                  height: deviceHeight * .2,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        local.moneySaved.capitalizeWords(),
                                      ),
                                      Consumer<Settings>(
                                        builder: (_, settings, _ch) => Text(
                                          (widget.addictionData.unitCost *
                                                      notUsedCount)
                                                  .toStringAsFixed(2) +
                                              ' ' +
                                              settings.currency,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  width: deviceWidth * .4,
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
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: DefaultTabController(
              length: 2,
              initialIndex: 0,
              child: Theme(
                data: expansionTileTheme,
                child: ExpansionPanelList(
                  animationDuration: _kExpand,
                  expandedHeaderPadding: EdgeInsets.zero,
                  elevation: 0,
                  expansionCallback: (panelIndex, isExpanded) {
                    setState(() {
                      _isPanelExpanded = !isExpanded;
                    });
                  },
                  children: [
                    ExpansionPanel(
                      headerBuilder: (context, isExpanded) {
                        return Container(
                          height: deviceHeight * .1,
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            local.more.capitalizeWords(),
                            style: TextStyle(
                              fontSize: Theme.of(context)
                                  .textTheme
                                  .headline6
                                  .fontSize,
                            ),
                          ),
                        );
                      },
                      canTapOnHeader: true,
                      isExpanded: _isPanelExpanded,
                      body: SizedBox(
                        height: expansionHeight,
                        child: Column(
                          children: [
                            Flexible(
                              flex: 0,
                              child: TabBar(
                                labelPadding: const EdgeInsets.all(8.0),
                                labelColor: Theme.of(context).primaryColorDark,
                                labelStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                                indicatorWeight: 3,
                                indicatorColor: Theme.of(context).primaryColor,
                                tabs: [
                                  Text(
                                    local.details.capitalizeWords(),
                                  ),
                                  InkWell(
                                    child: Text(
                                      local.notes.capitalizeWords(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Flexible(
                              flex: 1,
                              child: Container(
                                child: TabBarView(
                                  children: [
                                    AddictionDetails(
                                      addictionData: widget.addictionData,
                                    ),
                                    PersonalNotesView(
                                      addictionData: widget.addictionData,
                                    ),
                                  ],
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
            ),
          ),
        ],
      ),
    );
  }
}
