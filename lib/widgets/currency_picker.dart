import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert' show json;

class CurrencyPicker extends StatefulWidget {
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
              itemBuilder: (context, index) => FlatButton(
                padding: const EdgeInsets.all(16.0),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                color: Theme.of(context).canvasColor,
                onPressed: () {},
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      flex: 1,
                      fit: FlexFit.loose,
                      child: Text(
                        _currencies[index]['code'],
                      ),
                    ),
                    Flexible(
                      flex: 3,
                      fit: FlexFit.tight,
                      child: Text(
                        _currencies[index]['name'], // todo localization
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
