import 'package:habit_tracker/datetime/date_time.dart';
import 'package:hive_flutter/hive_flutter.dart';

final _myBox = Hive.box("habit-tracker-database");

class HabitDatabase {
  List todayHabitList = [];

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
    if(_myBox.get(todaysDateFormatted()) == null){
     todayHabitList =  _myBox.get('current_habit_list');
      for(int i = 0 ; i<todayHabitList.length; i++){
        todayHabitList[i][1] = false;
      }
    }
    else{
      todayHabitList =  _myBox.get(todaysDateFormatted());
    }
  }

  // update the data
  void updateData() {
    // update today's habit
    _myBox.put(todaysDateFormatted(), todayHabitList);
    // update universal habit list
    _myBox.put("current_habit_list", todayHabitList);

  }
}
