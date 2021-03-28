import 'package:flutter/material.dart';

import 'package:quittle/models/addiction_item_screen_args.dart';
import 'package:quittle/widgets/addiction_details.dart';
import 'package:quittle/widgets/addiction_progress.dart';
import 'package:quittle/widgets/personal_notes_view.dart';

class AddictionItem extends StatelessWidget {
  const AddictionItem({
    @required this.args,
  });

  final AddictionItemScreenArgs args;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Container(
      color: isDark ? t.highlightColor.withOpacity(.1) : t.accentColor,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: t.canvasColor,
              child: AddictionProgress(
                addictionData: args.data,
              ),
            ),
            AddictionDetails(
              addictionData: args.data,
            ),
            PersonalNotesView(
              addictionData: args.data,
            ),
          ],
        ),
      ),
    );
  }
}
