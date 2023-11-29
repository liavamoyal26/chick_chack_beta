// ignore_for_file: unused_local_variable

import 'dart:convert';

import 'package:chick_chack_beta/main.dart';
import 'package:chick_chack_beta/models/category.dart';
import 'package:chick_chack_beta/models/mission.dart';
import 'package:chick_chack_beta/screens/calender/calender_page.dart';
import 'package:chick_chack_beta/screens/chick_chack_add.dart';
import 'package:chick_chack_beta/screens/first_time.dart';
import 'package:chick_chack_beta/screens/missions/missions.dart';
import 'package:chick_chack_beta/screens/settings/settings.dart';
import 'package:chick_chack_beta/screens/student/student_page.dart';
import 'package:chick_chack_beta/screens/waiting_screen.dart';
import 'package:chick_chack_beta/styles/styled_text.dart';
import 'package:chick_chack_beta/screens/expenses/expenses.dart';
import 'package:chick_chack_beta/widgets/small_mission_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';


final userConnected =
    FirebaseAuth.instance.currentUser!; //to get the unique token
//final _token = _user.uid;
// final userConnectedDetails =
//     FirebaseFirestore.instance.collection('users').doc(userConnected.uid).get();

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

@override
class _MainAppState extends State<MainApp> {
  bool isStudent = false;
  late String userName; // late = will get a value in future!
  late String email;
  List<Mission> allMissions = [];
  List<Mission> todayMissionsSorted = [];

  @override
  void initState() {
    setState(() {
      //refresh
    });
    _loadMission();
    showUserName();
    getemail();
    _loadIsStudent();
    super.initState();
  }

