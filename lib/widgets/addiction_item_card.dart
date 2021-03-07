import 'dart:io';
import 'dart:typed_data';

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:quittle/models/addiction.dart';
import 'package:quittle/models/addiction_item_screen_args.dart';
import 'package:quittle/screens/addiction_item_screen.dart';
import 'package:quittle/widgets/addiction_progress.dart';
import 'dart:ui' as ui;
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';
import 'package:uuid/uuid.dart';

class AddictionItemCard extends StatefulWidget {
  const AddictionItemCard({
    @required this.addictionData,
    @required this.onDelete,
    Key key,
  }) : super(key: key);

  final Addiction addictionData;
  final Function onDelete;

  @override
  _AddictionItemCardState createState() => _AddictionItemCardState();
}

class _AddictionItemCardState extends State<AddictionItemCard> {
  GlobalKey _cardKey = GlobalKey();

  _share() async {
    RenderRepaintBoundary boundary = _cardKey.currentContext.findRenderObject();
    ui.Image image = await boundary.toImage();
    ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData.buffer.asUint8List();
    final directory = (await getApplicationDocumentsDirectory()).path;
    File imgFile = File('$directory/screenshot_shared.png');
    imgFile.writeAsBytes(pngBytes);
    Share.shareFiles(
      ['$directory/screenshot_shared.png'],
      text: 'Check out my progress!',
      subject: 'My progress',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          width: 0,
          style: BorderStyle.none,
        ),
        color: Theme.of(context).accentColor,
      ),
      padding: const EdgeInsets.only(bottom: 4),
      child: OpenContainer(
        closedColor: Theme.of(context).accentColor,
        closedShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(
            width: 3,
            color: Theme.of(context).highlightColor,
          ),
        ),
        transitionDuration: Duration(milliseconds: 250),
        openBuilder: (context, action) => AddictionItemScreen(),
        routeSettings: RouteSettings(
          arguments: AddictionItemScreenArgs(widget.addictionData),
        ),
        closedBuilder: (context, action) => Slidable(
          key: ValueKey(Uuid().v1()),
          actionPane: SlidableDrawerActionPane(),
          actionExtentRatio: .25,
          fastThreshold: .1,
          dismissal: SlidableDismissal(
            child: SlidableDrawerDismissal(),
            dismissThresholds: <SlideActionType, double>{
              SlideActionType.primary: 1.0,
              SlideActionType.secondary: .5
            },
            onDismissed: (actionType) {
              if (actionType == SlideActionType.primary) return;
              widget.onDelete(widget.addictionData.id);
            },
          ),
          actions: [
            IconSlideAction(
              caption: 'Share',
              color: Theme.of(context).accentColor,
              icon: Icons.share,
              onTap: _share,
            ),
          ],
          secondaryActions: [
            IconSlideAction(
              caption: 'Delete',
              color: Theme.of(context).errorColor,
              icon: Icons.delete,
              // onTap: () {
              //   setState(() {
              //     Provider.of<AddictionsProvider>(context, listen: false)
              //         .deleteAddiction(widget.addictionData.id);
              //   });
              // },
            ),
          ],
          child: RepaintBoundary(
            key: _cardKey,
            child: Material(
              type: MaterialType.card,
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  width: 1,
                  color: Theme.of(context).highlightColor,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flex(
                      direction: Axis.horizontal,
                      children: [
                        Flexible(
                          flex: 1,
                          child: Center(
                            child: Text(
                              widget.addictionData.name.toUpperCase(),
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: Theme.of(context)
                                    .textTheme
                                    .headline5
                                    .fontSize,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ),
                        ),
                        Spacer(
                          flex: 1,
                        )
                      ],
                    ),
                    AddictionProgress(
                      addictionData: widget.addictionData,
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
