import 'package:chick_chack_beta/main.dart';
import 'package:chick_chack_beta/screens/missions/new_mission.dart';
import 'package:chick_chack_beta/styles/styled_text.dart';
import 'package:flutter/material.dart';
//import 'package:google_fonts/google_fonts.dart';

class CCAddCircle extends StatelessWidget {
  const CCAddCircle(
      {super.key,
      required this.subject,
      required this.icon,
      required this.onPressed});

  final Icon icon;
  final String subject;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: screenWidth/15 , vertical: screenHeight/100),
      child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: kColorScheme.inversePrimary,
            shape: const CircleBorder(),
            fixedSize: Size(screenWidth/3 , screenHeight/ 5 )
          ),
          onPressed: onPressed,
          icon: icon,
          label: StyledText(
              outText: subject, size: 21, color: kColorScheme.primary)),
    );

    // return Card(
    //     surfaceTintColor: kColorScheme.background, // nothing
    //     margin: const EdgeInsets.all(20),
    //     color: kColorScheme.inversePrimary,
    //     shape: const CircleBorder(),
    //     child: Padding(
    //       padding: EdgeInsets.symmetric(
    //           horizontal: screenWidth * 0.07, vertical: screenHeight * 0.05),
    //       child: TextButton.icon(
    //         onPressed: () {
    //           Navigator.of(context).push(
    //             MaterialPageRoute(
    //               builder: (ctx) => NewMission.byDefualtTitle(
    //                   title: subject,
    //                   onAddMission: (mission) {}), // check onaddmission
    //             ),
    //           );
    //         },
    //         icon: const Icon(Icons.medication_rounded),
    //         label: StyledText(
    //             outText: subject, size: 21, color: kColorScheme.primary),
    //       ),
    //     )
    //     //StyledText(outText: subject, size: 20, color: Colors.black),
    //    );
  }
}
