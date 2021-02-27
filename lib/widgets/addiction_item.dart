import 'package:flutter/material.dart';
import 'package:flutter_quit_addiction_app/models/addiction_item_screen_args.dart';
import 'package:flutter_quit_addiction_app/widgets/addiction_details.dart';
import 'package:flutter_quit_addiction_app/widgets/addiction_progress.dart';
import 'package:flutter_quit_addiction_app/widgets/personal_notes_view.dart';

class AddictionItem extends StatelessWidget {
  const AddictionItem({
    @required this.args,
  });

  final AddictionItemScreenArgs args;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AddictionProgress(
            addictionData: args.data,
          ),
          AddictionDetails(
            addictionData: args.data,
          ),
          PersonalNotesView(
            addictionData: args.data,
          ),
        ],
      ),
    );
  }
}
