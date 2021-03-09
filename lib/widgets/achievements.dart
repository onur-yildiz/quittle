import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:confetti/confetti.dart';

import 'package:quittle/extensions/duration_extension.dart';
import 'package:quittle/models/addiction.dart';
import 'package:quittle/util/progress_constants.dart';

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

  initialAnimation() {
    final targetPercentage = (widget.data.abstinenceTime.inMinutes /
            achievementDurations.last.inMinutes)
        .clamp(0.0, 1.0);
    final targetLevel = widget.data.achievementLevel;
    int nextAchLevel = 1;
    Timer.periodic(Duration(milliseconds: 100), (timer) {
      if (percentage < targetPercentage && mounted) {
        setState(() {
          percentage += .01;
          if ((achievementDurations[nextAchLevel].inMinutes /
                      achievementDurations.last.inMinutes) <=
                  percentage &&
              achLevel < targetLevel) {
            achLevel = nextAchLevel;
            nextAchLevel++;
          }
        });
      } else {
        percentage.clamp(0.0, 1.0);
        timer.cancel();
      }
    });
  }

  @override
  void initState() {
    percentage = 0.0;
    achLevel = 0;
    maxAchLevel = achievementDurations.length - 1;
    initialAnimation();
    localizedAchDurations = List.filled(achievementDurations.length, '');
    Future.delayed(Duration.zero, () {
      setState(() {
        _getLocalizedAchievementDurations(AppLocalizations.of(context));
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
    localizedAchDurations[0] = 'A New Start!';
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
  void didUpdateWidget(covariant Achievements oldWidget) {
    percentage = (widget.data.abstinenceTime.inMinutes /
            achievementDurations.last.inMinutes)
        .clamp(0.0, 1.0);
    super.didUpdateWidget(oldWidget);
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
              duration: Duration(milliseconds: 100),
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
                      color: achLevel == maxAchLevel
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
                        duration: Duration(milliseconds: 100),
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

class Trophy extends StatefulWidget {
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
  _TrophyState createState() => _TrophyState();
}

class _TrophyState extends State<Trophy> {
  ConfettiController _confettiController;
  bool _isPlayed = false;

  @override
  void initState() {
    _confettiController = ConfettiController(
      duration: Duration(seconds: 1),
    );
    super.initState();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant Trophy oldWidget) {
    if (widget.active && !_isPlayed) {
      _confettiController.play();
      // _isPlayed = true;
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final color =
        widget.active ? Colors.amber : Theme.of(context).highlightColor;
    final stars = List<FaIcon>.filled(
      widget.level,
      FaIcon(
        FontAwesomeIcons.solidStar,
        color: color,
        size: widget.trophySize * .25,
      ),
    );

    final bool isTitleOverflowed = widget.trophySize / widget.title.length <
        Theme.of(context).textTheme.bodyText1.fontSize;
    final bool isSubtitleOverflowed =
        widget.trophySize / widget.subtitle.length <
            Theme.of(context).textTheme.bodyText1.fontSize;

    return ConfettiWidget(
      confettiController: _confettiController,
      blastDirectionality: BlastDirectionality.explosive,
      colors: [
        Theme.of(context).primaryColor,
        Colors.amber,
      ],
      numberOfParticles: widget.level,
      particleDrag: .1,
      gravity: .4,
      child: Container(
        height: widget.height,
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
                    size: widget.trophySize,
                  ),
                ),
                Positioned(
                  top: isTitleOverflowed ? 0 : widget.trophySize * .25,
                  child: Text(
                    widget.title,
                    style: TextStyle(
                      color: !widget.active
                          ? Theme.of(context).hintColor.withOpacity(.5)
                          : isTitleOverflowed
                              ? Colors.amber
                              : Theme.of(context).accentColor,
                    ),
                  ),
                ),
                Positioned(
                  top: isSubtitleOverflowed
                      ? Theme.of(context).textTheme.bodyText1.fontSize
                      : widget.trophySize * .4,
                  child: Text(
                    widget.subtitle,
                    style: TextStyle(
                      color: widget.active
                          ? Colors.amber
                          : Theme.of(context).hintColor.withOpacity(.5),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              width: widget.trophySize,
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
      ),
    );
  }
}
