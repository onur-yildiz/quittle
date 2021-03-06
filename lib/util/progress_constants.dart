const _levelDurations = [
  Duration(days: 0),
  Duration(days: 1),
  Duration(days: 3),
  Duration(days: 7),
  Duration(days: 30),
  Duration(days: 60),
  Duration(days: 90),
  Duration(days: 180),
  Duration(days: 270),
  Duration(days: 360),
];

List<Duration> get levelDurations {
  return [..._levelDurations];
}

const _levelNames = {
  'en': [
    '',
    'novice',
    'eager',
    'hardworking',
    'determined',
    'experienced',
    'expert',
    'free mind',
    'free body',
    'free spirit',
  ],
  'tr': [
    '',
    'acemi',
    'istekli',
    'çalışkan',
    'kararlı',
    'deneyimli',
    'uzman',
    'özgür zihin',
    'özgür beden',
    'özgür ruh',
  ]
};

List<String> getLevelNames(String locale) {
  return [..._levelNames[locale]];
}

const _achievementDurations = [
  Duration(days: 0),
  Duration(days: 30),
  Duration(days: 60),
  Duration(days: 90),
  Duration(days: 180),
  Duration(days: 270),
  Duration(days: 360),
];

List<Duration> get achievementDurations {
  return [..._achievementDurations];
}

Duration tillNextAchievement(int achievementIndex) {
  return _achievementDurations[achievementIndex + 1] -
      _achievementDurations[achievementIndex];
}
