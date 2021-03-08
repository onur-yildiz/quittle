import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:quittle/extensions/string_extension.dart';
import 'package:quittle/providers/settings_provider.dart';
import 'package:quittle/widgets/currency_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

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
                              local.settings.capitalizeWords(),
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
                        CheckboxListTile(
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 24, horizontal: 8),
                          title: Text(
                              local.progressNotification.capitalizeWords()),
                          subtitle: Text(local.progressNotificationDesc
                              .capitalizeFirstLetter()),
                          value: _progressCheck,
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
                        CheckboxListTile(
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 24, horizontal: 8),
                          title: Text(local.quoteOfTheDay.capitalizeWords()),
                          subtitle: Text(
                              local.quoteOfTheDayDesc.capitalizeFirstLetter()),
                          value: _quoteCheck,
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
                          title: Text(local.currency.capitalizeWords()),
                          trailing: Text(
                            '$currency (${NumberFormat.simpleCurrency(
                              name: currency,
                            ).currencySymbol})',
                            style: TextStyle(
                              color: Theme.of(context).accentColor,
                              fontSize: Theme.of(context)
                                  .textTheme
                                  .subtitle2
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                      tooltip: 'Licenses',
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) => AboutDialog(
                                            applicationName: local.appName
                                                .capitalizeFirstLetter(),
                                            applicationIcon: SizedBox.fromSize(
                                              size: Size.square(16.0),
                                              child: Image.asset(
                                                  'assets/images/font_awesome_chain.png'),
                                            ),
                                            applicationVersion: '1.0.0+1',
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.stretch,
                                                children: [
                                                  TextButton(
                                                    onPressed: () {
                                                      _launchURL(
                                                          'https://fontawesome.com/license/free');
                                                    },
                                                    child: Text(
                                                      'Font Awesome Free License',
                                                    ),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      _launchURL(
                                                          'https://fontawesome.com/icons/link?style=solid');
                                                    },
                                                    child: Text(
                                                      'App Icon',
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ],
                                            applicationLegalese:
                                                'App icon is a modified version of font awesome link icon',
                                          ),
                                        );
                                      },
                                    ),
                                    IconButton(
                                      icon: FaIcon(
                                        FontAwesomeIcons.twitter,
                                        color: Color.fromRGBO(29, 161, 242, 1),
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
    )
        // ListView(
        //   children: [
        //     SizedBox(
        //       height: deviceHeight * .1,
        //       child: DrawerHeader(
        //         decoration: BoxDecoration(
        //           border: Border(
        //             bottom: BorderSide(
        //               width: 1,
        //               color: Theme.of(context).primaryColorDark,
        //             ),
        //           ),
        //         ),
        //         child: Text(
        //           local.settings.capitalizeWords(),
        //           style: TextStyle(
        //             fontSize: Theme.of(context).textTheme.headline6.fontSize,
        //             fontWeight: FontWeight.bold,
        //             color: Theme.of(context).primaryColor,
        //           ),
        //         ),
        //       ),
        //     ),
        //     Wrap(
        //       children: [
        //         CheckboxListTile(
        //           contentPadding:
        //               const EdgeInsets.symmetric(vertical: 24, horizontal: 8),
        //           title: Text(local.progressNotification.capitalizeWords()),
        //           subtitle: Text(
        //               local.progressNotificationDesc.capitalizeFirstLetter()),
        //           value: _progressCheck,
        //           onChanged: (value) {
        //             if (mounted) {
        //               setState(() {
        //                 _progressCheck = value;
        //               });
        //             }
        //           },
        //         ),
        //         Divider(
        //           height: 0,
        //           thickness: 1,
        //         ),
        //         CheckboxListTile(
        //           contentPadding:
        //               const EdgeInsets.symmetric(vertical: 24, horizontal: 8),
        //           title: Text(local.quoteOfTheDay.capitalizeWords()),
        //           subtitle: Text(local.quoteOfTheDayDesc.capitalizeFirstLetter()),
        //           value: _quoteCheck,
        //           onChanged: (value) {
        //             if (mounted) {
        //               setState(() {
        //                 _quoteCheck = value;
        //               });
        //             }
        //           },
        //         ),
        //         Divider(
        //           height: 0,
        //           thickness: 1,
        //         ),
        //         ListTile(
        //           dense: true,
        //           onTap: () => showDialog(
        //             context: context,
        //             builder: (context) => CurrencyPicker(),
        //           ),
        //           contentPadding:
        //               const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        //           leading: Icon(Icons.account_balance_wallet_outlined),
        //           title: Text(local.currency.capitalizeWords()),
        //           subtitle: Text(Provider.of<SettingsProvider>(context).currency),
        //         ),
        //         Divider(
        //           height: 0,
        //           thickness: 1,
        //         ),
        //         Row(
        //           children: [
        //             Text(
        //               local.appName.toUpperCase(),
        //               style: TextStyle(
        //                 color: Theme.of(context).primaryColor,
        //                 fontWeight: FontWeight.bold,
        //               ),
        //             ),
        //             IconButton(
        //               icon: FaIcon(FontAwesomeIcons.twitter),
        //               onPressed: () {
        //                 _launchURL('https://twitter.com/onur_ldz');
        //               },
        //             ),
        //             IconButton(
        //               icon: FaIcon(FontAwesomeIcons.github),
        //               onPressed: () {
        //                 _launchURL('https://github.com/onur-yildiz');
        //               },
        //             ),
        //           ],
        //         ),
        //       ],
        //     ),
        //   ],
        // ),

        );
  }
}

void _launchURL(url) async =>
    await canLaunch(url) ? await launch(url) : throw 'Could not launch $url';
