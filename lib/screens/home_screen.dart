import 'package:flutter/material.dart';
import 'package:habit_tracker/components/monthly_summary.dart';
import 'package:habit_tracker/components/my_alert_box.dart';
import 'package:habit_tracker/components/habit_tile.dart';
import 'package:habit_tracker/components/my_fab.dart';
import 'package:habit_tracker/data/habit_database.dart';
import 'package:hive/hive.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HabitDatabase db = HabitDatabase();
  final _myBox = Hive.box('habit-tracker-database');

  @override
  void initState() {
    // 1st time open? => use default databse
    if (_myBox.get('current_habit_list') == null) {
      db.createDefaultData();
    } else {
      db.loadData();
    }
    db.updateData();

    super.initState();
  }

  void checkBoxTapped(bool? value, int index) {
    setState(() {
      db.todayHabitList[index][1] = value!;
    });
    db.updateData();
  }

  final _newHabitController = TextEditingController();
  void createNewHabit() {
    showDialog(
        context: context,
        builder: (context) {
          return MyAlertBox(
            hintText: "Enter New Habit Name",
            textController: _newHabitController,
            onCancel: cancelAlertDialog,
            onSave: saveNewHabit,
          );
        });
  }

  void saveNewHabit() {
    setState(() {
      db.todayHabitList.add([_newHabitController.text, false]);
    });
    _newHabitController.clear();
    Navigator.of(context).pop();
    db.updateData();
  }

  void cancelAlertDialog() {
    _newHabitController.clear();
    Navigator.of(context).pop();
  }

  void editHabitName(int index) {
    showDialog(
        context: context,
        builder: (context) {
          return MyAlertBox(
              hintText: db.todayHabitList[index][0], // current name of habit
              textController: _newHabitController,
              onSave: () => saveExistingHabit(index),
              onCancel: cancelAlertDialog);
        });
  }

  void saveExistingHabit(int index) {
    setState(() {
      db.todayHabitList[index][0] = _newHabitController.text;
    });
    _newHabitController.clear();
    Navigator.of(context).pop();
    db.updateData();
  }

  void deleteHabit(int index) {
    setState(() {
      db.todayHabitList.removeAt(index);
    });
    db.updateData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: ListView(
        children: [
          // monthly summary heatmap
          MonthkySummary(datasets: db.heatMapDataSet , startDate: _myBox.get("START_DATE")),

          // habits lists
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: db.todayHabitList.length,
            itemBuilder: (context, index) {
              return HabitTile(
                deleteTapped: (context) => deleteHabit(index),
                settingsTapped: (context) => editHabitName(index),
                habitName: db.todayHabitList[index][0],
                habitCompleted: db.todayHabitList[index][1],
                onChanged: (value) => checkBoxTapped(value, index),
              );
            },
          ),
        ],
      ),
      floatingActionButton: MyFloatingActionButton(
        onPressed: createNewHabit,
      ),
    );
  }
}
