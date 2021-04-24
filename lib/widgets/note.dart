import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

import 'package:quittle/models/personal_note.dart';

class Note extends StatelessWidget {
  final PersonalNote data;

  Note({
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final _controller = TextEditingController(text: data.text);
    final local = AppLocalizations.of(context)!;
    final quitDateFormatted =
        DateFormat.yMMMd(local.localeName).format(DateTime.parse(data.date!));
    return Container(
      decoration: BoxDecoration(
        color: t.canvasColor,
        borderRadius: BorderRadius.circular(5.0),
        border: Border.all(
          color: t.highlightColor,
          width: 1,
        ),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Flex(
            direction: Axis.horizontal,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                flex: 2,
                fit: FlexFit.tight,
                child: Text(
                  data.title!,
                  style: TextStyle(
                    color: t.hintColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Flexible(
                flex: 3,
                fit: FlexFit.tight,
                child: Text(
                  quitDateFormatted,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: t.hintColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          Container(
            child: TextField(
              maxLines: null,
              minLines: 1,
              controller: _controller,
              readOnly: true,
              scrollController: new ScrollController(),
              scrollPhysics: PageScrollPhysics(),
              enabled: true,
              style: TextStyle(
                color: t.hintColor,
                fontWeight: FontWeight.normal,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
