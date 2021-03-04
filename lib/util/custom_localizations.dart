String progressNotificationMsg(int newLevel, String locale) {
  switch (locale) {
    case 'en':
      return 'You have reached $newLevel!';
      break;
    case 'tr':
      return '$newLevel. seviyeye ulaştın!';
      break;
    default:
      return '';
  }
}
