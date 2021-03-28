import 'dart:io';
import 'dart:ui' as ui;
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:animations/animations.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';
import 'package:uuid/uuid.dart';

import 'package:quittle/models/addiction.dart';
import 'package:quittle/models/addiction_item_screen_args.dart';
import 'package:quittle/screens/addiction_item_screen.dart';
import 'package:quittle/widgets/addiction_progress.dart';

class AddictionItemCard extends StatelessWidget {
  AddictionItemCard({
    @required this.addictionData,
    @required this.onDelete,
    @required key,
  }) : super(key: key);

  final Addiction addictionData;
  final Function onDelete;
  final GlobalKey _cardKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final local = AppLocalizations.of(context);
    final isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;

    _share() async {
      RenderRepaintBoundary boundary =
          _cardKey.currentContext.findRenderObject();
      ui.Image image = await boundary.toImage(pixelRatio: 2.0);
      ByteData byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData.buffer.asUint8List();
      final directory = (await getApplicationDocumentsDirectory()).path;
      File imgFile = File('$directory/screenshot_shared.png');
      await imgFile.writeAsBytes(pngBytes);
      Share.shareFiles(
        ['$directory/screenshot_shared.png'],
        text: local.shareMsg,
        subject: local.shareMsgSubject,
      );
    }

    return Container(
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          width: 0,
          style: BorderStyle.none,
        ),
        color: isDark ? t.highlightColor.withOpacity(.1) : t.accentColor,
      ),
      padding: const EdgeInsets.only(bottom: 4),
      child: OpenContainer(
        closedColor: isDark ? t.highlightColor.withOpacity(.1) : t.accentColor,
        closedShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(
            width: 3,
            color: t.highlightColor,
          ),
        ),
        transitionDuration: Duration(milliseconds: 250),
        openBuilder: (context, action) => AddictionItemScreen(),
        routeSettings: RouteSettings(
          arguments: AddictionItemScreenArgs(addictionData),
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
              onDelete(addictionData.id);
            },
          ),
          actions: [
            IconSlideAction(
              caption: local.share,
              color: t.accentColor,
              icon: Icons.share,
              onTap: _share,
            ),
          ],
          secondaryActions: [
            IconSlideAction(
              caption: local.delete,
              color: t.errorColor,
              icon: Icons.delete,
            ),
          ],
          child: RepaintBoundary(
            key: _cardKey,
            child: Material(
              type: MaterialType.card,
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  width: 1,
                  color: t.highlightColor,
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
                              addictionData.name.toUpperCase(),
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: Theme.of(context)
                                    .textTheme
                                    .headline5
                                    .fontSize,
                                color: t.textTheme.bodyText1.color,
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
                      addictionData: addictionData,
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
