import 'package:chick_chack_beta/main.dart';
import 'package:chick_chack_beta/models/exem.dart';
import 'package:chick_chack_beta/screens/student/exems.dart';
import 'package:chick_chack_beta/screens/student/schedule.dart';
import 'package:flutter/material.dart';

class StudentPage extends StatelessWidget {
  const StudentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kColorScheme.primaryContainer,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (ctx) => const Exems(),
                              ),
                            ); 
                  },
                  icon: const Icon(Icons.school_outlined),
                  label: const Text('לוח מבחנים')), // ---------------נשאיר לסוף ------------
              // IconButton(
              //   onPressed: () {},
              //   icon: const Icon(Icons.school_outlined),
              //   iconSize: 100,
              //   style: ButtonStyle(),
              // ),
              TextButton.icon(
                  onPressed: () { 
                       Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (ctx) => const StudentScheduale(),
                              ),
                            ); 
                  },
                  icon: const Icon(Icons.timelapse_outlined),
                  label: const Text('מערכת שעות לסטודנט')),
            ],
          ),
        ],
      ),
    );
  }
}
