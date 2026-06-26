extension StringExtensions on String {
  
  
  
  String getFirstXLetters(int number, {bool addThreeDots = false}) {
    assert(number >= 0, 'Number must be greater than or equal to 0');

    return '''${substring(0, length < number ? length : number)}${length > number && addThreeDots ? '...' : ''}''';
  }
}
