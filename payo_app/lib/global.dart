class Global{


  static getIndianRupee(value) {
    final regexp = RegExp("[Rs|IN][Rs\\s|IN.](\\d+[.](\\d\\d|\\d))");
    final match = regexp.firstMatch(value);
    return double.tryParse(match.group(1));
  }

}