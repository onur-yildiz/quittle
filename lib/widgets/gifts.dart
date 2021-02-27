import 'package:flutter/material.dart';
import 'package:flutter_quit_addiction_app/models/addiction.dart';
import 'package:flutter_quit_addiction_app/providers/addictions_provider.dart';
import 'package:flutter_quit_addiction_app/providers/settings_provider.dart';
import 'package:provider/provider.dart';

class Gifts extends StatelessWidget {
  final Addiction data;

  Gifts({
    this.data,
  });

  @override
  Widget build(BuildContext context) {
    final currency =
        Provider.of<SettingsProvider>(context, listen: false).currency;
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Available: ' +
                      (data.notUsedCount * data.dailyConsumption)
                          .toStringAsFixed(2) +
                      ' ' +
                      currency,
                ),
                Text(
                  'Spent on gifts: ' +
                      (data.notUsedCount * data.dailyConsumption)
                          .toStringAsFixed(2) +
                      ' ' +
                      currency,
                ),
              ],
            ),
          ),
          Consumer<AddictionsProvider>(
            builder: (_, addictionData, _ch) => GridView.builder(
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.5,
              ),
              shrinkWrap: true,
              itemCount: data.gifts.length + 1,
              itemBuilder: (context, index) => index < data.gifts.length
                  ? Card(
                      color: Theme.of(context).cardColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                        side: BorderSide(
                          width: 1,
                          color: Theme.of(context).dividerColor,
                        ),
                      ),
                      elevation: 5,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GridTile(
                          header: Center(
                            child: Text(data.gifts[index].name),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(data.gifts[index].price.toString() +
                                      ' ' +
                                      currency),
                                  Text(data.gifts[index].count.toString()),
                                ],
                              ),
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    clipBehavior: Clip.hardEdge,
                                    child: LinearProgressIndicator(
                                      value: .7,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Theme.of(context).primaryColorLight,
                                      ),
                                      backgroundColor:
                                          Theme.of(context).canvasColor,
                                      minHeight: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          .fontSize,
                                    ),
                                  ),
                                  Text(
                                    '35%',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  : Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                        side: BorderSide(
                          width: 1,
                          color: Theme.of(context).dividerColor,
                        ),
                      ),
                      elevation: 5,
                      child: Center(
                        child: IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () {},
                        ),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
