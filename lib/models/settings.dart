class Settings {
  String currency;

  Settings({
    currency,
  }) {
    this.currency = currency ?? 'USD';
  }
}
