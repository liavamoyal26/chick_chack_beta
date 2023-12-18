// ignore_for_file: unused_local_variable
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tzData;

import 'dart:convert';
import 'dart:io'; // Platform class
import 'package:chick_chack_beta/main.dart';
import 'package:chick_chack_beta/models/category.dart';
import 'package:chick_chack_beta/models/mission.dart';
import 'package:chick_chack_beta/screens/application_main.dart';
import 'package:chick_chack_beta/service/noti.dart';
import 'package:chick_chack_beta/styles/styled_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
// import 'package:intl/intl.dart'; // design of IOS APPLE

// ignore: must_be_immutable
class NewMission extends StatefulWidget {
  /*חלונית הוספת משימות*/
  // widget varibale----------------
  final void Function(Mission mission) onAddMission; //מתקבלת מnew_mission
  DateTime gotDate;
  String gotTitle;

  //----constactors------
  NewMission({super.key, required this.onAddMission})
      : gotDate = DateTime(9), // 9 = symbol NOW
        gotTitle = '';

  NewMission.byDate(
      {super.key, required this.onAddMission, required DateTime defaultDate})
      : gotDate = defaultDate,
        gotTitle = '';

  NewMission.byDefualtTitle(
      {super.key, required this.onAddMission, required String title})
      : gotDate = DateTime(9), // 9 = symbol NOW
        gotTitle = title;

  @override
  State<NewMission> createState() => _NewMissionState();
}

class _NewMissionState extends State<NewMission> {
  final _titleController = TextEditingController();
  final _commentController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  CategoryList _selectedCategory = CategoryList.general;

  @override
  void dispose() {
    _titleController.dispose();
    _commentController.dispose();
    widget.gotDate = DateTime(9);
    super.dispose();
  }

  @override
  void initState() {
    Noti.initialize(FLNP);
    tzData.initializeTimeZones();
    if (widget.gotTitle != '') {
      _titleController.text = widget.gotTitle;
    }
    if (widget.gotDate != DateTime(9)) {
      setState(() {
        _selectedDate = widget.gotDate;
      });
      super.initState();
    }
  }

