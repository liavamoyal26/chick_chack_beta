import 'package:chick_chack_beta/main.dart';
import 'package:chick_chack_beta/models/expense.dart';
import 'package:chick_chack_beta/models/mission.dart';
import 'package:chick_chack_beta/styles/styled_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SmallMission extends StatelessWidget {
  const SmallMission(this.mission, {super.key});

  final Mission mission;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Card(
        color: kColorScheme.secondaryContainer,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(width: screenWidth * 0.05),
            SizedBox(
              width: screenWidth * 0.6,
              child: Text(
                mission.title,
                style: GoogleFonts.averiaSansLibre(
                  color: kColorScheme.onBackground,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                softWrap: true,
              ),
            ),
            // const SizedBox(width: 20),
            StyledText(
                outText: mission.formattedHour,
                size: 20,
                color: Colors.black87),
          ],
        )
        // Padding(
        //   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        //   child:
        //   Row(
        //     //mainRow
        //     crossAxisAlignment:
        //         CrossAxisAlignment.center, //טקסט בעמודה העליונה מתחיל מצד שמאל
        //     children: [
        //       Container(
        //         constraints: const BoxConstraints(maxWidth: 200),
        //         child: Column(
        //           //left
        //           mainAxisSize: MainAxisSize.max,
        //           crossAxisAlignment: CrossAxisAlignment.start,
        //           children: [
        //             Row(
        //               //title
        //               children: [
        //                 SizedBox(
        //                   width: 200,
        //                   child: Text(
        //                     mission.title,
        //                     style: GoogleFonts.averiaSansLibre(
        //                       color: kColorScheme.onBackground,
        //                       fontSize: 30,
        //                       fontWeight: FontWeight.w800,
        //                     ), //TextStyle(fontSize: 12,fontStyle: GoogleFonts.adamina(), color: kColorScheme.onBackground,fontWeight: FontWeight.bold,) ,//Theme.of(context).textTheme.bodyMedium,
        //                     maxLines: 4,
        //                     overflow: TextOverflow.ellipsis,
        //                     softWrap: false,
        //                   ),
        //                 ),
        //               ],
        //             ),
        //             const SizedBox(height: 10),// between title and category
        //             Row(
        //               //category
        //               children: [
        //                 Icon(categoryIcons[mission.category]),
        //                 const SizedBox(width: 10),
        //                 StyledText(
        //                   outText: mission.category.toString().substring(13).toUpperCase(),
        //                   size: 25,
        //                   color: kColorScheme.secondary,
        //                 ),
        //               ],
        //             ),
        //             const SizedBox(height: 20),
        //             Row(
        //               children: [
        //                 Text(mission.comment.toString()),
        //               ],
        //             )
        //           ],
        //         ),
        //       ),
        //       //RowLeftEnds
        //       Column(
        //         //right
        //         crossAxisAlignment: CrossAxisAlignment.end,
        //         children: [
        //           Row(
        //             crossAxisAlignment: CrossAxisAlignment.end,
        //             children: [
        //               StyledText(
        //                   outText: mission.formattedHour,
        //                   size: 55,
        //                   color: Colors.black87),
        //             ],
        //           ),
        //         ],
        //       ),
        //     ],
        //   ), //mainRow
        // ),
        );
  }
}
