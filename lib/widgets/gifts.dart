import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:quittle/extensions/string_extension.dart';
import 'package:quittle/models/addiction.dart';
import 'package:quittle/models/gift.dart';
import 'package:quittle/providers/addictions_provider.dart';
import 'package:quittle/providers/settings_provider.dart';
import 'package:quittle/widgets/gifts_create.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:reorderables/reorderables.dart';

class Gifts extends StatefulWidget {
  final String id;

  Gifts({
    this.id,
  });

  @override
  _GiftsState createState() => _GiftsState();
}

class _GiftsState extends State<Gifts> {
  List<Widget> _tiles;

  List<Widget> _getTiles(Addiction data) {
    _tiles = data.gifts
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
      if (_tiles.elementAt(oldIndex).runtimeType == AddGiftButton ||
          newIndex == _tiles.length - 1) {
        return;
      }
      Provider.of<AddictionsProvider>(context, listen: false)
          .reorderGifts(oldIndex, newIndex, widget.id);
    });
  }

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      setState(() {
        Provider.of<AddictionsProvider>(context, listen: false)
            .fetchGifts(widget.id);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context);
    final deviceSize = MediaQuery.of(context).size;
    final currency =
        Provider.of<SettingsProvider>(context, listen: false).currency;

    return SingleChildScrollView(
      child: Consumer<AddictionsProvider>(builder: (_, addictionsData, _ch) {
        final addictionData = addictionsData.addictions
            .firstWhere((addiction) => addiction.id == widget.id);
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
            children: _getTiles(addictionData ?? []),
            onReorder: _onReorder,
            needsLongPressDraggable: true,
            header: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    children: [
                      Text(
                        local.available.capitalizeWords() + ' ',
                        style: TextStyle(
                          color: Theme.of(context).hintColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        NumberFormat.simpleCurrency(
                          name: currency,
                        ).format(addictionData.availableMoney),
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
                        local.spent.capitalizeWords() + ' ',
                        style: TextStyle(
                          color: Theme.of(context).hintColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        NumberFormat.simpleCurrency(
                          name: currency,
                        ).format(addictionData.totalSpent),
                        style: TextStyle(
                          color: Colors.green[800],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}

class GiftCard extends StatelessWidget {
  const GiftCard({
    Key key,
    @required this.gift,
    @required this.availableMoney,
    @required this.dailyGain,
  }) : super(key: key);

  final Gift gift;
  final double availableMoney;
  final double dailyGain;

  Path drawSquare(double size) {
    final path = Path();
    path.lineTo(size, 0);
    path.lineTo(size, size);
    path.lineTo(0, size);
    path.lineTo(0, 0);
    return path;
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context);
    final materialLocal = MaterialLocalizations.of(context);
    final deviceSize = MediaQuery.of(context).size;
    final currency =
        Provider.of<SettingsProvider>(context, listen: false).currency;
    final giftPrice = NumberFormat.compactSimpleCurrency(
      name: currency,
    ).format(gift.price);
    final daysLeft = ((gift.price - availableMoney) / dailyGain);
    final daysLeftClamped = daysLeft.clamp(1, 365);
    final percentage = (availableMoney / gift.price).clamp(0.0, 1.0);

    _deleteDialog() {
      showDialog(
        context: context,
        builder: (context) => new AlertDialog(
          title: Text(
            local.areYouSure.capitalizeFirstLetter(),
          ),
          content: Text(
            local.deleteGiftWarningMsg.capitalizeFirstLetter(),
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
                    .deleteGift(gift);
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

    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      clipBehavior: Clip.hardEdge,
      child: Stack(
        children: [
          LiquidCustomProgressIndicator(
            direction: Axis.vertical,
            shapePath: drawSquare(deviceSize.width * .46),
            backgroundColor: Colors.black38,
            value: percentage,
            valueColor: AlwaysStoppedAnimation(
              Theme.of(context).accentColor,
            ),
            center: Material(
              // type: MaterialType.transparency,
              color: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
                side: BorderSide(
                  width: 8,
                  color: Theme.of(context).highlightColor,
                ),
              ),
              child: InkWell(
                onTap: () => showDialog(
                  context: context,
                  builder: (context) => new AlertDialog(
                    title: Text(
                      availableMoney >= gift.price
                          ? local
                              .purchaseGiftMsg(giftPrice, gift.name)
                              .capitalizeFirstLetter()
                          : 'Not enough money available.', //TODO localize
                    ), //'Purchase \"${widget.gift.name}\" for $giftPrice'
                    actions: [
                      availableMoney >= gift.price
                          ? TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                materialLocal.cancelButtonLabel,
                              ),
                            )
                          : null,
                      TextButton(
                        onPressed: () {
                          if (availableMoney >= gift.price) {
                            Provider.of<AddictionsProvider>(context,
                                    listen: false)
                                .buyGift(gift);
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
                  style: TextStyle(
                    // fontWeight: FontWeight.bold,
                    color: Theme.of(context).cardColor,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Flex(
                      mainAxisSize: MainAxisSize.max,
                      direction: Axis.vertical,
                      children: [
                        Flexible(
                          flex: 6,
                          fit: FlexFit.tight,
                          child: Text(
                            gift.name,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 6,
                          fit: FlexFit.tight,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                (percentage * 100).toStringAsFixed(2),
                                style: TextStyle(
                                  fontWeight:
                                      percentage == 1 ? FontWeight.w900 : null,
                                  fontSize: Theme.of(context)
                                      .textTheme
                                      .headline6
                                      .fontSize,
                                ),
                              ),
                              Text(
                                '%',
                                style: TextStyle(
                                  fontWeight:
                                      percentage == 1 ? FontWeight.w900 : null,
                                  fontSize: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      .fontSize,
                                ),
                              ),
                            ],
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
                              gift.count.toString() +
                                  ' Purchased', //TODO localize
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 2,
                          child: Icon(
                            Icons.drag_handle_rounded,
                            color: Theme.of(context).highlightColor,
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
                splashColor: Theme.of(context).errorColor,
                customBorder: CircleBorder(),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.delete,
                    color: Theme.of(context).errorColor.withOpacity(.8),
                    size: Theme.of(context).textTheme.headline6.fontSize,
                  ),
                ),
                onLongPress: _deleteDialog,
                onTap: _deleteDialog,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AddGiftButton extends StatelessWidget {
  const AddGiftButton({@required this.id});

  final String id;

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: Container(
        height: deviceSize.width * .46,
        width: deviceSize.width * .46,
        color: Theme.of(context).highlightColor,
        child: Material(
          type: MaterialType.transparency,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
            side: BorderSide(
              width: 8,
              color: Theme.of(context).highlightColor,
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
                size: Theme.of(context).textTheme.headline4.fontSize,
                color: Theme.of(context).hintColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
