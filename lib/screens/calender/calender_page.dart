
import 'dart:convert';

import 'package:chick_chack_beta/main.dart';
import 'package:chick_chack_beta/models/category.dart';
import 'package:chick_chack_beta/models/mission.dart';
import 'package:chick_chack_beta/screens/application_main.dart';
import 'package:chick_chack_beta/screens/missions/new_mission.dart';
import 'package:chick_chack_beta/styles/styled_text.dart';
import 'package:chick_chack_beta/widgets/mission_list.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:http/http.dart' as http;

class PageCalendar extends StatefulWidget {
  const PageCalendar({super.key});

  @override
  State<PageCalendar> createState() => _PageCalendarState();
}

class _PageCalendarState extends State<PageCalendar> {
  DateTime today = DateTime.now();
  List<Mission> missions = [];

  @override
  void initState() {
    _loadMission();
    super.initState();
  }

  void _loadMission() async {
    final url = Uri.https('chick-chack-97c32-default-rtdb.firebaseio.com',
        'mission-list/${userConnected.uid}.json');
    try {
      final response = await http.get(url);
      //print(response.body);
      if (response.statusCode >= 400) {
        print('Failed to fetch data. Please try again later.');
      }
      if (response.body == 'null') {
        print('response bode (missions) is emptey!!!');
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
            date: DateTime(item.value['date-year'], item.value['date-month'],
                item.value['date-day']),
            time: TimeOfDay(
              hour: item.value['time-hour'],
              minute: item.value['time-minute'],
            ),
          ),
        );
      }
      // setState(() {
      missions = loadedItems;
      print('items was added succesfuly to  mission list from firbase!');
      // });
    } catch (error) {
      // setState(() {
      print('Something went wrong! Please try again later.');
      //  });
    }
  }

  List<Mission> sortedMissionByDate(List<Mission> allMissions, DateTime date) {
    List<Mission> _missionsToday = [];
    for (Mission mission in allMissions) {
      if (mission.date.day == date.day &&
          mission.date.month == date.month &&
          mission.date.year == date.year) {
        setState(() {
          _missionsToday.add(mission);
        });
      }
    }
    return _missionsToday;
  }

  void _onDaySelected(DateTime day, DateTime focusedDay) {
    setState(() {
      today = day;
    });
  }

  void _showMissionSorted(DateTime day, DateTime focusedDay) {
    var missionSorted = sortedMissionByDate(missions, day);
    missionSorted.isNotEmpty
        ? showModalBottomSheet(
            backgroundColor: const Color.fromARGB(0, 255, 255, 255),
            // shape: const CircleBorder(),
            context: context,
            builder: (ctx) => MissionsList(
                  missions: missionSorted,
                  onRemoveMission: (mission) {},
                ))
        : showModalBottomSheet(
            backgroundColor: kColorScheme.error,
            context: context,
            builder: (ctx) => const StyledText(
                  outText: '! אין משימות ביום זה',
                  size: 25,
                  color: Colors.white,
                ));
    print('--No Mission exist this day--');
  }

  void _addMissionByDate(DateTime pickedDay) {
    showModalBottomSheet(
        //פותח את חלונית הוספת המשימה
        //useSafeArea: true,F
        isScrollControlled: true, //גורם לחלונית להיות על מסך מלא
        context: context,
        builder: (ctx) => NewMission.byDate(
              onAddMission: (mission) {}, //<-------------check this
              defaultDate: pickedDay,
            ));
    if (!mounted) {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: const StyledText.title('Calendar'), actions: [
        ElevatedButton.icon(
            onPressed: () {
              _addMissionByDate(today);
            },
            icon: const Icon(Icons.add_circle_outline_rounded),
            label: const Text('Add\nMission'))
      ]),
      body: content(),// בעצם מכיל את כל תוכן הwidget
    );
  }

  Widget content() {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    String dateLine = '${today.day} - ${today.month} - ${today.year}';

    return SingleChildScrollView(
      child: Column(
        children: [
          // StyledText.title(today.toString().split(" ")[0]),
          StyledText.title(dateLine.toString()),
          TableCalendar(
            // calendarStyle: const CalendarStyle(
            //  selectedDecoration: BoxDecoration(color: Colors.black38, shape: BoxShape.circle),
            // ),
            rowHeight: 60,
            onDayLongPressed: _showMissionSorted,
            // _addMissionByDate, //-----------------need to be back-------------------------
            //currentDay: today,
            headerStyle: const HeaderStyle(
                formatButtonVisible: false, titleCentered: true),
            availableGestures: AvailableGestures.all,
            //locale: "hebrew",
            selectedDayPredicate: (day) => isSameDay(day, today),
            firstDay: DateTime.utc(2010, 10, 16),
            lastDay: DateTime.utc(2030, 3, 14),
            focusedDay: today,
            onDaySelected: _onDaySelected,
            // calendarBuilders: CalendarBuilders(
            //   defaultBuilder: (context, day, focusedDay) {
            //     if ( sortedMissionByDate(missions, day).isNotEmpty) {
            //       return Container(
            //         decoration: const BoxDecoration(
            //           color: Color.fromARGB(255, 195, 74, 74),
            //           borderRadius: BorderRadius.all(
            //             Radius.circular(8.0),
            //           ),
            //         ),
            //         child: Center(
            //           child: Text(
            //             '${day.day}',
            //             style: const TextStyle(color: Color.fromARGB(255, 209, 17, 235)),
            //           ),
            //         ),
            //       );
            //     }
            //     return null;
            //   },
            // ),
            //----------------------
          ),
        ],
      ),
    );
  }
}
