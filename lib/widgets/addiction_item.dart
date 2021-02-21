import 'package:flutter/material.dart';
import 'package:flutter_quit_addiction_app/models/addiction.dart';
import 'package:flutter_quit_addiction_app/providers/refresh.dart';
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
  var expansionHeight = 0.0;

  void _changeExpansion(bool isExpanded, double deviceHeight) {
    setState(() {
      isExpanded ? expansionHeight = deviceHeight * .5 : expansionHeight = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final expansionTileTheme = Theme.of(context).copyWith(
      dividerColor: Colors.transparent,
      accentColor: Theme.of(context).primaryColorDark,
      buttonColor: Theme.of(context).accentColor,
      textTheme: TextTheme(
        subtitle1: TextStyle(
          color: Theme.of(context).primaryColorLight,
          fontWeight: FontWeight.w800,
        ),
      ),
    );

    final deviceSize = MediaQuery.of(context).size;
    final deviceWidth = deviceSize.width;
    final deviceHeight = deviceSize.height -
        (kToolbarHeight + MediaQuery.of(context).padding.top);

    final quitDate = DateTime.parse(widget.addictionData.quitDate);
    final abstinenceTime = DateTime.now().difference(quitDate);
    final notUsedCount =
        (widget.addictionData.dailyConsumption * (abstinenceTime.inDays));
    final consumptionType =
        (widget.addictionData.consumptionType == 1) ? 'Hours' : 'Times';

    return AnimatedContainer(
      duration: _kExpand,
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
      height: deviceHeight * .4 +
          expansionHeight +
          20, // 20 = (titlemargin) + (dividerpadding)
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 5),
            height: deviceHeight * .05,
            alignment: Alignment.center,
            child: Text(
              widget.addictionData.name.toUpperCase(),
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: Theme.of(context).textTheme.headline5.fontSize,
                color: Theme.of(context).primaryColorDark,
              ),
            ),
          ),
          Container(
            height: deviceHeight * .25,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
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
                // Todo column
                Flex(
                  direction: Axis.vertical,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Flexible(
                      flex: 1,
                      child: Text('LEVEL 1'),
                    ),
                    Flexible(
                      flex: 3,
                      child: DefaultTextStyle(
                        style: TextStyle(
                          fontSize:
                              Theme.of(context).textTheme.headline6.fontSize,
                          color: Theme.of(context).primaryColorLight,
                          fontWeight: FontWeight.bold,
                        ),
                        child: widget.addictionData.unitCost == 0
                            ? Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('Total ' + consumptionType + ' Saved'),
                                    Text(
                                      notUsedCount % 1 == 0
                                          ? notUsedCount.toStringAsFixed(0)
                                          : notUsedCount.toString(),
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
                                      'Money Saved',
                                    ),
                                    Text(
                                      (widget.addictionData.unitCost *
                                                  notUsedCount)
                                              .toString() +
                                          ' \$',
                                    )
                                  ],
                                ),
                              ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Divider(
              height: 0,
              color: Theme.of(context).accentColor,
              thickness: .5,
            ),
          ),
          Container(
            child: DefaultTabController(
              length: 2,
              initialIndex: 0,
              child: Theme(
                data: expansionTileTheme,
                child: ExpansionTile(
                  backgroundColor: Theme.of(context).cardColor,
                  onExpansionChanged: (isExpanded) {
                    _changeExpansion(isExpanded, deviceHeight);
                  },
                  title: Text('More'),
                  children: [
                    SizedBox(
                      height: expansionHeight,
                      child: Column(
                        children: [
                          Flexible(
                            flex: 0,
                            child: TabBar(
                              labelPadding: const EdgeInsets.all(8.0),
                              labelColor: Theme.of(context).primaryColorDark,
                              indicatorWeight: 3,
                              indicatorColor:
                                  Theme.of(context).primaryColor.withAlpha(150),
                              tabs: [
                                Text(
                                  'Details',
                                ),
                                InkWell(
                                  child: Text(
                                    'Notes',
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
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: AddictionDetails(
                                      addictionData: widget.addictionData,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(0),
                                    child: PersonalNotesView(
                                      addictionData: widget.addictionData,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
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
