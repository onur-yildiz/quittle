import 'package:flutter/material.dart';
import 'package:flutter_quit_addiction_app/models/addiction.dart';
import 'package:flutter_quit_addiction_app/models/addiction_item_screen_args.dart';
import 'package:flutter_quit_addiction_app/screens/addiction_item_screen.dart';
import 'package:flutter_quit_addiction_app/widgets/addiction_progress.dart';

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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  widget.addictionData.name.toUpperCase(),
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: Theme.of(context).textTheme.headline5.fontSize,
                    color: Theme.of(context).hintColor,
                  ),
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
