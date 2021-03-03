import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_quit_addiction_app/extensions/string_extension.dart';
import 'package:flutter_quit_addiction_app/helpers/db_helper.dart';
import 'package:flutter_quit_addiction_app/models/addiction.dart';
import 'package:flutter_quit_addiction_app/models/gift.dart';
import 'package:flutter_quit_addiction_app/providers/addictions_provider.dart';
import 'package:flutter_quit_addiction_app/providers/settings_provider.dart';
import 'package:flutter_quit_addiction_app/widgets/gifts_create.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:reorderables/reorderables.dart';

class Gifts extends StatefulWidget {
  final Addiction data;

  Gifts({
    this.data,
  });

  @override
  _GiftsState createState() => _GiftsState();
}

class _GiftsState extends State<Gifts> {
  List<Widget> _tiles;

  void getTiles() async {
    await Provider.of<AddictionsProvider>(context).fetchGifts(widget.data.id);
    setState(() {
      widget.data.gifts.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
      _tiles = widget.data.gifts
          .map<Widget>(
            (gift) => GiftCard(
              gift: gift,
              availableMoney: widget.data.availableMoney,
              dailyGain: (widget.data.dailyConsumption * widget.data.unitCost),
            ),
          )
          .toList()
            ..add(
              AddGiftButton(
                id: widget.data.id,
              ),
            );
    });
  }

  @override
  void didChangeDependencies() {
    getTiles();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context);
    final deviceSize = MediaQuery.of(context).size;
    final currency =
        Provider.of<SettingsProvider>(context, listen: false).currency;

    void _onReorder(int oldIndex, int newIndex) async {
      setState(() {
        if (_tiles.elementAt(oldIndex).runtimeType == AddGiftButton ||
            newIndex == _tiles.length - 1) {
          return;
        }
        Widget row = _tiles.removeAt(oldIndex);
        _tiles.insert(newIndex, row);
      });
      await DBHelper.switchGiftOrders(
        'gifts',
        'sort_order',
        oldIndex,
        newIndex,
      );
    }

    return SingleChildScrollView(
      child: FutureBuilder(
        future:
            Provider.of<AddictionsProvider>(context).fetchGifts(widget.data.id),
        builder: (_, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Consumer<AddictionsProvider>(builder: (_, addictionData, _ch) {
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
                    children: _tiles,
                    onReorder: _onReorder,
                    needsLongPressDraggable: true,
                    header: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            local.available.capitalizeWords() +
                                ': ' +
                                NumberFormat.simpleCurrency(
                                  name: currency,
                                ).format(widget.data.availableMoney),
                          ),
                          Text(
                            local.spent.capitalizeWords() +
                                ': ' +
                                NumberFormat.simpleCurrency(
                                  name: currency,
                                ).format(widget.data.totalSpent),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
      ),
    );
  }
}

class GiftCard extends StatefulWidget {
  const GiftCard({
    Key key,
    @required this.gift,
    @required this.availableMoney,
    @required this.dailyGain,
  }) : super(key: key);

  final Gift gift;
  final double availableMoney;
  final double dailyGain;

  @override
  _GiftCardState createState() => _GiftCardState();
}

class _GiftCardState extends State<GiftCard> {
  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context);
    final materialLocal = MaterialLocalizations.of(context);
    final deviceSize = MediaQuery.of(context).size;
    final currency =
        Provider.of<SettingsProvider>(context, listen: false).currency;
    final giftPrice = NumberFormat.compactSimpleCurrency(
      name: currency,
    ).format(widget.gift.price);
    final daysLeft =
        ((widget.gift.price - widget.availableMoney) / widget.dailyGain);
    final daysLeftClamped = daysLeft.clamp(0, 365);
    final percentage =
        (widget.availableMoney / widget.gift.price).clamp(0.0, 1.0);

// todo not showing when first adding
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
          height: deviceSize.height * .2,
          width: deviceSize.width * .46,
          child: Material(
            color: Theme.of(context).cardColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
              side: BorderSide(
                width: 1,
                color: Theme.of(context).dividerColor,
              ),
            ),
            elevation: 5,
            child: InkWell(
              onTap: () => showDialog(
                context: context,
                builder: (context) => new AlertDialog(
                  title: Text(
                    local
                        .purchaseGiftMsg(giftPrice, widget.gift.name)
                        .capitalizeFirstLetter(),
                  ), //'Purchase \"${widget.gift.name}\" for $giftPrice'
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
                        setState(() {
                          Provider.of<AddictionsProvider>(context,
                                  listen: false)
                              .buyGift(widget.gift);
                          Navigator.of(context).pop();
                        });
                      },
                      child: Text(
                        materialLocal.okButtonLabel,
                      ),
                    ),
                  ],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Flex(
                  mainAxisSize: MainAxisSize.max,
                  direction: Axis.vertical,
                  children: [
                    Flexible(
                      flex: 3,
                      fit: FlexFit.tight,
                      child: Text(
                        widget.gift.name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).hintColor,
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 4,
                      fit: FlexFit.tight,
                      child: Center(
                        child: Text(
                          widget.gift.count.toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).hintColor,
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 2,
                      fit: FlexFit.tight,
                      child: DefaultTextStyle(
                        style: TextStyle(
                          color: Theme.of(context).hintColor,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              giftPrice.toString(),
                            ),
                            Text(
                              daysLeftClamped.toStringAsFixed(0) +
                                  (daysLeft > 365 ? '+' : '') +
                                  ' ' +
                                  local.daysLeft(daysLeftClamped.toInt()),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 2,
                      fit: FlexFit.tight,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            clipBehavior: Clip.hardEdge,
                            child: LinearProgressIndicator(
                              value: percentage,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                percentage == 1.0
                                    ? Theme.of(context).primaryColor
                                    : Theme.of(context).primaryColorLight,
                              ),
                              backgroundColor: Theme.of(context).canvasColor,
                              minHeight: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  .fontSize,
                            ),
                          ),
                          Text(
                            ((widget.availableMoney / widget.gift.price)
                                            .clamp(0.0, 1.0) *
                                        100)
                                    .toStringAsFixed(0) +
                                '%',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Icon(
                        Icons.drag_handle_rounded,
                        color: Theme.of(context).hintColor,
                      ),
                    ),
                  ],
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
              splashColor: Colors.red,
              customBorder: CircleBorder(),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Icon(
                  Icons.delete,
                  color: Theme.of(context).errorColor,
                  size: Theme.of(context).textTheme.headline6.fontSize,
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
  const AddGiftButton({@required this.id});

  final String id;

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return SizedBox(
      height: deviceSize.height * .2,
      width: deviceSize.width * .46,
      child: Material(
        color: Theme.of(context).cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
          side: BorderSide(
            width: 1,
            color: Theme.of(context).dividerColor,
          ),
        ),
        elevation: 5,
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
    );
  }
}
