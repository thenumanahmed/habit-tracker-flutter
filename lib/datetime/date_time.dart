// return todays date formatted as yyyymmdd
String todaysDateFormatted() {
  var dateTimeObject = DateTime.now();

  String year = dateTimeObject.year.toString();
  String month = dateTimeObject.month.toString();
  if (month.length == 1) {
    month = "0$month";
  }
  String day = dateTimeObject.day.toString();
  if (day.length == 1) {
    day = "0$day";
  }
  // final format
  String yyyymmdd = year + month + day;
  return yyyymmdd;
}

// convert string yyyymmdd to DatetimeObject
DateTime createDateTimeObject(String yyyymmdd) {
  int yyyy = int.parse(yyyymmdd.substring(0, 4));
  int mm = int.parse(yyyymmdd.substring(4, 6));
  int dd = int.parse(yyyymmdd.substring(6, 8));

  DateTime dateTimeObject = DateTime(yyyy, mm, dd);
  return dateTimeObject;
}

// convert DatetimeObject to string yyyymmdd
String convertDateTimeToString(DateTime dateTime) {
  String year = dateTime.year.toString();
  String month = dateTime.month.toString();
  String day = dateTime.day.toString();

  if (day.length == 1) day = "0$day";
  if (month.length == 1) month = "0$month";

  // final format
  String yyyymmdd = year + month + day;
  return yyyymmdd;
}
