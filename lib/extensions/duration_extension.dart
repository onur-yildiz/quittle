extension DurationExtension on Duration {
  int get in30s {
    return (this.inDays / 30).floor();
  }
}