  void _presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 10, now.month, now.day);
    final lastDate = DateTime(now.year + 10, now.month, now.day);
    final pickedDate = await showDatePicker(
        context: context,
        initialDate: now,
        firstDate: firstDate,
        lastDate: lastDate);
    setState(() {
      _selectedDate = pickedDate;
    });
  }

  void _presentTimePicker() async {
    final TimeOfDay now = TimeOfDay.now();
    final pickedTime = await showTimePicker(context: context, initialTime: now);
    setState(() {
      _selectedTime = pickedTime;
    });
  }

  void _showDialog() {
    //מציג הודעת שגיאה מותאמת לפי םלטםורמה (איפון.גלאקסי)
    if (Platform.isIOS) {
      showCupertinoDialog(
        // in case of IOS
        context: context,
        builder: (ctx) => CupertinoAlertDialog(
          title: StyledText(
              outText: 'INVALID INPUT',
              color: kColorScheme.secondary,
              size: 30),
          content: const Text(
            'make sure all parameter are filled!',
            style: TextStyle(fontSize: 15),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: const Text('OK'),
            )
          ],
        ),
      );
    } else {
      showDialog(
        // in case of ANDROID
        context: context,
        builder: (ctx) => AlertDialog(
          title: StyledText(
              outText: 'INVALID INPUT', color: kColorScheme.error, size: 30),
          content: const Text(
            'make sure all parameter are filled!',
            style: TextStyle(fontSize: 15),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: const Text('OK'),
            )
          ],
        ),
      );
    }
  }

  void _submitMissionData() async {
    if (_titleController.text.trim().isEmpty ||
        _selectedTime == null ||
        _selectedDate == null) {
      _showDialog();
      return;
    } //IF ends now ELSE
    //--firebase--
    final url = Uri.https('chick-chack-97c32-default-rtdb.firebaseio.com',
        'mission-list/${userConnected.uid}.json');
    final response = await http.post(url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'title': _titleController.text,
          'time-hour': _selectedTime!.hour,
          'time-minute': _selectedTime!.minute,
          'date-year': _selectedDate!.year,
          'date-month': _selectedDate!.month,
          'date-day': _selectedDate!.day,
          'category': _selectedCategory.name,
          'comment': _commentController.text,
        }));
    widget.onAddMission(Mission(
      title: _titleController.text,
      time: _selectedTime!,
      date: _selectedDate!,
      category: _selectedCategory,
      comment: _commentController.text,
    )); // פונקציה המוסיפה "משימה" לרשימת המשימות הנמצאת missions
    if (!mounted) {
      return;
    }
    Navigator.of(context).pop();
    setNoti();
  }

  void setNoti() async {
    // print("${list[list.length - 1].date.toString().substring(0, 10)} ${list[list.length - 1].time.toString().substring(10, 15)}:00");
    await Noti.showScheduleNotification(
      title: _titleController.text,
      body: _commentController.text,
      fln: FLNP,
      time: tz.TZDateTime.parse(tz.local,
          "${_selectedDate.toString().substring(0, 10)} ${_selectedTime.toString().substring(10, 15)}:00"),
    );
    // print("${_selectedDate.toString().substring(0, 10)} + ${_selectedTime.toString().substring(10, 15)}:00");
    print('noti seted');
  }

  @override
  Widget build(BuildContext context) {
    final bool isGotTitle;
    widget.gotTitle == ''
        ? isGotTitle = false
        : isGotTitle = true; // this check if we use the GOTTITLE Constractor
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;
    return GestureDetector(
      // להתעלם מהמקלדת אם פתוחה בעת לחיצה
      onTap: () {},
      child: LayoutBuilder(
        builder: (ctx, constraints) {
          final width = constraints.maxWidth;
          final height = constraints.maxHeight;

          return SizedBox(
            //height: double.infinity, //מותח את המסך עד הקצה
            child: SingleChildScrollView(
              //נותן את האופציה לגלול במרווח שנותר בין המקלדת למסך
              child: Padding(
                padding: EdgeInsets.fromLTRB(16, 16, 16,
                    keyboardSpace + 16), //המרחק שרואים מהמסך עד למקלדת
                child: Column(
                  children: [
                    if (width > height) //landscape
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  //onChanged: _saveTitleInput,
                                  controller: _titleController,
                                  maxLength: 25,
                                  decoration: const InputDecoration(
                                    label: Text(
                                      'Title',
                                      style: TextStyle(fontSize: 25),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 25),
                        ],
                      ) //ends -if landscape
                    else // NOT landscape
                      TextField(
                        controller: _titleController,
                        maxLength: 25,
                        maxLines: 2,
                        decoration: const InputDecoration(
                          label: Text(
                            'Title',
                            style: TextStyle(fontSize: 25),
                          ),
                        ),
                      ),
                    if (width > height) //landscape
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: _presentTimePicker,
                            icon: const Icon(
                              Icons.more_time,
                              size: 25,
                            ),
                          ),
                          Text(
                            _selectedTime == null
                                ? 'no time selected'
                                : _selectedTime!.minute <
                                        10 // אם יש אפס בדקות בצד שמאל
                                    ? '${_selectedTime!.hour} : 0${_selectedTime!.minute}'
                                    : '${_selectedTime!.hour} : ${_selectedTime!.minute}',
                            style: _selectedTime == null
                                ? TextStyle(
                                    fontSize: 20, color: kColorScheme.error)
                                : TextStyle(
                                    fontSize: 35, color: kColorScheme.primary),
                          ), // !- cannot be null
                          const SizedBox(width: 24),
                          Row(
                            children: [
                              IconButton(
                                onPressed: _presentDatePicker,
                                icon: const Icon(
                                  Icons.calendar_month,
                                ),
                              ),
                              Text(
                                _selectedDate == null
                                    ? 'no data selected'
                                    : formatDate.format(_selectedDate!),
                                style: _selectedDate == null
                                    ? TextStyle(
                                        fontSize: 20, color: kColorScheme.error)
                                    : TextStyle(
                                        fontSize: 20,
                                        color: kColorScheme.primary),
                              ), // !- cannot be null
                            ],
                          ),
                          //     ],
                          //   ),
                          // ),
                        ],
                      )
                    else // NOT landscaspe
                      Column(
                        children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                IconButton(
                                  onPressed: _presentTimePicker,
                                  icon: const Icon(
                                    Icons.more_time,
                                    size: 25,
                                  ),
                                ),
                                Text(
                                  _selectedTime == null
                                      ? 'no time selected'
                                      : _selectedTime!.minute <
                                              10 // אם יש אפס בדקות בצד שמאל
                                          ? '${_selectedTime!.hour} : 0${_selectedTime!.minute}'
                                          : '${_selectedTime!.hour} : ${_selectedTime!.minute}',
                                  style: _selectedTime == null
                                      ? TextStyle(
                                          fontSize: 20,
                                          color: kColorScheme.error)
                                      : TextStyle(
                                          fontSize: 35,
                                          color: kColorScheme.primary),
                                ),
                              ]), // !- cannot be null
                          const SizedBox(width: 24),
                        ],
                      ),
                    if (width > height) //landscape
                      Row(
                        children: [
                          DropdownButton(
                            value: _selectedCategory,
                            items: CategoryList.values
                                .map(
                                  (category) => DropdownMenuItem(
                                    value: category,
                                    child: Text(
                                      category.name.toUpperCase(),
                                    ),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) {
                              if (value == null) return;
                              setState(
                                () {
                                  _selectedCategory = value;
                                },
                              );
                            },
                          ),
                        ],
                      )
                    else // NOT landscape
                      Column(
                        children: [
                          Row(
                            children: [
                              IconButton(
                                onPressed: _presentDatePicker,
                                icon: const Icon(
                                  Icons.calendar_month,
                                ),
                              ),
                              Text(
                                _selectedDate == null
                                    ? 'no data selected'
                                    : formatDate.format(_selectedDate!),
                                style: _selectedDate == null
                                    ? TextStyle(
                                        fontSize: 20, color: kColorScheme.error)
                                    : TextStyle(
                                        fontSize: 20,
                                        color: kColorScheme.primary),
                              ), // !- cannot be null
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(children: [
                            DropdownButton(
                              value: _selectedCategory,
                              items: CategoryList.values
                                  .map(
                                    (category) => DropdownMenuItem(
                                      value: category,
                                      child: StyledText(
                                        outText: category.name.toUpperCase(),
                                        color: kColorScheme.secondary,
                                        size: 25,
                                      ),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (value) {
                                if (value == null) return;
                                setState(
                                  () {
                                    _selectedCategory = value;
                                  },
                                );
                              },
                            ),
                          ]),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _commentController,
                                  maxLength: 200,
                                  keyboardType: TextInputType.multiline,
                                  minLines: 1,
                                  maxLines: 7,
                                  decoration: const InputDecoration(
                                    //prefixText: '\$',
                                    label: Text(
                                      'comments',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    const SizedBox(width: 16),
                    if (width > height) //landscape
                      Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _commentController,
                                  maxLength: 400,
                                  keyboardType: TextInputType.multiline,
                                  minLines: 1,
                                  maxLines: 4,
                                  decoration: const InputDecoration(
                                    label: Text('Comment'),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Spacer(),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('Cancel'),
                              ),
                              ElevatedButton(
                                onPressed: _submitMissionData,
                                child: const Text('Save Mission'),
                              ),
                            ],
                          ),
                        ],
                      )
                    else // NOT landscape
                      Row(
                        children: [
                          const SizedBox(width: 24),
                          Expanded(
                            child: Row(
                              children: [
                                const Spacer(),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Cancel'),
                                ),
                                ElevatedButton(
                                  onPressed: _submitMissionData,
                                  child: const Text('Save Mission'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
