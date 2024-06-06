import 'package:habit_tracker/datetime/date_time.dart';
import 'package:hive_flutter/hive_flutter.dart';

final _myBox = Hive.box("habit-tracker-database");

class HabitDatabase {
  List todayHabitList = [];
  Map<DateTime, int> heatMapDataSet = {};

  // create initial default data
  void createDefaultData() {
    todayHabitList = [
      ["Morning Walk", false],
      ["Read Book", false]
    ];
    // starting date of tracking habits
    _myBox.put('START_DATE', todaysDateFormatted());
  }

  // load data
  void loadData() {
    // if new date => todays habit equal to false
    if (_myBox.get(todaysDateFormatted()) == null) {
      todayHabitList = _myBox.get('current_habit_list');
      for (int i = 0; i < todayHabitList.length; i++) {
        todayHabitList[i][1] = false;
      }
    } else {
      todayHabitList = _myBox.get(todaysDateFormatted());
    }
  }

  // update the data
  void updateData() {
    // update today's habit
    _myBox.put(todaysDateFormatted(), todayHabitList);
    // update universal habit list
    _myBox.put("current_habit_list", todayHabitList);

    // calculate habit complete percentages for each day
    calculateHabitPercentages();

    //load the heat map
    loadHeatMap();
  }

  void calculateHabitPercentages() {
    int countCompleted = 0;
    for (int i = 0; i < todayHabitList.length; i++) {
      if (todayHabitList[i][1] == true) {
        countCompleted++;
      }
    }
    String percentage = todayHabitList.isEmpty
        ? '0.0'
        : (countCompleted / todayHabitList.length).toStringAsFixed(1);
    // KEY: "PERCENTAGE_SUMMARY_yyyymmdd
    // value: string of 1dp number between 0.0-1.0 inclusive
    _myBox.put("PERCENTAGE_SUMMARY_${todaysDateFormatted()}", percentage);
  }

  void loadHeatMap() {
    print('loading');
    DateTime startDate = createDateTimeObject(_myBox.get("START_DATE"));
    int daysInBetween = DateTime.now().difference(startDate).inDays;

    print(daysInBetween);
    for (int i = 0; i <=daysInBetween; i++) {
      String yyyymmdd =
          ConvertDateTimeToString(startDate.add(Duration(days: i)));

      double strengthAsPercent =
          double.parse(_myBox.get("PERCENTAGE_SUMMARY_$yyyymmdd") ?? "0.0");

      // split the datetime up like below so it doesn't worry about hours/mins/secs etc
      // year
      int year = startDate.add(Duration(days: i)).year;
      // month
      int month = startDate.add(Duration(days: i)).month;
      // day
      int day = startDate.add(Duration(days: i)).day;

      final percentageForEachDay = <DateTime,int> {
        DateTime(year,month,day):(10*strengthAsPercent).toInt(),
      };
      print('adding');
      heatMapDataSet.addEntries(percentageForEachDay.entries);
      print(heatMapDataSet);
    }
  }
}
