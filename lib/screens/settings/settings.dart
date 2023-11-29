import 'package:chick_chack_beta/main.dart';
import 'package:chick_chack_beta/styles/styled_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:chick_chack_beta/screens/application_main.dart';

class SettingCC extends StatefulWidget {
  SettingCC({super.key, required this.isStudentSettings});
  bool isStudentSettings;

  @override
  State<SettingCC> createState() => _SettingCCState();
}

class _SettingCCState extends State<SettingCC> {
  void _changeStateStudent(bool flag) async {
    setState(() {
      widget.isStudentSettings = flag;
    });
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userConnected.uid)
        .update({'is_student': widget.isStudentSettings});
    if (!mounted) {
      return;
    } // מקביל לRETURN
    print(widget.isStudentSettings.toString());
    Navigator.of(context).pop(widget.isStudentSettings);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title:
            const StyledText(outText: 'Settings', size: 25, color: Colors.grey),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              Switch(
                value: widget.isStudentSettings,
                onChanged: _changeStateStudent,
                activeColor: kColorScheme.primary,
              ), // ON/OFF button
              SizedBox(width: screenWidth * 0.4),
              const Text(
                '? האם סטודנט',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    fontSize: 20),
              )
            ]),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
                showModalBottomSheet(
                    backgroundColor: kColorScheme.background,
                    constraints: const BoxConstraints(
                        minHeight: double.infinity, minWidth: double.infinity),
                    context: context,
                    builder: (context) => Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('creator Liav: liav12354@gmail.com',
                                style: TextStyle(
                                    fontSize: 30,
                                    color: Colors.amber.shade900,
                                    fontWeight: FontWeight.bold)),
                            Text('creator Dor: doredlstein2@gmail.com',
                                style: TextStyle(
                                    fontSize: 30,
                                    color: Colors.green.shade900,
                                    fontWeight: FontWeight.bold)),
                            const SizedBox(height: 30),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset('assets/openScreen.png',
                                    height: screenHeight / 5,
                                    width: screenWidth / 3,
                                    fit: BoxFit.fill),
                              ],
                            ),
                          ],
                        ));
              },
              child: const StyledText(
                  outText: 'contact us', size: 27, color: Colors.black),
            ),
            TextButton(
                onPressed: () {
                  showModalBottomSheet(
                    backgroundColor: kColorScheme.secondaryContainer,
                    constraints: const BoxConstraints(
                        minHeight: double.infinity, minWidth: double.infinity),
                    context: context,
                    builder: (context) => Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          StyledText(
                              outText: 'credits',
                              size: 75,
                              color: Colors.deepOrange.shade200),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text('creators : ',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20)),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              StyledText(
                                  outText: 'Liav Amoyal',
                                  size: 35,
                                  color: Colors.amber.shade900)
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              StyledText(
                                  outText: 'Dor Edelstein',
                                  size: 35,
                                  color: Colors.green.shade900)
                            ],
                          ),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Lecturer : ',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              StyledText(
                                  outText: 'Dario Bugio',
                                  size: 25,
                                  color: Colors.blue.shade400)
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset('assets/openScreen.png',
                                  height: screenHeight / 5,
                                  width: screenWidth / 3,
                                  fit: BoxFit.fill),
                            ],
                          ),
                        ]),
                  );
                },
                child: const StyledText(
                    outText: 'credits', size: 27, color: Colors.black))
          ],
        ),
      ),
    );
  }
}
