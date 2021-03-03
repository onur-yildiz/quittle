class Settings {
  String currency;
  bool receiveProgressNotifs;
  bool receiveQuoteNotifs;

  Settings({
    String currency,
    bool receiveProgressNotifs,
    bool receiveQuoteNotifs,
  }) {
    this.currency = currency ?? 'USD';
    this.receiveProgressNotifs = receiveProgressNotifs ?? true;
    this.receiveQuoteNotifs = receiveQuoteNotifs ?? true;
  }
}
