import 'package:chick_chack_beta/main.dart';
//import 'package:chick_chack_beta/screens/login.dart';
import 'package:chick_chack_beta/screens/signin.dart';
import 'package:chick_chack_beta/screens/waiting_screen.dart';
import 'package:flutter/material.dart';
import 'package:chick_chack_beta/styles/styled_text.dart';

class IsStudent extends StatelessWidget {
  const IsStudent({super.key});

  @override
  Widget build(BuildContext context) {

    return FutureBuilder(
        future: Future.delayed(const Duration(seconds: 3)),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const WaitingScreen();
             //Splash Screen
          }
          else {
            bool _isStudent = false;
            return Scaffold(
              //backgroundColor: Theme.of(context).backgroundColor,    ??
              //decoration: const BoxDecoration(color: Colors.cyan),
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
                    // Container(
                    //   height: 300,
                    //   width: 250,
                    //   child: const Image(image: AssetImage('assets/openScreen.png')),
                    // ),
                    const SizedBox(height: 65),
                    const Text(
                      '?? האם אתה תלמיד/סטודנט',
                      style: TextStyle(fontSize: 30),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 6),
                      child: ElevatedButton(
                        onPressed: () {
                          _isStudent = true;
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (ctx) =>
                                  SignInScreen(isStudent: _isStudent),
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
                          _isStudent = false;
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (ctx) =>
                                  SignInScreen(isStudent: _isStudent),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(300, 25),
                        ),
                        child: const StyledText.white('לא', size: 25),
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
