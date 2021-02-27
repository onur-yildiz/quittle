import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_quit_addiction_app/extensions/string_extension.dart';
import 'package:flutter_quit_addiction_app/providers/settings_provider.dart';
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
    final local = AppLocalizations.of(context);
    final mediaQuery = MediaQuery.of(context);
    final deviceHeight = mediaQuery.size.height;
    // final deviceWidth = mediaQuery.size.width;
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
                local.settings.capitalizeWords(),
                style: TextStyle(
                  fontSize: Theme.of(context).textTheme.headline6.fontSize,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ),
          Wrap(
            children: [
              CheckboxListTile(
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 24, horizontal: 8),
                title: Text(local.progressNotification.capitalizeWords()),
                subtitle: Text(
                    local.progressNotificationDesc.capitalizeFirstLetter()),
                value: _progressCheck,
                onChanged: (value) {
                  if (mounted) {
                    setState(() {
                      _progressCheck = value;
                    });
                  }
                },
              ),
              Divider(
                height: 0,
                thickness: 1,
              ),
              CheckboxListTile(
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 24, horizontal: 8),
                title: Text(local.quoteOfTheDay.capitalizeWords()),
                subtitle: Text(local.quoteOfTheDayDesc.capitalizeFirstLetter()),
                value: _quoteCheck,
                onChanged: (value) {
                  if (mounted) {
                    setState(() {
                      _quoteCheck = value;
                    });
                  }
                },
              ),
              Divider(
                height: 0,
                thickness: 1,
              ),
              ListTile(
                dense: true,
                onTap: () => showDialog(
                  context: context,
                  builder: (context) => CurrencyPicker(),
                ),
                // isThreeLine: true,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                leading: Icon(Icons.account_balance_wallet_outlined),
                title: Text(local.currency.capitalizeWords()),
                subtitle: Text(Provider.of<SettingsProvider>(context).currency),
              ),
              Divider(
                height: 0,
                thickness: 1,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
