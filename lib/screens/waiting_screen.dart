
// ignore_for_file: unused_local_variable

import 'package:chick_chack_beta/main.dart';
// ignore: unused_import
import 'package:chick_chack_beta/screens/first_time.dart';
import 'package:chick_chack_beta/styles/styled_text.dart';
import 'package:flutter/material.dart';
// import 'package:splashscreen/splashscreen.dart';
// import 'package:google_fonts/google_fonts.dart';

class WaitingScreen extends StatelessWidget {
  const WaitingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width; // get size screen to user
    final screenHeight = MediaQuery.of(context).size.height;// get size screen to user
    return
        // SplashScreen(
        //   seconds: 2,
        //   navigateAfterSeconds: const FirstTime(),
        //   backgroundColor: kColorScheme.primaryContainer,
        //   title: Text(
        //     'Chick Chack',
        //     style: GoogleFonts.aladin(color: Colors.black, fontSize: 65),
        //   ),
        //   image: Image.asset('assets/openScreen.png'),
        //   loaderColor: kColorScheme.prim,
      Scaffold(
      //color: kColorScheme.secondaryContainer,
      body: 
      //SingleChildScrollView(
        Padding(padding: const EdgeInsets.only(top: 10,bottom: 10),
        child: 
       // screenWidth < screenHeight// not landscape [ stand ]
         Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(height:  screenHeight*0.1),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                 StyledText(
                    outText: 'Chick Chack', size: 65, color: Colors.black),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              width: screenHeight*0.35 , //circle
              height: screenHeight*0.35,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: (Colors.white),
                //borderRadius: BorderRadius.all(Radius.circular(20))
              ),
              child: Center(
                child: Image.asset(
                  'assets/openScreen.png',
                  width: screenHeight*0.25, //picture
                  height: screenHeight*0.3,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            //child: StayledText('welcome to Liav\'s app '),
            const SizedBox(height: 20),
            Text('האפליקציה שתעשה לכם \n סדר יום\n בצ\'יק צ\'ק',
                style: TextStyle(
                    color: kColorScheme.primary,
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   crossAxisAlignment: CrossAxisAlignment.,
            //   textDirection: TextDirection.rtl,
            //   children: [
            //     StyledText(
            //         outText: 'האפליקציה שתעשה לכם \n סדר יום\n בצ\'יק צ\'ק',
            //         size: 25,
            //         color: kColorScheme.primary),
            //   ],
            // ),
             SizedBox(height: screenHeight*0.05),
            CircularProgressIndicator(
              color: kColorScheme.primary,
            ) // גלגל המתנה בתחתית העמוד
          ],
        )
        // // if landscape
        // : Column(
        //   crossAxisAlignment: CrossAxisAlignment.center,
        //   mainAxisSize: MainAxisSize.min,
        //   children: [
        //     const StyledText(
        //         outText: 'Chick Chack', size: 65, color: Colors.black),
        //     const SizedBox(height: 50),
        //     Container(
        //       width: 320 , //circle
        //       height: 320,
        //       decoration: const BoxDecoration(
        //         shape: BoxShape.circle,
        //         color: (Colors.white),
        //         //borderRadius: BorderRadius.all(Radius.circular(20))
        //       ),
        //       child: Center(
        //         child: Image.asset(
        //           'assets/openScreen.png',
        //           width: 250, //picture
        //           height: 300,
        //           //fit: BoxFit.contain,
        //         ),
        //       ),
        //     ),
        //     const Padding(padding: EdgeInsets.all(28)),
        //     //child: StayledText('welcome to Liav\'s app '),
        //     //const SizedBox(height: 20),
        //     Text('האפליקציה שתעשה לכם \n סדר יום\n בצ\'יק צ\'ק',
        //         style: TextStyle(
        //             color: kColorScheme.primary,
        //             fontSize: 30,
        //             fontWeight: FontWeight.bold),
        //         textAlign: TextAlign.center),
        //     // Row(
        //     //   mainAxisAlignment: MainAxisAlignment.center,
        //     //   crossAxisAlignment: CrossAxisAlignment.,
        //     //   textDirection: TextDirection.rtl,
        //     //   children: [
        //     //     StyledText(
        //     //         outText: 'האפליקציה שתעשה לכם \n סדר יום\n בצ\'יק צ\'ק',
        //     //         size: 25,
        //     //         color: kColorScheme.primary),
        //     //   ],
        //     // ),
        //     const SizedBox(height: 20),
        //     CircularProgressIndicator(
        //       color: kColorScheme.primary,
        //     ) // גלגל המתנה בתחתית העמוד
        //   ],
        // )
      ),
    );
  }
}
