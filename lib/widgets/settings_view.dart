import 'package:flutter/material.dart';
import 'package:flutter_quit_addiction_app/providers/settings.dart';
import 'package:flutter_quit_addiction_app/widgets/currency_picker.dart';
import 'package:provider/provider.dart';

class SettingsView extends StatefulWidget {
  @override
  _SettingsViewState createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  bool _progressCheck = false;
  bool _quoteCheck = false;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final deviceHeight = mediaQuery.size.height;
    final deviceWidth = mediaQuery.size.width;
    return Drawer(
      child: ListView(
        children: [
          SizedBox(
            height: deviceHeight * .1,
            child: DrawerHeader(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    width: 1,
                    color: Theme.of(context).primaryColorDark,
                  ),
                ),
              ),
              child: Text(
                'Settings',
                style: TextStyle(
                  fontSize: Theme.of(context).textTheme.headline6.fontSize,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
              runSpacing: 15.0,
              children: [
                CheckboxListTile(
                  title: Text('Progress Notifications'),
                  subtitle: Text('Enable push notifications for milestones'),
                  value: _progressCheck,
                  onChanged: (value) {
                    setState(() {
                      _progressCheck = value;
                    });
                  },
                ),
                Divider(
                  thickness: 1,
                ),
                CheckboxListTile(
                  title: Text('Quote of the Day'),
                  subtitle: Text('Enable push notifications for daily quotes'),
                  value: _quoteCheck,
                  onChanged: (value) {
                    setState(() {
                      _quoteCheck = value;
                    });
                  },
                ),
                Divider(
                  thickness: 1,
                ),
                ListTile(
                  onTap: () => showDialog(
                    context: context,
                    builder: (context) => CurrencyPicker(),
                  ),
                  isThreeLine: true,
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(Icons.attach_money),
                  title: Text('Currency'),
                  subtitle: Text(Provider.of<Settings>(context).currency),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}