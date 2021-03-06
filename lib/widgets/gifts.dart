import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:reorderables/reorderables.dart';

import 'package:quittle/models/addiction.dart';
import 'package:quittle/models/gift.dart';
import 'package:quittle/providers/addictions_provider.dart';
import 'package:quittle/providers/settings_provider.dart';
import 'package:quittle/widgets/gifts_create.dart';

class Gifts extends StatefulWidget {
  final Addiction? data;

  Gifts({
    this.data,
  });

  @override
  _GiftsState createState() => _GiftsState();
}

class _GiftsState extends State<Gifts> {
  List<Widget>? _tiles;
  String? currency;

  List<Widget>? _getTiles(Addiction data) {
    _tiles = data.gifts!
        .map<Widget>(
          (gift) => GiftCard(
            gift: gift,
            availableMoney: data.availableMoney,
            dailyGain: (data.dailyConsumption * data.unitCost),
          ),
        )
        .toList()
          ..add(
            AddGiftButton(
              id: data.id,
            ),
          );
    return _tiles;
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (_tiles!.elementAt(oldIndex).runtimeType == AddGiftButton ||
          newIndex == _tiles!.length - 1) {
        return;
      }
      Provider.of<AddictionsProvider>(context, listen: false)
          .reorderGifts(oldIndex, newIndex, widget.data!.id);
    });
  }

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      setState(() {
        Provider.of<AddictionsProvider>(context, listen: false)
            .fetchGifts(widget.data!.id);
      });
    });
    currency = Provider.of<SettingsProvider>(context, listen: false).currency;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final local = AppLocalizations.of(context);
    final deviceSize = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Consumer<AddictionsProvider>(builder: (_, addictionsData, _ch) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: ReorderableWrap(
            direction: Axis.horizontal,
            scrollDirection: Axis.vertical,
            alignment: WrapAlignment.start,
            padding: EdgeInsets.symmetric(
              horizontal: deviceSize.width * .02,
            ),
            maxMainAxisCount: 2,
            spacing: deviceSize.width * .0399,
            runSpacing: deviceSize.width * .04,
            children: _getTiles(widget.data!)!,
            onReorder: _onReorder,
            needsLongPressDraggable: true,
            header: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      children: [
                        Text(
                          local!.available + ' ',
                          style: TextStyle(
                            color: t.hintColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          NumberFormat.simpleCurrency(
                            name: currency,
                            locale: local.localeName,
                          ).format(widget.data!.availableMoney),
                          style: TextStyle(
                            color: Colors.green[800],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          local.spent + ' ',
                          style: TextStyle(
                            color: t.hintColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          NumberFormat.simpleCurrency(
                            name: currency,
                            locale: local.localeName,
                          ).format(widget.data!.totalSpent),
                          style: TextStyle(
                            color: Colors.green[800],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      }),
    );
  }
}

class GiftCard extends StatefulWidget {
  const GiftCard({
    Key? key,
    required this.gift,
    required this.availableMoney,
    required this.dailyGain,
  }) : super(key: key);

  final Gift gift;
  final double availableMoney;
  final double dailyGain;

  @override
  _GiftCardState createState() => _GiftCardState();
}

class _GiftCardState extends State<GiftCard> {
  double? percentage;
  String? currency;

  @override
  void initState() {
    percentage = (widget.availableMoney / widget.gift.price!).clamp(0.0, 1.0);
    currency = Provider.of<SettingsProvider>(context, listen: false).currency;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant GiftCard oldWidget) {
    percentage = (widget.availableMoney / widget.gift.price!).clamp(0.0, 1.0);
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final local = AppLocalizations.of(context)!;
    final materialLocal = MaterialLocalizations.of(context);
    final deviceSize = MediaQuery.of(context).size;
    final giftPrice = NumberFormat.compactSimpleCurrency(
      name: currency,
      locale: local.localeName,
    ).format(widget.gift.price);
    final daysLeft =
        ((widget.gift.price! - widget.availableMoney) / widget.dailyGain);
    final daysLeftClamped = daysLeft.clamp(1, 365);

    _deleteDialog() {
      showDialog(
        context: context,
        builder: (context) => new AlertDialog(
          title: Text(
            local.areYouSure,
          ),
          content: Text(
            local.deleteGiftWarningMsg,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                materialLocal.cancelButtonLabel,
              ),
            ),
            TextButton(
              onPressed: () {
                Provider.of<AddictionsProvider>(context, listen: false)
                    .deleteGift(widget.gift);
                Navigator.of(context).pop();
              },
              child: Text(
                materialLocal.deleteButtonTooltip,
              ),
            ),
          ],
        ),
      );
    }

    return Stack(
      children: [
        SizedBox(
          height: deviceSize.width * .46,
          width: deviceSize.width * .46,
          child: Material(
            type: MaterialType.transparency,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
              side: BorderSide(
                width: 8,
                color: t.highlightColor,
              ),
            ),
            child: InkWell(
              onTap: () => showDialog(
                context: context,
                builder: (context) => new AlertDialog(
                  title: Text(
                    widget.availableMoney >= widget.gift.price!
                        ? local.purchaseGiftMsg(giftPrice, widget.gift.name!)
                        : local.notEnoughMoney,
                  ), //'Purchase \"${widget.gift.name!}\" for $giftPrice'
                  actions: [
                    widget.availableMoney >= widget.gift.price!
                        ? TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              materialLocal.cancelButtonLabel,
                            ),
                          )
                        : SizedBox.shrink(),
                    TextButton(
                      onPressed: () {
                        if (widget.availableMoney >= widget.gift.price!) {
                          Provider.of<AddictionsProvider>(context,
                                  listen: false)
                              .buyGift(widget.gift);
                        }
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        materialLocal.okButtonLabel,
                      ),
                    ),
                  ],
                ),
              ),
              child: DefaultTextStyle(
                style: t.textTheme.bodyText1!,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Flex(
                    mainAxisSize: MainAxisSize.max,
                    direction: Axis.vertical,
                    children: [
                      Flexible(
                        flex: 3,
                        fit: FlexFit.tight,
                        child: Text(
                          widget.gift.name!,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 2,
                        fit: FlexFit.tight,
                        child: Text(
                          giftPrice.toString(),
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 2,
                        fit: FlexFit.tight,
                        child: Text(
                          (daysLeft < 1 ? '>' : '') +
                              daysLeftClamped.toStringAsFixed(0) +
                              (daysLeft > 365 ? '+' : '') +
                              ' ' +
                              local.daysLeft(
                                daysLeftClamped.toInt(),
                              ),
                        ),
                      ),
                      Flexible(
                        flex: 2,
                        fit: FlexFit.tight,
                        child: Center(
                          child: Text(
                            widget.gift.count.toString() +
                                ' ' +
                                local.purchased,
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        child: Stack(
                          alignment: Alignment.center,
                          fit: StackFit.expand,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: LinearProgressIndicator(
                                backgroundColor: t.cardColor,
                                valueColor: AlwaysStoppedAnimation(
                                  t.accentColor.withOpacity(.8),
                                ),
                                value: percentage,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  (percentage! * 100)
                                          .toStringAsFixed(2)
                                          .padLeft(6) +
                                      "%",
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyText1!
                                        .color,
                                    fontWeight: percentage == 1
                                        ? FontWeight.w900
                                        : null,
                                    fontSize: Theme.of(context)
                                        .textTheme
                                        .subtitle2!
                                        .fontSize,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        child: Icon(
                          Icons.drag_handle_rounded,
                          color: t.highlightColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: Material(
            type: MaterialType.circle,
            color: Colors.transparent,
            child: InkWell(
              splashColor: t.errorColor,
              customBorder: CircleBorder(),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.delete,
                  color: t.errorColor.withOpacity(.8),
                  size: t.textTheme.headline6!.fontSize,
                ),
              ),
              onLongPress: _deleteDialog,
              onTap: _deleteDialog,
            ),
          ),
        ),
      ],
    );
  }
}

class AddGiftButton extends StatelessWidget {
  const AddGiftButton({required this.id});

  final String? id;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final deviceSize = MediaQuery.of(context).size;
    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: Container(
        height: deviceSize.width * .46,
        width: deviceSize.width * .46,
        color: t.highlightColor,
        child: Material(
          type: MaterialType.transparency,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
            side: BorderSide(
              width: 8,
              color: t.highlightColor,
            ),
          ),
          child: InkWell(
            onTap: () {
              showModalBottomSheet(
                backgroundColor: Colors.transparent,
                useRootNavigator: true,
                isScrollControlled: true,
                context: context,
                builder: (context) => CreateGift(addictionId: id),
              );
            },
            child: Center(
              child: Icon(
                Icons.add,
                size: t.textTheme.headline4!.fontSize,
                // color: t.hintColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
