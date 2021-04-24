import 'dart:convert' show json;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:quittle/providers/settings_provider.dart';

class CurrencyPicker extends StatefulWidget {
  final Function? onUpdate;

  const CurrencyPicker({
    this.onUpdate,
  });

  @override
  _CurrencyPickerState createState() => _CurrencyPickerState();
}

class _CurrencyPickerState extends State<CurrencyPicker> {
  List? _currencies = [];

  Future<void> getJson() async {
    final String response =
        await rootBundle.loadString('assets/data/currencies.json');
    _currencies = await json.decode(response);
    setState(() {});
  }

  @override
  void initState() {
    getJson();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    final deviceHeight = mediaQuery.size.height;
    final deviceWidth = mediaQuery.size.width;

    return new SimpleDialog(
      backgroundColor: t.cardColor,
      contentPadding: EdgeInsets.zero,
      children: [
        SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: SizedBox(
            height: deviceHeight * .8,
            width: deviceWidth * .4,
            child: ListView.builder(
              itemCount: _currencies!.length,
              itemBuilder: (context, index) => TextButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(
                    BeveledRectangleBorder(),
                  ),
                  backgroundColor: MaterialStateProperty.all(
                    t.canvasColor,
                  ),
                  foregroundColor: MaterialStateProperty.all(
                    t.hintColor,
                  ),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  padding: MaterialStateProperty.all(
                    const EdgeInsets.all(16.0),
                  ),
                ),
                onPressed: () {
                  Provider.of<SettingsProvider>(context, listen: false)
                      .updateCurrency(_currencies![index]['code']);
                  widget.onUpdate!(_currencies![index]['code']);
                  Navigator.of(context).pop(_currencies![index]['code']);
                },
                child: Text(
                  _currencies![index]['code'],
                  style: TextStyle(
                    color: t.accentColor,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
