import 'package:flutter/material.dart';
import 'package:flutter_quit_addiction_app/models/addiction.dart';
import 'package:intl/intl.dart';

class Note extends StatelessWidget {
  final PersonalNote data;

  Note({
    @required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final _controller = TextEditingController(text: data.text);
    final formattedStartDate =
        DateFormat('dd/MM/yyyy').format(DateTime.parse(data.date));
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(5.0),
        border: Border.all(
          color: Theme.of(context).highlightColor,
          width: 1,
        ),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            children: [
              Text(
                data.title,
                style: TextStyle(
                  color: Theme.of(context).accentColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                formattedStartDate,
                style: TextStyle(
                  color: Theme.of(context).hintColor,
                  fontWeight: FontWeight.w900,
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
                color: Theme.of(context).hintColor,
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
