import 'package:chick_chack_beta/models/exem.dart';
import 'package:chick_chack_beta/screens/application_main.dart';
import 'package:chick_chack_beta/screens/student/new_exem.dart';
import 'package:chick_chack_beta/styles/styled_text.dart';
import 'package:chick_chack_beta/widgets/exem_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Exems extends StatefulWidget {
  const Exems({super.key});

  @override
  State<Exems> createState() => _ExemsState();
}

class _ExemsState extends State<Exems> {
  List<Exem> registedExems = [];

  @override
  void initState() {
    _loadListOfExems();
    super.initState();
  }

  void _loadListOfExems() async {
    //int x = 0; index
    List<Exem> tempList = [];
    final userDataOfExems = await FirebaseFirestore.instance
        .collection('exems')
        .doc(userConnected.uid)
        .collection(userConnected.uid)
        .get();
    var ExemGotFromFB = userDataOfExems.docs.asMap();
    for (final item in ExemGotFromFB.entries) {
      try {
        tempList.add(
          Exem(
            title: item.value['title'],
              date: DateTime(
                int.parse(item.value['date'].substring(0, 4)), //year
                int.parse(item.value['date'].substring(5, 7)), //month
                int.parse(item.value['date'].substring(8, 10)),
               ), //day
              comment: item.value['comment']),
        );
        print('add sucssesful!' + registedExems.length.toString());
        //x++;
      } catch (error) {
        print('--ERROR-- ' + error.toString());
      }
    }
    setState(() {
      // print('tempList = ${tempList.length}');
      registedExems = tempList;
    });
  }

  void openAddExemOverlay() {
    showModalBottomSheet(
        //פותח את חלונית הוספת המשימה
        //useSafeArea: true,F
        isScrollControlled: true, //גורם לחלונית להיות על מסך מלא
        context: context,
        builder: (ctx) => NewExem(onAddExem: addExemLocaly));
  }

  void addExemLocaly(Exem exem) {
    //הוספה מקומית לרשימת ההוצאות
    setState(() {
      registedExems.add(exem);
    });
  }

  void _removeExem(Exem exem) async {
    //localy delete from list + delete spcefic exem doc from firebase firstore
    final exemIndex = registedExems.indexOf(exem); //localy potion in list
    setState(() {
      //מקבלת "הוצאה" ומוסיפה אותו לרשימת ההוצאות
      registedExems.remove(exem);
    });
    final userDataOfExems = await FirebaseFirestore.instance
        .collection('exems')
        .doc(userConnected.uid)
        .collection(userConnected.uid)
        .get();
    var _ExemsGotFromFB = userDataOfExems.docs.asMap();
    for (final ex in _ExemsGotFromFB.entries) {
      if (ex.value['title'].toString() == exem.title.toString() &&
          exem.date.toString().substring(0, 10) ==
              ex.value['date'].toString()) {
        print(ex.value
            .id); //unique id of exem created by firbase!!!! important!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        await FirebaseFirestore.instance
            .collection('exems')
            .doc(userConnected.uid)
            .collection(userConnected.uid)
            .doc(ex.value.id)
            .delete();
      }
    }
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          duration: const Duration(seconds: 2),
          content: const StyledText(
              outText: 'Exem deleted!',
              size: 25,
              color: Color.fromARGB(255, 237, 32, 17)),
          action: SnackBarAction(
              label: 'Undo',
              onPressed: () {
                setState(() {
                  registedExems.insert(exemIndex, exem);
                });
                FirebaseFirestore.instance
                    .collection('exems')
                    .doc(userConnected.uid)
                    .collection(userConnected.uid)
                    .add({
                  // add EXEM
                  'title': exem.title,
                  'date': exem.date.toString().substring(0, 10),
                  'comment': exem.comment,
                });
              })),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    final ref = FirebaseFirestore.instance
        .collection('exems')
        .doc(userConnected.uid)
        .collection(userConnected.uid);

    return StreamBuilder(
        stream: ref.snapshots(),
        builder: (context, exemsSnapshot) {
          if (exemsSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (!exemsSnapshot.hasData || exemsSnapshot.data!.docs.isEmpty) {
            return Scaffold(
              appBar: AppBar(
                title: const StyledText(
                    outText: 'Exems Schedule', size: 25, color: Colors.grey),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: openAddExemOverlay,
                    iconSize: 35,
                    color: Colors.grey,
                  ),
                ],
              ),
              body: const Center(child: Text('no Exems exist yet.')),
            );
          } // call to the Registed data from the fireStore
          else {
            return Scaffold(
              appBar: AppBar(
                title: const StyledText(
                    outText: 'Exems Schedule', size: 25, color: Colors.grey),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: openAddExemOverlay,
                    iconSize: 35,
                    color: Colors.grey,
                  ),
                ],
              ),
              body: width < height
                  ? Column(
                      children: [
                        Expanded(
                          //סידור מסויים
                          child: ExemsList(
                            exems: registedExems,
                            onRemoveExem: _removeExem, // when disembale
                          ),
                        ),
                      ],
                    )
                  : Row(
                      //landscape---------------------------
                      children: [
                        Expanded(
                          //סידור מסויים
                          child:
                              ExemsList(
                            exems: registedExems,
                            onRemoveExem: _removeExem,
                          ),
                        ),
                      ],
                    ),
            );
          }
        });
  }
}
