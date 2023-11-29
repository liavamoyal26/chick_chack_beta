// ignore_for_file: must_be_immutable, unused_field

import 'dart:convert';
//import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';

import 'package:chick_chack_beta/main.dart';
import 'package:chick_chack_beta/models/category.dart';
import 'package:chick_chack_beta/screens/application_main.dart';
import 'package:chick_chack_beta/screens/missions/new_mission.dart';
import 'package:chick_chack_beta/styles/styled_text.dart';
import 'package:chick_chack_beta/widgets/mission_list.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:chick_chack_beta/models/mission.dart';

class Missions extends StatefulWidget {
  // עמוד הוצאות הכולל רשימת הוצאות והוספת הוצאה
  Missions({super.key, required this.date});
  DateTime date;
  @override
  State<Missions> createState() => _MissionsState();
}
//---------------------------------------------------------------------------------------------

class _MissionsState extends State<Missions> {
  List<Mission> loadedMissions = [
    // Mission(
    //   title: 'flutter course',
    //   date: DateTime.now(),
    //   time: const TimeOfDay(hour: 20, minute: 57),
    //   category: Category.study,
    //   comment: 'episod 8',
    // ),
    // Mission(
    //   title: 'drink water',
    //   date: DateTime.now(),
    //   time: const TimeOfDay(hour: 12, minute: 07),
    //   category: Category.general,
    //   comment: 'evrey hour 120 mili\'',
    // ),
    // Mission(
    //   title:
    //       'buy a fly tickets smdcklsd jsdcsd sdcndsc k ds  cdjskn cbjskcjdsscscs ',
    //   date: DateTime.now(),
    //   time: TimeOfDay.fromDateTime(DateTime.now()),
    //   category: Category.leisure,
    //   comment: '',
    // )
  ]; // all missions
  late List<Mission> todayMissions = []; //missions to picked date
  var _isLoading = true;
  String? _error;
  //----------------------------------------------
  @override
  void initState() {
    loadItems();
    setState(() {
      todayMissions = sortMissionsByDay(loadedMissions, widget.date);
    });

    super.initState();
  }

  void loadItems() async {
    final url = Uri.https('chick-chack-97c32-default-rtdb.firebaseio.com',
        'mission-list/${userConnected.uid}.json');
    try {
      final response = await http.get(url);
      if (response.statusCode >= 400) {
        setState(() {
          _error = 'Failed to fetch data. Please try again later.';
        });
      }
      if (response.body == 'null') {
        setState(() {
          _isLoading = false;
          print('response bode (missions) is emptey!!!');
        });
        return;
      }
      //------check for problems--------
      final Map<String, dynamic> listData = json.decode(response.body);
      final List<Mission> loadedItems = [];
      for (final item in listData.entries) {
        // final category = Category.entries
        //     .firstWhere(
        //         (catItem) => catItem.value.title == item.value['category'])
        //     .value;
        loadedItems.add(
          Mission(
            title: item.value['title'],
            category: CategoryList.values.byName(item.value['category']),
            comment: item.value['comment'],
            // date: DateTime(
            //   int.parse('2023'),
            //   int.parse('04'),
            //   int.parse('5'),
            // ), // -------------placeHolder----------
            date: DateTime(item.value['date-year'], item.value['date-month'],
                item.value['date-day']),
            time: TimeOfDay(
              hour: item.value['time-hour'],
              minute: item.value['time-minute'],
            ),
          ),
        );
      }
      setState(() {
        loadedMissions = loadedItems;
        _isLoading = false;
        print('items was added succesfuly to  mission list from firbase!');
      });
    } catch (error) {
      setState(() {
        _error = 'Something went wrong! Please try again later.';
      });
    }
  }
//--------------------------------------------------
  // String _addZero(String strNum) {
  //   int numInt = int.parse(strNum);
  //   String numStr = strNum.toString();
  //   if (numInt < 10) numStr = '0$num';
  //   return numStr;
  // }

