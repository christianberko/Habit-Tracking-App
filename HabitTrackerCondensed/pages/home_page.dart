import 'package:flutter/material.dart';
import 'package:habit_tracker/components/button.dart';
import 'package:habit_tracker/components/calandar.dart';
import 'package:habit_tracker/components/habit_tile.dart';
import 'package:habit_tracker/components/alert_box.dart';
import 'package:habit_tracker/database/habit_database.dart';
import 'package:habit_tracker/pages/profile_page.dart';
import 'package:hive/hive.dart';


class HomePage extends StatefulWidget{
  const HomePage({super.key}); 

  @override
  State<HomePage> createState() => _HomePageState();

}

class _HomePageState extends State<HomePage>{
//
HabitDatabase db = HabitDatabase();
final _myBox = Hive.box("Habit_Database");



void initState(){
  //if there is no curent list then it the 1st time ever opening the app;
  if(_myBox.get("CURRENT_HABIT_LIST") == null){
    db.createDefaults();
  }

  else{
    db.loadData();
  }
  super.initState();
}
//method for checkbox
  void checkBoxTapped(bool? value, int index){
    setState(() {
      db.todaysHabitList[index][1]= value;

    });

    db.updateDatabase();
  }

//creating a new habit
final newHabitController = TextEditingController();

//method to add new habit 
void createNewHabit(){
    showDialog(
      context: context,
      builder: (context){
      return AlertBox(
        hintText: 'Enter Habit Name',
        controller: newHabitController,
        onSave: saveNewHabit,
        onCancel: cancelDialogBox ,
      );
        
    },
  );
}
void saveNewHabit(){
  //clear TextField. 
  setState(() {
    db.todaysHabitList.add([newHabitController.text, false]);
  });
  newHabitController.clear();
  Navigator.of(context).pop();
  
  db.updateDatabase();
}

void cancelDialogBox(){
  //clear TextField. 
  newHabitController.clear();
  Navigator.of(context).pop();

}
//open setting s
void openSettings(int index){
  showDialog(
    context: context, 
    builder: (context){
      return AlertBox(
        controller: newHabitController,
        onSave:  () => saveExistingHabit(index),
        onCancel: cancelDialogBox ,
        hintText: db.todaysHabitList[index][0],
      );
        
      
    },
  );
}
//save existing habit
void saveExistingHabit(int index){
  setState(() {
    db.todaysHabitList[index][0] = newHabitController.text;

  });
  newHabitController.clear();
  Navigator.pop(context);
  db.updateDatabase();
}

//delete a habit
void deleteHabit(int index){
  setState(() {
    db.todaysHabitList.removeAt(index);
  });
  db.updateDatabase();
}

  @override
  Widget build(BuildContext context){


    List HabitLIST = [
      ["Running", false],
      ["Read book", false]

    ];
    return Scaffold(
      backgroundColor: Colors.grey[300],
      floatingActionButton: MyFloatingActionButton(onPressed: createNewHabit),
      body: ListView(
        children: [

          //monthly summary heatmap
          MonthlySummary(datasets: db.heatmapDataSet, startDate: _myBox.get("START_DATE")),

          //list of the habits
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics() ,
            itemCount: db.todaysHabitList.length,
            itemBuilder: (context, index){
            return HabitTile(
              habitName: db.todaysHabitList[index][0], 
              habitCompleted: db.todaysHabitList[index][1], 
              onChanged: (value) => checkBoxTapped(value, index),
              settingsTapped: (context) => openSettings(index),
              deleteTapped: (context)=>deleteHabit(index),
          );
        },
      ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        onTap: (index) {
          switch (index) {
            case 0:
              // Navigate to Home Page
              break;
            case 1:
              // Navigate to Profile Page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage()),
              );
              break;
          }
        }
      ),
    );
  }
}