  void _loadMission() async {
    final url = Uri.https('chick-chack-97c32-default-rtdb.firebaseio.com',
        'mission-list/${userConnected.uid}.json');
    try {
      final response = await http.get(url);
      if (response.statusCode >= 400) {
        print('Failed to fetch data. Please try again later.');
      }
      if (response.body == 'null') {
        print('response bode (allmissions) is emptey!!!');
        return;
      }
      //------check for problems--------
      final Map<String, dynamic> listData = json.decode(response.body);
      final List<Mission> loadedItems = [];
      for (final item in listData.entries) {
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
      setState(() {
        allMissions = loadedItems;
        print('items was added succesfuly to  mission list from firbase!');
      });
    } catch (error) {
      // setState(() {
      print('Something went wrong! Please try again later.');
      //  });
    }
  }

  List<Mission> missionsSortedToday(List<Mission> missions) {
    List<Mission> sortedList = [];
    final String today = DateTime.now().toString().substring(0, 10);
    for (final mission in missions) {
      if (mission.date.toString().substring(0, 10) == today) {
        sortedList.add(mission);
      }
    }
    print(missions.length);
    setState(() {
      todayMissionsSorted = sortedList;
    });
    return todayMissionsSorted;
  }

  void _loadIsStudent() async {
    final bool flag = await FirebaseFirestore.instance
        .collection('users')
        .doc(userConnected.uid)
        .get()
        .then((value) {
      return value.data()!['is_student'];
    });
    if (flag) {
      setState(() {
        isStudent = true;
      });
    }
    return;
  }

  void showUserName() async {
    userName = await FirebaseFirestore.instance
        .collection('users')
        .doc(userConnected.uid)
        .get()
        .then((value) {
      return value
          .data()!['user_name']
          .toUpperCase(); // data() make all data to map (server) -> user_name = key
    });
  }

  void getemail() async {
    email = await FirebaseFirestore.instance
        .collection('users')
        .doc(userConnected.uid)
        .get()
        .then((value) {
      return value.data()!['email'];
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    missionsSortedToday(allMissions);

    return FutureBuilder(
        future: Future.delayed(const Duration(seconds: 2)),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const WaitingScreen();
            //Splash Screen
          } else {
            return Scaffold(
              body: SingleChildScrollView(
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: const AssetImage('assets/openScreen.png'),
                        colorFilter: ColorFilter.mode(
                            kColorScheme.secondaryContainer,
                            BlendMode.colorDodge),
                        opacity: 240,
                        fit: BoxFit.fill),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          StyledText(
                              outText: 'ברוך שובך \n ${userName.toUpperCase()}',
                              size: 18,
                              color: kColorScheme.secondary),
                          SizedBox(width: screenWidth / 9),
                          TextButton.icon(
                            onPressed: () {
                              FirebaseAuth.instance.signOut();
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const IsFirstTime()));
                            },
                            icon: const Icon(Icons.exit_to_app),
                            label: const Text('Log Out',
                                style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold)),
                            style: TextButton.styleFrom(iconColor: Colors.red),
                            // Theme.of(context).colorScheme.primary),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      if (screenWidth < screenHeight) //not landscape
                        StyledText(
                          outText: 'everything \n Chick-Chack'.toUpperCase(),
                          size: 45,
                          color: kColorScheme.onBackground,
                        ),
                      Center(
                          child: Text(
                        'משימות היום',
                        style: TextStyle(
                            color: kColorScheme.primary,
                            fontSize: 35,
                            fontWeight: FontWeight.bold),
                      )),
                      Container(
                        color: kColorScheme.primary.withOpacity(0.4),
                        height: screenHeight * 0.25,
                        width: screenWidth * 0.9,
                        child: todayMissionsSorted
                                .isNotEmpty // רשימת המשימות היומית אינה ריקה
                            ? ListView.builder(
                                itemCount: todayMissionsSorted.length,
                                itemBuilder: (context, index) {
                                  return SmallMission(
                                      todayMissionsSorted[index++]);
                                },
                              )
                            : const Center(child: Text('...אין משימות בקרוב')),
                      ),
                      const SizedBox(height: 25),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          TextButton.icon(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (ctx) => const Expenses(),
                                ),
                              );
                            },
                            label: const Text(
                              'מעקב \n הוצאות',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            icon: Icon(Icons.attach_money_rounded,
                                size: 55, color: Colors.grey.shade700),
                          ),
                          TextButton.icon(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (ctx) =>
                                      Missions(date: DateTime.now()),
                                ),
                              );
                            },
                            label: const Text(
                              'מעקב \n משימות',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            icon: Icon(Icons.check_box_outlined,
                                size: 50, color: Colors.grey.shade700),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      isStudent
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Container(
                                  color: Colors.black.withOpacity(0.1),
                                  child: TextButton.icon(
                                    onPressed: () {
                                      // print('student featture');
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (ctx) => const StudentPage(),
                                        ),
                                      );
                                    },
                                    label: const Text(
                                      'לו"ז \n סטודנט',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    icon: const Icon(Icons.school_outlined,
                                        size: 72),
                                  ),
                                ),
                                Container(
                                  color: Colors.black.withOpacity(0.1),
                                  child: TextButton.icon(
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (ctx) => CCAddMission(
                                              studentFeatures: isStudent),
                                        ),
                                      );
                                      // print('---quick add mission---');
                                    },
                                    icon: const Icon(
                                      Icons.add,
                                      size: 75,
                                    ),
                                    label: const Text('הוספה\nבציק צק',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20)),
                                  ),
                                ),
                              ],
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  color: Colors.black.withOpacity(0.1),
                                  child: TextButton.icon(
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (ctx) => CCAddMission(
                                              studentFeatures: isStudent),
                                        ),
                                      );
                                      // print('---quick add mission---');
                                    },
                                    icon: const Icon(
                                      Icons.add,
                                      size: 75,
                                    ),
                                    label: const Text('הוספה\nבציק צק',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20)),
                                  ),
                                ),
                              ],
                            ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          TextButton.icon(
                            onPressed: () {
                              //print('---calender---');
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (ctx) => const PageCalendar(),
                                ),
                              );
                            },
                            label: const Text(
                              'לוח \n שנה',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            icon: Icon(Icons.calendar_month_outlined,
                                size: 50, color: Colors.grey.shade700),
                          ),
                          TextButton.icon(
                            onPressed: () async {
                              //print('---settings---');
                              bool flag = await Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (ctx) =>
                                      SettingCC(isStudentSettings: isStudent),
                                ),
                              );
                              if (isStudent != flag) {
                                setState(() {
                                  isStudent = flag;
                                });
                              }
                            },
                            label: const Text(
                              'הגדרות',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            icon: Icon(Icons.settings,
                                size: 50, color: Colors.grey.shade700),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        });
  }
}
