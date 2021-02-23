extension StringExtension on String {
  String capitalizeWords() {
    final List words = this.split(' ');
    List capitalizedWords = [];
    words.forEach((word) {
      capitalizedWords
          .add('${word[0].toUpperCase()}${word.substring(1).toLowerCase()}');
    });
    return capitalizedWords.join(' ');
  }

  String capitalizeFirstLetter() {
    return '${this[0].toUpperCase()}${this.substring(1).toLowerCase()}';
  }
}