  void _presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 10, now.month, now.day);
    final lastDate = DateTime(now.year + 10, now.month, now.day);
    final pickedDate = await showDatePicker(
        context: context,
        initialDate: now,
        firstDate: firstDate,
        lastDate: lastDate);
    if (pickedDate != null) {
      setState(() {
        widget.date = pickedDate;
      });
    }
  }

  void _openAddMissionOverlay() {
    showModalBottomSheet(
        //פותח את חלונית הוספת המשימה
        //useSafeArea: true,F
        isScrollControlled: true, //גורם לחלונית להיות על מסך מלא
        context: context,
        builder: (ctx) => NewMission.byDate(
              onAddMission: addMission,
              defaultDate: widget.date,
            ));
    // if (!mounted) {
    //   //---?---
    //   return;
    // }
  }

  void addMission(Mission mission) {
    // לא בשרת
    //מקבלת "משימה" ומוסיפה אותה לרשימת המשימות
    loadedMissions.add(mission);
    setState(() {
      todayMissions = sortMissionsByDay(loadedMissions, widget.date);
      // loadItems();// unessery request
    });
  }

  void _removeMission(Mission mission) async {
    final missionIndex = todayMissions.indexOf(mission); //potion
    setState(() {
      //לפי האינדקס INDEXOF נמצא את המשימה המדוברת ונסיר אותה
      todayMissions.remove(mission);
      loadedMissions.remove(mission);
    });
    print(mission.date);
    final url = Uri.https('chick-chack-97c32-default-rtdb.firebaseio.com',
        'mission-list/${userConnected.uid}.json'); //מחיקה בשרת
    var response = await http.get(url);
    final Map<String, dynamic> listData = json.decode(response.body);
    for (final item in listData.entries) {
      if (item.value['title'] == mission.title &&
          item.value['date'] == mission.date.toString().substring(0, 10)) {
        //פתרון זמני כרגע נמחק לפי שם
        http.delete(url);
      }
    }
    if (response.statusCode >= 400) {
      print('the delete went wrong');
      setState(() {
        loadedMissions.insert(missionIndex, mission);
      });
    }
    if (!mounted) {
      return;
    } else {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 2),
          content: const StyledText(
              outText: 'Mission deleted!',
              size: 25,
              color: Color.fromARGB(255, 237, 32, 17)),
          action: SnackBarAction(
            label: 'Undo',
            textColor: kColorScheme.onError,
            onPressed: () {
              setState(() {
                loadedMissions.insert(missionIndex, mission);
              });
            },
          ),
        ),
      );
    }
  }

  List<Mission> sortMissionsByDay(
      List<Mission> allMissions, DateTime chosedDate) {
    for (Mission mission in allMissions) {
      if (mission.date.day == chosedDate.day &&
          mission.date.month == chosedDate.month &&
          mission.date.year == chosedDate.year) {
        todayMissions.add(mission);
      }
    }
    return todayMissions;
  }

  @override
  Widget build(BuildContext context) {
    //בדיקה של רוחב וגובה המכשיר (בשכיבה/עמידה)
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    String dateLine =
        '${widget.date.day} / ${widget.date.month} / ${widget.date.year}';
    Widget mainContent;
    todayMissions = sortMissionsByDay(loadedMissions, widget.date);
    if (todayMissions.isNotEmpty) {
      //כאשר רשימת המשימות אינה ריקה
      mainContent = MissionsList(
        missions: todayMissions,
        onRemoveMission: _removeMission,
      );
    } else {
      mainContent = Center(
        //משתנה המכיל תוכן מסך ראשי
        child: StyledText(
            outText:
                'No Missions found. To add press on + button in the right top',
            size: 35,
            color: kColorScheme.onPrimaryContainer),
      );
    }
    return FutureBuilder(
        future: Future.delayed(const Duration(seconds: 2)),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          // if (snapshot.connectionState == ConnectionState.waiting) {
          //     return const CircularProgressIndicator();
          //   }
          return Scaffold(
            appBar: AppBar(
              title: const StyledText(
                  outText: 'MissionTracker Chick-Chack',
                  size: 25,
                  color: Colors.grey),
              actions: [
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _openAddMissionOverlay,
                  iconSize: 35,
                  color: Colors.grey,
                ),
              ],
            ),
            body: width < height // טלפון עומד
                ? Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                              onPressed: () {
                                setState(() {
                                  todayMissions = [];
                                  widget.date =
                                      widget.date.add(const Duration(days: 1));
                                  dateLine =
                                      '${widget.date.day} - ${widget.date.month} - ${widget.date.year}';
                                });
                              },
                              icon: const Icon(Icons.chevron_left)),
                          StyledText(
                              outText: dateLine,
                              size: 35,
                              color: kColorScheme.primary),
                          IconButton(
                              onPressed: () {
                                setState(() {
                                  todayMissions = []; // מנקה את המשימות הימיומיות בידיעה שיבקש מהן שוב
                                  widget.date = widget.date
                                      .subtract(const Duration(days: 1));
                                  dateLine =
                                      '${widget.date.day} - ${widget.date.month} - ${widget.date.year}';
                                });
                              },
                              icon: const Icon(Icons.chevron_right)),
                          IconButton(
                              onPressed: () async {
                                todayMissions = [];
                                _presentDatePicker();
                              },
                              icon: const Icon(Icons.calendar_month))
                        ],
                      ),
                      if (snapshot.connectionState ==
                          ConnectionState.waiting) //is waiting....
                        const Center(
                          heightFactor: 15,
                          child: CircularProgressIndicator(),
                        )
                      else //-finish waiting--
                        Expanded(
                          child: mainContent,
                        ),
                    ],
                  )
                : Row(// ----- ?? ---------------landscape-------------
                    // landscape
                    children: [
                      // Expanded(
                      //   child: Chart(Missions: loadedMissions),
                      // ),
                      Expanded(
                        //סידור מסויים
                        child: mainContent,
                      ),
                    ],
                  ),
          );
        });
  }
}
