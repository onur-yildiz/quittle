import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:quittle/providers/settings_provider.dart';
import 'package:quittle/widgets/currency_picker.dart';

class SettingsView extends StatefulWidget {
  @override
  _SettingsViewState createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  bool _progressCheck = false;
  bool _quoteCheck = false;
  SettingsProvider settings;
  String currency;

  @override
  void initState() {
    settings = Provider.of<SettingsProvider>(context, listen: false);
    _progressCheck = settings.receiveProgressNotifs;
    _quoteCheck = settings.receiveQuoteNotifs;
    currency = settings.currency;

    super.initState();
  }

  void _updateCurrency(String newCurrency) {
    setState(() {
      currency = newCurrency;
    });
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context);
    final isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Drawer(
      child: LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          child: Container(
            child: ConstrainedBox(
              constraints: constraints.copyWith(
                minHeight: constraints.maxHeight,
                maxHeight: double.infinity,
              ),
              child: IntrinsicHeight(
                child: SafeArea(
                  child: Column(
                    children: [
                      Column(
                        children: [
                          Container(
                            height: kToolbarHeight,
                            width: double.infinity,
                            child: DrawerHeader(
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    width: 0,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                              ),
                              child: Text(
                                local.settings,
                                style: TextStyle(
                                  fontSize: Theme.of(context)
                                      .textTheme
                                      .headline6
                                      .fontSize,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ),
                          ),
                          SwitchListTile(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 24, horizontal: 8),
                            title: Text(
                              local.progressNotification,
                            ),
                            subtitle: Text(
                              local.progressNotificationDesc,
                              style: TextStyle(
                                color: Theme.of(context).hintColor,
                              ),
                            ),
                            value: _progressCheck,
                            activeColor: Theme.of(context).accentColor,
                            onChanged: (value) {
                              if (mounted) {
                                setState(() {
                                  settings.allowProgressNotif(value);
                                  _progressCheck = value;
                                });
                              }
                            },
                          ),
                          Divider(
                            height: 0,
                            thickness: 1,
                          ),
                          SwitchListTile(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 24, horizontal: 8),
                            title: Text(
                              local.quoteOfTheDay,
                            ),
                            subtitle: Text(
                              local.quoteOfTheDayDesc,
                              style: TextStyle(
                                color: Theme.of(context).hintColor,
                              ),
                            ),
                            value: _quoteCheck,
                            activeColor: Theme.of(context).accentColor,
                            onChanged: (value) {
                              if (mounted) {
                                setState(() {
                                  settings.allowQuoteNotif(value);
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
                              builder: (context) =>
                                  CurrencyPicker(onUpdate: _updateCurrency),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 24, horizontal: 8),
                            leading: FaIcon(FontAwesomeIcons.moneyBillWave),
                            title: Text(
                              local.currency,
                              style: TextStyle(
                                fontSize: Theme.of(context)
                                    .textTheme
                                    .subtitle2
                                    .fontSize,
                                color: Theme.of(context).hintColor,
                              ),
                            ),
                            trailing: Text(
                              '$currency (${NumberFormat.simpleCurrency(
                                name: currency,
                                locale: local.localeName,
                              ).currencySymbol})',
                              style: TextStyle(
                                color: Theme.of(context).accentColor,
                                fontWeight: FontWeight.bold,
                                fontSize: Theme.of(context)
                                    .textTheme
                                    .subtitle1
                                    .fontSize,
                              ),
                            ),
                          ),
                          Divider(
                            height: 0,
                            thickness: 1,
                          ),
                        ],
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    local.appName.toUpperCase(),
                                    style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: FaIcon(
                                          FontAwesomeIcons.infoCircle,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                        tooltip: local.licenses,
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) => AboutDialog(
                                              applicationName: local.appName,
                                              applicationIcon:
                                                  SizedBox.fromSize(
                                                size: Size.square(16.0),
                                                child: Image.asset(
                                                  'assets/images/font_awesome_chain.png',
                                                ),
                                              ),
                                              applicationVersion: '1.0.0',
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .stretch,
                                                  children: [
                                                    TextButton(
                                                      onPressed: () {
                                                        _launchURL(
                                                            'https://fontawesome.com/license/free');
                                                      },
                                                      child: Text(
                                                        'FontAwesome Free License',
                                                      ),
                                                    ),
                                                    TextButton(
                                                      onPressed: () {
                                                        _launchURL(
                                                            'https://fontawesome.com/icons/link?style=solid');
                                                      },
                                                      child: Text(
                                                        local.appIcon,
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              ],
                                              applicationLegalese:
                                                  local.applicationLegalese,
                                            ),
                                          );
                                        },
                                      ),
                                      IconButton(
                                        icon: FaIcon(
                                          FontAwesomeIcons.twitter,
                                          color:
                                              Color.fromRGBO(29, 161, 242, 1),
                                        ),
                                        tooltip: 'Twitter',
                                        onPressed: () {
                                          _launchURL(
                                              'https://twitter.com/onur_ldz');
                                        },
                                      ),
                                      IconButton(
                                        icon: FaIcon(
                                          FontAwesomeIcons.github,
                                        ),
                                        tooltip: 'GitHub',
                                        onPressed: () {
                                          _launchURL(
                                              'https://github.com/onur-yildiz');
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

void _launchURL(url) async =>
    await canLaunch(url) ? await launch(url) : throw 'Could not launch $url';
