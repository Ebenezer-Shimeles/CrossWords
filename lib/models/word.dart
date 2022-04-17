class Word {
  String spelling;
  int startPos, startCross;
  String direction;
  String hint;
  bool answerd = false;
  Word(
      this.spelling, this.startPos, this.direction, this.hint, this.startCross);
  static Word fromJson(String spelling, String direction, int startPos,
      String hint, int startCross) {
    /*
         {
            "spelling": "Eben",
            "direction": "H",
            "startPos": 1,
            "hint": "Awesome person"
        }
    */
    final word = new Word(spelling, startPos, direction, hint, startCross);
    return word;
  }

  @override
  String toString() {
    // TODO: implement toString
    return "Word: ${this.spelling}";
  }
}
