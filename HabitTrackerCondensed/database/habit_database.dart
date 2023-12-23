import 'package:flutter/material.dart';
import 'package:habit_tracker/datetime/date_time.dart';
import 'package:hive/hive.dart';


final _myBox = Hive.box("Habit_Database");

class HabitDatabase{
  List todaysHabitList = [];
  Map<DateTime, int> heatmapDataSet= {};
  //create defualt data
  void createDefaults(){
    todaysHabitList = [
      ["Clean Room", false],
      ["Read Book", false],
      ["Check MyCourses", false]
    ];

    _myBox.put("START_DATE", todayDateFormatted());
  }


  //load data
  void loadData(){
    createDefaults();
    //if its a new day get the habit lsit from the database
    if( _myBox.get(todayDateFormatted())){
      todaysHabitList = _myBox.get("CURRENT_HABIT_LIST");

      //setting all habit completed to false since it is a new day
      for(int i =0; i<todaysHabitList.length;i++ ){
        todaysHabitList[i][1] = false;
      }
    }

    else{
      todaysHabitList = _myBox.get(todayDateFormatted());
    }
  }


  //updates the database
  void updateDatabase(){
    _myBox.put(todayDateFormatted(), todaysHabitList);

    _myBox.put("CURRENT_HABIT_LIST", todaysHabitList);

    calculateHabitPercent();

    loadedHeatMap();
  }
  //update database

  void calculateHabitPercent(){
    int countCompleted = 0;
    for(int i =0; i<todaysHabitList.length; i++){
      if(todaysHabitList[i][1] == true){
        countCompleted++;
      }
    }
    String percent = todaysHabitList.isEmpty
    ? '0.0':
    (countCompleted/todaysHabitList.length).toStringAsFixed(1);

    _myBox.put("PERCENTAGE_SUMMARY_ ${todayDateFormatted()}", percent );
  }

  void loadedHeatMap(){
    DateTime startDate = createDateTimeObj(_myBox.get("START_DATE"));

    int dayBetween = DateTime.now().difference(startDate).inDays;

    for (int i=0; i<dayBetween + 1; i++){
      String yyyymmdd = covertDateTimeString(
        startDate.add(Duration(days: i))
      );

      double strength = double.parse(
        _myBox.get({"PERCENTAGE_SUMMARY_$yyyymmdd"}) ?? "0.0",
      );
       int year = startDate.add(Duration(days:i)).year;

       int month = startDate.add(Duration(days:i)).month;

       int day = startDate.add(Duration(days: i)).day;

      final percentForDay = <DateTime, int>{
        DateTime(year, month, day) : (10* strength).toInt(),
      };

      heatmapDataSet.addEntries(percentForDay.entries);

      print(heatmapDataSet);
    
    }

   
  }
}

