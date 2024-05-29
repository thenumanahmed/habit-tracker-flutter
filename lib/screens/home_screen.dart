import 'package:flutter/material.dart';
import 'package:habit_tracker/components/my_alert_box.dart';
import 'package:habit_tracker/components/habit_tile.dart';
import 'package:habit_tracker/components/my_fab.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //todays list
  List todayHabitList = [
    ['Morning Walk', false],
    ['Morning Prayer', true],
  ];

  void checkBoxTapped(bool? value, int index) {
    setState(() {
      todayHabitList[index][1] = value!;
    });
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
      todayHabitList.add([_newHabitController.text, false]);
    });
    _newHabitController.clear();
    Navigator.of(context).pop();
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
              hintText: todayHabitList[index][0], // current name of habit
              textController: _newHabitController,
              onSave: () => saveExistingHabit(index),
              onCancel: cancelAlertDialog);
        });
  }

  void saveExistingHabit(int index) {
    setState(() {
      todayHabitList[index][0] = _newHabitController.text;
    });
    _newHabitController.clear();
    Navigator.of(context).pop();
  }

  void deleteHabit(int index) {
    setState(() {
      todayHabitList.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: ListView.builder(
        itemCount: todayHabitList.length,
        itemBuilder: (context, index) {
          return HabitTile(
            deleteTapped: (context) => deleteHabit(index),
            settingsTapped: (context) => editHabitName(index),
            habitName: todayHabitList[index][0],
            habitCompleted: todayHabitList[index][1],
            onChanged: (value) => checkBoxTapped(value, index),
          );
        },
      ),
      floatingActionButton: MyFloatingActionButton(
        onPressed: createNewHabit,
      ),
    );
  }
}
