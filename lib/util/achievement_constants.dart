const _achievementDurations = [
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

const _achievementNames = {
  'en': [
    '',
    'novice',
    'eager',
    'hardworking', //todo naming
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

List<Duration> get getAchievementDurations {
  return [..._achievementDurations];
}

List<String> getAchievementNames(String locale) {
  return [..._achievementNames[locale]];
}
