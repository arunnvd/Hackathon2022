final Map<int, String> monthList = {
  1: 'JAN',
  2: 'FEB',
  3: 'MAR',
  4: 'APR',
  5: 'MAY',
  6: 'JUN',
  7: 'JUL',
  8: 'AUG',
  9: 'SEP',
  10: 'OCT',
  11: 'NOV',
  12: 'DEC',
};

String getFormatedDateString(String dateTime) {
  var parsedDate = DateTime.parse(dateTime);
  String formatedDateString =
      '${parsedDate.day} - ${monthList[parsedDate.month]!} - ${parsedDate.year}';
  //print(monthList[parsedDate.month]);
  return formatedDateString;
}
