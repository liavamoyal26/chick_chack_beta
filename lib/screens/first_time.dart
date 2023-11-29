// ignore_for_file: unused_local_variable

import 'package:chick_chack_beta/main.dart';
import 'package:chick_chack_beta/screens/is_student.dart';
import 'package:chick_chack_beta/screens/login.dart';
import 'package:chick_chack_beta/screens/waiting_screen.dart';
import 'package:flutter/material.dart';
import 'package:chick_chack_beta/styles/styled_text.dart';


class IsFirstTime extends StatelessWidget {
  const IsFirstTime({super.key});

  @override
  Widget build(BuildContext context) {
    bool isFirstTimeFlag = true;
    return FutureBuilder(
        future: Future.delayed(const Duration(seconds: 3)),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const WaitingScreen();
            ///Splash Screen
          }
          else {
            return Scaffold(
              body: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 75),
                    StyledText(
                        outText: '''CHICK \n              CHACK''',
                        size: 60,
                        color: kColorScheme.primary),
                    const SizedBox(height: 65),
                    const Text(
                      'האם אתה משתמש בפעם הראשונה באפליקציה?',
                      style: TextStyle(fontSize: 30),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 6),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (ctx) => const IsStudent(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(300, 15),
                        ),
                        child: const StyledText.white('כן', size: 28),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 6),
                      child: ElevatedButton(
                        onPressed: () {
                          isFirstTimeFlag = false;
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (ctx) => const LogInScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(300, 25),
                        ),
                        child: const StyledText.white(
                            'לא, יש לי חשבון באפליקציה',
                            size: 25),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        }
        );
  }
}
