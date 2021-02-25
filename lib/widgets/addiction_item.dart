import 'package:flutter/material.dart';
import 'package:flutter_quit_addiction_app/models/addiction_item_screen_args.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_quit_addiction_app/widgets/addiction_details.dart';
import 'package:flutter_quit_addiction_app/widgets/addiction_progress.dart';
import 'package:flutter_quit_addiction_app/widgets/personal_notes_view.dart';
import 'package:intl/intl.dart';

const Duration _kExpand = Duration(milliseconds: 200);

class AddictionItem extends StatelessWidget {
  const AddictionItem({
    @required this.args,
  });

  final AddictionItemScreenArgs args;

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context);
    final quitDateFormatted = DateFormat('dd/MM/yyyy')
        .format(args.data.quitDateTime); // TODO: LOCALIZED FORMAT
    final consumptionType = (args.data.consumptionType == 1)
        ? local.hour(args.data.notUsedCount.toInt())
        : local.times(args.data.notUsedCount.toInt());

    return SingleChildScrollView(
      child: AnimatedContainer(
        duration: _kExpand,
        curve: Curves.fastOutSlowIn,
        color: Theme.of(context).canvasColor,
        // margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AddictionProgress(
              local: local,
              unitCost: args.data.unitCost,
              notUsedCount: args.data.notUsedCount,
              consumptionType: consumptionType,
              abstinenceTime: args.data.abstinenceTime,
            ),
            AddictionDetails(
              addictionData: args.data,
              notUsedCount: args.data.notUsedCount,
              abstinenceTime: args.data.abstinenceTime,
              quitDateFormatted: quitDateFormatted,
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
