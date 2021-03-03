import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_quit_addiction_app/extensions/string_extension.dart';
import 'package:flutter_quit_addiction_app/models/addiction.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class Achievements extends StatefulWidget {
  final Addiction data;

  const Achievements({
    this.data,
  });

  @override
  _AchievementsState createState() => _AchievementsState();
}

class _AchievementsState extends State<Achievements> {
  List formattedDurations;

  void _getLocalizedAchievementDurations(AppLocalizations local) {
    formattedDurations[0] = 'a new start!';
    for (var i = 1; i < widget.data.achievements.length; i++) {
      if (widget.data.achievements[i].inDays < 30) {
        formattedDurations[i] =
            ('${widget.data.achievements[i].inDays} ${local.day(widget.data.achievements[i].inDays)}');
      } else if (widget.data.achievements[i].inDays < 360) {
        final int inMonths = (widget.data.achievements[i].inDays / 30).floor();
        formattedDurations[i] = ('$inMonths ${local.month(inMonths)}');
      } else {
        final int inYears = (widget.data.achievements[i].inDays / 360).floor();
        formattedDurations[i] = ('$inYears ${local.year(inYears)}');
      }
    }
  }

  @override
  void initState() {
    formattedDurations = List.filled(widget.data.achievements.length, '');
    Future.delayed(Duration.zero, () {
      setState(() {
        _getLocalizedAchievementDurations(AppLocalizations.of(context));
      });
    });
    super.initState();
  }

  Map<String, Object> _getTileAttr(int itemLevel) {
    final currentLevel = widget.data.level;
    if (itemLevel == 0) {
      return {
        'tileColor': Colors.green,
        'icon': Icons.radio_button_checked,
        'iconColor': Colors.white,
      };
    } else if (itemLevel <= currentLevel) {
      return {
        'tileColor': Colors.green,
        'icon': Icons.check,
        'iconColor': Colors.white,
      };
    } else {
      final diff = itemLevel - currentLevel;
      final tileColor = Colors.amber
          .withGreen((Colors.amber.green - (diff * 20)).clamp(0, 255));
      return {
        'tileColor': tileColor,
        'icon': Icons.lock_clock,
        'iconColor': Colors.black,
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    // final local = AppLocalizations.of(context);
    final currentLevel = widget.data.level;

    return ListView.builder(
      itemCount: widget.data.achievements.length,
      itemBuilder: (context, index) {
        final tileAttr = _getTileAttr(index);
        return (currentLevel + 1 == index)
            ? ListTile(
                tileColor: tileAttr['tileColor'],
                contentPadding: EdgeInsets.all(
                    Theme.of(context).textTheme.headline4.fontSize),
                title: Center(
                  child: Text(
                    formattedDurations[index],
                    style: TextStyle(
                      fontSize: Theme.of(context).textTheme.headline4.fontSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                subtitle: Padding(
                  padding: EdgeInsets.all(
                      Theme.of(context).textTheme.headline1.fontSize / 2),
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: SleekCircularSlider(
                      innerWidget: (percentage) => Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            percentage.toStringAsFixed(0),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: Theme.of(context)
                                  .textTheme
                                  .headline5
                                  .fontSize,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '%',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  .fontSize,
                            ),
                          ),
                        ],
                      ),
                      appearance: CircularSliderAppearance(
                        animationEnabled: true,
                        infoProperties: InfoProperties(
                          mainLabelStyle: TextStyle(
                            color: Colors.white,
                            fontSize:
                                Theme.of(context).textTheme.headline6.fontSize,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        customWidths: CustomSliderWidths(
                          trackWidth:
                              Theme.of(context).textTheme.bodyText1.fontSize,
                          handlerSize: 0,
                          progressBarWidth:
                              Theme.of(context).textTheme.bodyText1.fontSize,
                        ),
                        customColors: CustomSliderColors(
                          progressBarColors: [
                            Theme.of(context).accentColor,
                            Theme.of(context).accentColor.withOpacity(.5),
                          ],
                          trackColor: Theme.of(context).canvasColor,
                          hideShadow: true,
                        ),
                      ),
                      min: 0,
                      max: 100,
                      initialValue: (widget.data.abstinenceTime.inSeconds /
                                  widget.data.achievements[index].inSeconds)
                              .clamp(0.0, 1.0) *
                          100,
                    ),
                  ),
                ),
              )
            : ListTile(
                tileColor: tileAttr['tileColor'],
                contentPadding: EdgeInsets.all(
                  Theme.of(context).textTheme.headline4.fontSize,
                ),
                title: Center(
                  child: Text(
                    formattedDurations[index],
                    style: TextStyle(
                      fontSize: Theme.of(context).textTheme.headline4.fontSize,
                      fontWeight: FontWeight.bold,
                      color: tileAttr['iconColor'],
                    ),
                  ),
                ),
                subtitle: Padding(
                  padding: EdgeInsets.all(
                      Theme.of(context).textTheme.headline1.fontSize / 2),
                  child: Icon(
                    tileAttr['icon'],
                    size: Theme.of(context).textTheme.headline1.fontSize,
                    color: tileAttr['iconColor'],
                  ),
                ),
              );
      },
    );
  }
}

// ListView(
//       children: [
//         ListTile(
//           tileColor: Colors.green,
//           contentPadding:
//               EdgeInsets.all(Theme.of(context).textTheme.headline4.fontSize),
//           title: Center(
//             child: Text('Achievement 1'),
//           ),
//           subtitle: Icon(
//             Icons.check,
//             size: Theme.of(context).textTheme.headline1.fontSize,
//           ),
//         ),
//         ListTile(
//           tileColor: Colors.amber,
//           contentPadding:
//               EdgeInsets.all(Theme.of(context).textTheme.headline4.fontSize),
//           title: Center(
//             child: Text('Achievement 2'),
//           ),
//           subtitle: Icon(
//             Icons.timelapse,
//             size: Theme.of(context).textTheme.headline1.fontSize,
//           ),
//         ),
//         ListTile(
//           tileColor: Colors.orange,
//           contentPadding:
//               EdgeInsets.all(Theme.of(context).textTheme.headline4.fontSize),
//           title: Center(
//             child: Text('Achievement 3'),
//           ),
//           subtitle: Icon(
//             Icons.lock_clock,
//             size: Theme.of(context).textTheme.headline1.fontSize,
//           ),
//         ),
//         ListTile(
//           tileColor: Colors.red,
//           contentPadding:
//               EdgeInsets.all(Theme.of(context).textTheme.headline4.fontSize),
//           title: Center(
//             child: Text('Achievement 4'),
//           ),
//           subtitle: Icon(
//             Icons.lock_clock,
//             size: Theme.of(context).textTheme.headline1.fontSize,
//           ),
//         ),
//         ListTile(
//           tileColor: Colors.red[900],
//           contentPadding:
//               EdgeInsets.all(Theme.of(context).textTheme.headline4.fontSize),
//           title: Center(
//             child: Text('Achievement 5'),
//           ),
//           subtitle: Icon(
//             Icons.lock_clock,
//             size: Theme.of(context).textTheme.headline1.fontSize,
//           ),
//         ),
//       ],
//     );
