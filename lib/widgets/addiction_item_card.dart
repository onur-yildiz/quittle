import 'package:flutter/material.dart';
import 'package:quittle/models/addiction.dart';
import 'package:quittle/models/addiction_item_screen_args.dart';
import 'package:quittle/screens/addiction_item_screen.dart';
import 'package:quittle/widgets/addiction_progress.dart';

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
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Material(
        elevation: 4,
        type: MaterialType.card,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(
            width: 1,
            color: Theme.of(context).highlightColor,
          ),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () {
            Navigator.of(context).pushNamed(
              AddictionItemScreen.routeName,
              arguments: AddictionItemScreenArgs(widget.addictionData),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
                            fontSize:
                                Theme.of(context).textTheme.headline5.fontSize,
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
    );
  }
}
