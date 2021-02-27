import 'package:flutter/material.dart';
import 'package:flutter_quit_addiction_app/models/addiction.dart';
import 'package:flutter_quit_addiction_app/providers/addictions_provider.dart';
import 'package:flutter_quit_addiction_app/providers/settings_provider.dart';
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

  @override
  void initState() {
    _tiles = widget.data.gifts
        .map<Widget>(
          (gift) => GiftCard(
            gift: gift,
          ),
        )
        .toList()
          ..add(
            AddGiftButton(),
          );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    final currency =
        Provider.of<SettingsProvider>(context, listen: false).currency;

    void _onReorder(int oldIndex, int newIndex) {
      setState(() {
        if (_tiles.elementAt(oldIndex).runtimeType == AddGiftButton) {
          return;
        }
        Widget row = _tiles.removeAt(oldIndex);
        _tiles.insert(newIndex, row);
      });
    }

    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Consumer<AddictionsProvider>(
            builder: (_, addictionData, _ch) => Padding(
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
                        'Available: ' +
                            (widget.data.notUsedCount *
                                    widget.data.dailyConsumption)
                                .toStringAsFixed(2) +
                            ' ' +
                            currency,
                      ),
                      Text(
                        'Spent on gifts: ' +
                            (widget.data.notUsedCount *
                                    widget.data.dailyConsumption)
                                .toStringAsFixed(2) +
                            ' ' +
                            currency,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class GiftCard extends StatelessWidget {
  const GiftCard({
    Key key,
    @required this.gift,
  }) : super(key: key);

  final Gift gift;

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    final currency =
        Provider.of<SettingsProvider>(context, listen: false).currency;

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
          onTap: () => showDialog(
            context: context,
            builder: (context) => new AlertDialog(
              title: Text('Buy \"${gift.name}\" for ${gift.price} $currency'),
              actions: [
                FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel'),
                ),
                FlatButton(
                  onPressed: () {}, //todo buy
                  child: Text('Buy'),
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
                    gift.name,
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
                      gift.count.toString(),
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
                      // fontWeight: FontWeight.bold,
                      color: Theme.of(context).hintColor,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          gift.price.toString() + ' ' + currency,
                        ),
                        Text(
                          'X days left',
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
                          value: .7,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Theme.of(context).primaryColorLight,
                          ),
                          backgroundColor: Theme.of(context).canvasColor,
                          minHeight:
                              Theme.of(context).textTheme.bodyText1.fontSize,
                        ),
                      ),
                      Text(
                        '35%',
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
    );
  }
}

class AddGiftButton extends StatelessWidget {
  const AddGiftButton({
    Key key,
  }) : super(key: key);

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
          onTap: () {},
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
