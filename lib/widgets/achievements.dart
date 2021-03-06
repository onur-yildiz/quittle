import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:quittle/models/addiction.dart';
import 'package:quittle/util/progress_constants.dart';
import 'package:quittle/extensions/duration_extension.dart';

const _refreshInterval = Duration(seconds: 30);

class Achievements extends StatefulWidget {
  final Addiction data;

  const Achievements({
    this.data,
  });

  @override
  _AchievementsState createState() => _AchievementsState();
}

class _AchievementsState extends State<Achievements> {
  int maxAchLevel;
  List localizedAchDurations;
  int achLevel;
  double percentage;

  @override
  void initState() {
    maxAchLevel = achievementDurations.length - 1;
    achLevel = widget.data.achievementLevel;
    percentage = widget.data.abstinenceTime.inMinutes /
        achievementDurations.last.inMinutes;
    localizedAchDurations = List.filled(achievementDurations.length, '');
    Future.delayed(Duration.zero, () {
      setState(() {
        _getLocalizedAchievementDurations(AppLocalizations.of(context));
      });
    });
    Timer.periodic(_refreshInterval, (timer) {
      if (mounted)
        setState(() {
          percentage = widget.data.abstinenceTime.inMinutes /
              achievementDurations.last.inMinutes;
        });
    });
    super.initState();
  }

  double getVerticalPosition(double height, int level) {
    double pos = 0.0;
    for (var i = 0; i < level; i++) {
      pos += ((achievementDurations[(i + 1)].inDays -
                  achievementDurations[(i)].inDays) /
              30) *
          height;
    }
    return pos;
  }

  void _getLocalizedAchievementDurations(AppLocalizations local) {
    localizedAchDurations[0] = 'a new start!';
    for (var i = 1; i < achievementDurations.length; i++) {
      if (achievementDurations[i].inDays < 30) {
        localizedAchDurations[i] =
            ('${achievementDurations[i].inDays} ${local.day(achievementDurations[i].inDays)}');
      } else if (achievementDurations[i].inDays < 360) {
        final int inMonths = (achievementDurations[i].inDays / 30).floor();
        localizedAchDurations[i] = ('$inMonths ${local.month(inMonths)}');
      } else {
        final int inYears = (achievementDurations[i].inDays / 360).floor();
        localizedAchDurations[i] = ('$inYears ${local.year(inYears)}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    final double tileHeight = deviceSize.width;
    double totalHeight = 0.0;
    List achievementHeights = [];
    for (var i = 0; i < maxAchLevel; i++) {
      achievementHeights.add(
        tileHeight *
            (achievementDurations[i + 1] - achievementDurations[i]).in30s,
      );
      totalHeight += achievementHeights[i];
    }

    // LiquidLinearProgressIndicator is not used exclusively because when height grows waves get too steep,
    //so an AnimatedContainer is used as a progress bar and LiquidLinearProgressIndicator is put to the top of the bar to give liquid effect.
    return Scaffold(
      body: SingleChildScrollView(
        reverse: true,
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: Duration(seconds: 1),
              // TODO make a custom liquidprogressindicator that eliminates the need of the AnimatedContainer
              // LiquidLinearProgressIndicator has an unremovable border -.17 overlaps it (Pixel 4)
              bottom: totalHeight * percentage - .17,
              child: Container(
                width: deviceSize.width,
                height: tileHeight * .2,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    LiquidLinearProgressIndicator(
                      value: .8,
                      valueColor: AlwaysStoppedAnimation(
                        Theme.of(context).accentColor.withOpacity(.5),
                      ),
                      backgroundColor: Colors.transparent,
                      direction: Axis.vertical,
                    ),
                  ],
                ),
              ),
            ),
            Column(
              children: [
                Container(
                  height: tileHeight,
                  width: deviceSize.width,
                  child: Center(
                    child: FaIcon(
                      FontAwesomeIcons.checkCircle,
                      color: percentage == 1.0
                          ? Colors.amber
                          : Theme.of(context).highlightColor,
                      size: tileHeight / 2,
                    ),
                  ),
                ),
                Container(
                  height: totalHeight,
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      AnimatedContainer(
                        duration: Duration(seconds: 1),
                        height: totalHeight * percentage,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Theme.of(context).accentColor,
                              Theme.of(context).accentColor.withOpacity(.5),
                            ],
                            stops: [percentage.clamp(.0, .8), 1],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                        ),
                      ),
                      ...List<Widget>.generate(
                        maxAchLevel,
                        (index) => Positioned(
                          bottom: getVerticalPosition(tileHeight, index),
                          child: Trophy(
                            title: localizedAchDurations[index + 1],
                            // subtitle: localizedAchDurations[index + 1],
                            level: index + 1,
                            height: achievementHeights[index],
                            trophySize: Theme.of(context)
                                    .textTheme
                                    .headline3
                                    .fontSize *
                                (index + 1).clamp(0.0, deviceSize.width * .5),
                            active: index + 1 <= achLevel ? true : false,
                          ),
                        ),
                      ).reversed
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class Trophy extends StatelessWidget {
  final int level;
  final double height;
  final double trophySize;
  final bool active;
  final String title;
  final String subtitle;

  Trophy({
    this.level = 1,
    this.height = 100,
    this.trophySize = 60,
    this.active = true,
    this.title = '',
    this.subtitle = '',
  });

  @override
  Widget build(BuildContext context) {
    final color = active ? Colors.amber : Theme.of(context).highlightColor;
    final stars = List<FaIcon>.filled(
      level,
      FaIcon(
        FontAwesomeIcons.solidStar,
        color: color,
        size: trophySize * .25,
      ),
    );

    final bool isTitleOverflowed = trophySize / title.length <
        Theme.of(context).textTheme.bodyText1.fontSize;
    final bool isSubtitleOverflowed = trophySize / subtitle.length <
        Theme.of(context).textTheme.bodyText1.fontSize;

    return Container(
      height: height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Stack(
            alignment: Alignment.topCenter,
            clipBehavior: Clip.none,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  top: isTitleOverflowed
                      ? Theme.of(context).textTheme.bodyText1.fontSize *
                          (isSubtitleOverflowed ? 2 : 1)
                      : 0.0,
                ),
                child: FaIcon(
                  FontAwesomeIcons.trophy,
                  color: color,
                  size: trophySize,
                ),
              ),
              Positioned(
                top: isTitleOverflowed ? 0 : trophySize * .25,
                child: Text(
                  title,
                  style: TextStyle(
                    color: active
                        ? Colors.amber
                        : Theme.of(context).hintColor.withOpacity(.5),
                  ),
                ),
              ),
              Positioned(
                top: isSubtitleOverflowed
                    ? Theme.of(context).textTheme.bodyText1.fontSize
                    : trophySize * .4,
                child: Text(
                  subtitle,
                  style: TextStyle(
                    color: active
                        ? Colors.amber
                        : Theme.of(context).hintColor.withOpacity(.5),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            width: trophySize,
            child: Wrap(
              alignment: WrapAlignment.center,
              direction: Axis.horizontal,
              children: [
                ...stars,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
