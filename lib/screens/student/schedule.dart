import 'package:chick_chack_beta/main.dart';
import 'package:chick_chack_beta/styles/styled_text.dart';
import 'package:flutter/material.dart';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

class StudentScheduale extends StatefulWidget {
  const StudentScheduale({super.key});

    @override
  State<StudentScheduale> createState() => _StudentSchedualeState();
}

class _StudentSchedualeState extends State<StudentScheduale> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    //List<Map<int,String>> materials = [{1: 'Math', 2: 'Sceince', 3: 'Sport'}, {1: 'Sport', 2: 'Sceince', 3: 'Sport'}, ];

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.cleaning_services_sharp,
                color: Colors.red,
              ))
        ],
        title: const StyledText.white('מערכת שעות', size: 40),
      ),
      body:
      
          // SingleChildScrollView(
            
          //   //scrollDirection: Axis.vertical,
          //   //primary: false,

          //   //clipBehavior: Clip.antiAlias,
          //     child: 
          Table(
        border: TableBorder.all(
            color: kColorScheme.primary, style: BorderStyle.solid),
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        //columnWidths: ,
        defaultColumnWidth: const FlexColumnWidth(1.0) ,
        // const FractionColumnWidth(.25),
        children: 
        const [
          TableRow(children: [
            Text('שישי'),
            Text('חמישי'),
            Text('רביעי'),
            Text('שלישי'),
            Text('שני'),
            Text('ראשון'),
            Text('@')
          ]),
          TableRow(children: [
            //1
            TextField(),
            TextField(),
            TextField(),
            TextField(),
            TextField(),
            TextField(),
            Text('1')
          ]),
          TableRow(children: [
            //2
            TextField(),
            TextField(),
            TextField(),
            TextField(),
            TextField(),
            TextField(),
            Text('2')
          ]),
          TableRow(children: [
            //3
            TextField(),
            TextField(),
            TextField(),
            TextField(),
            TextField(),
            TextField(),
            Text('3')
          ]),
          TableRow(children: [
            //4
           TextField(),
            TextField(),
            TextField(),
            TextField(),
            TextField(),
            TextField(),
            Text('4')
          ]),
          TableRow(children: [
            //5
            TextField(),
            TextField(),
            TextField(),
            TextField(),
            TextField(),
            TextField(),
            Text('5')
          ]),
          TableRow(children: [
            //6
            TextField(),
            TextField(),
            TextField(),
            TextField(),
            TextField(),
            TextField(),
            Text('6')
          ]),
          TableRow(children: [
            //7
            TextField(),
            TextField(),
            TextField(),
            TextField(),
            TextField(),
            TextField(),
            Text('7')
          ]),
          TableRow(children: [
            //8
            TextField(),
            TextField(),
            TextField(),
            TextField(),
            TextField(),
            TextField(),
            Text('8')
          ]),
        ],
      ),

      // ),
    );
  }
}
