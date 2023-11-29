import 'package:chick_chack_beta/main.dart';
import 'package:chick_chack_beta/screens/missions/new_mission.dart';
import 'package:chick_chack_beta/styles/styled_text.dart';
import 'package:chick_chack_beta/widgets/cc_add_circles.dart';
import 'package:flutter/material.dart';

enum DefaultMissions {
  drinkWater, // לשתות מים
  takePill, // לקחת גלולה
  trainig, //אימון
  shoppingList, // רשימת קניות
  shower, // מקלחת
  waterPlants, // להשקות עציצים
  washDishes, // לשטוף כלים
  turnOffAC, // לכבות מזגן
  //יש לציין שישנן התראות שאמורות לחזור על עצמן וכאלו שהן חד פעמיות לכן צריך להוסיף LOOP !!!!!!!!!!
}

const missionsIcons = {
  DefaultMissions.drinkWater: Icons.water,
  DefaultMissions.takePill: Icons.medication,
  DefaultMissions.trainig: Icons.directions_run,
  DefaultMissions.shoppingList: Icons.shopping_cart_rounded,
  DefaultMissions.shower: Icons.shower_sharp,
  DefaultMissions.waterPlants: Icons.water_drop_outlined,
  DefaultMissions.washDishes: Icons.dining_sharp,
  DefaultMissions.turnOffAC: Icons.ac_unit_rounded,
};

const missionsTitle = {
  DefaultMissions.drinkWater: 'Drink \n water',
  DefaultMissions.takePill: 'Take \n a pill',
  DefaultMissions.trainig: 'Tarning',
  DefaultMissions.shoppingList: 'Shop \n List',
  DefaultMissions.shower: 'Take a \n shower',
  DefaultMissions.waterPlants: 'Water \nthe plants',
  DefaultMissions.washDishes: 'wash the\n Dishes',
  DefaultMissions.turnOffAC: 'Turn off\n the AC',
};

class CCAddMission extends StatefulWidget {
  const CCAddMission({super.key, required this.studentFeatures});
  final bool studentFeatures;

  @override
  State<CCAddMission> createState() => _CCAddMissionState();
}

class _CCAddMissionState extends State<CCAddMission> {
  void _openNewMissionOverlay(BuildContext context) {
    showModalBottomSheet(
      //פותח את חלונית הוספת המשימה
      //useSafeArea: true,F
      isScrollControlled: true, //גורם לחלונית להיות על מסך מלא
      context: context,
      builder: (ctx) => NewMission.byDefualtTitle(
        onAddMission: (mission) {}, //<-------------check this
        title: missionsTitle[DefaultMissions.drinkWater]!,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Center(
              child: StyledText(
                  outText: 'הוספה בציק צק',
                  size: 35,
                  color: kColorScheme.primaryContainer))),
      backgroundColor: kColorScheme.primaryContainer,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CCAddCircle(
                  subject: missionsTitle[DefaultMissions.drinkWater]!,
                  icon: Icon(missionsIcons[DefaultMissions.drinkWater]!),
                  onPressed: () {
                    _openNewMissionOverlay(context);
                  },
                ),
                CCAddCircle(
                  subject: missionsTitle[DefaultMissions.takePill]!,
                  icon: Icon(missionsIcons[DefaultMissions.takePill]!),
                  onPressed: () {
                    _openNewMissionOverlay(context);
                  },
                ),
              ],
            ),
           Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CCAddCircle(
                  subject: missionsTitle[DefaultMissions.shoppingList]!,
                  icon: Icon(missionsIcons[DefaultMissions.shoppingList]!),
                  onPressed: () {
                    _openNewMissionOverlay(context);
                  },
                ),
                CCAddCircle(
                  subject: missionsTitle[DefaultMissions.trainig]!,
                  icon: Icon(missionsIcons[DefaultMissions.trainig]!),
                  onPressed: () {
                    _openNewMissionOverlay(context);
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CCAddCircle(
                  subject: missionsTitle[DefaultMissions.turnOffAC]!,
                  icon: Icon(missionsIcons[DefaultMissions.turnOffAC]!),
                  onPressed: () {
                    _openNewMissionOverlay(context);
                  },
                ),
                CCAddCircle(
                  subject: missionsTitle[DefaultMissions.shower]!,
                  icon: Icon(missionsIcons[DefaultMissions.shower]!),
                  onPressed: () {
                    _openNewMissionOverlay(context);
                  },
                ),
              ],
            ),
           Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CCAddCircle(
                  subject: missionsTitle[DefaultMissions.waterPlants]!,
                  icon: Icon(missionsIcons[DefaultMissions.waterPlants]!),
                  onPressed: () {
                    _openNewMissionOverlay(context);
                  },
                ),
                CCAddCircle(
                  subject: missionsTitle[DefaultMissions.washDishes]!,
                  icon: Icon(missionsIcons[DefaultMissions.washDishes]!),
                  onPressed: () {
                    _openNewMissionOverlay(context);
                  },
                ),
              ],
            ),  
          ],
        ),
      ),
    );
  }
}
