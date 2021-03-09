import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quittle/providers/settings_provider.dart';
import 'dart:convert' show json;

import 'package:provider/provider.dart';

class CurrencyPicker extends StatefulWidget {
  final Function onUpdate;

  const CurrencyPicker({
    this.onUpdate,
  });

  @override
  _CurrencyPickerState createState() => _CurrencyPickerState();
}

class _CurrencyPickerState extends State<CurrencyPicker> {
  List _currencies = [];

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
    final mediaQuery = MediaQuery.of(context);
    final deviceHeight = mediaQuery.size.height;
    final deviceWidth = mediaQuery.size.width;

    return new SimpleDialog(
      backgroundColor: Theme.of(context).cardColor,
      contentPadding: EdgeInsets.zero,
      children: [
        SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: SizedBox(
            height: deviceHeight * .8,
            width: deviceWidth * .4,
            child: ListView.builder(
              itemCount: _currencies.length,
              itemBuilder: (context, index) => TextButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(
                    BeveledRectangleBorder(),
                  ),
                  backgroundColor: MaterialStateProperty.all(
                    Theme.of(context).canvasColor,
                  ),
                  foregroundColor: MaterialStateProperty.all(
                    Theme.of(context).hintColor,
                  ),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  padding: MaterialStateProperty.all(
                    const EdgeInsets.all(16.0),
                  ),
                ),
                onPressed: () {
                  // final prefs = await SharedPreferences.getInstance();
                  // await prefs.setString('currency', _currencies[index]['code']);
                  Provider.of<SettingsProvider>(context, listen: false)
                      .updateCurrency(_currencies[index]['code']);
                  widget.onUpdate(_currencies[index]['code']);
                  Navigator.of(context).pop(_currencies[index]['code']);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      flex: 1,
                      fit: FlexFit.loose,
                      child: Text(
                        _currencies[index]['code'],
                        style: TextStyle(
                          color: Theme.of(context).accentColor,
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 3,
                      fit: FlexFit.tight,
                      child: Text(
                        _currencies[index]['name'], // TODO localization
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
