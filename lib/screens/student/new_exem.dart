import 'package:chick_chack_beta/main.dart';
import 'package:chick_chack_beta/models/exem.dart';
import 'package:chick_chack_beta/screens/application_main.dart';
import 'package:chick_chack_beta/styles/styled_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NewExem extends StatefulWidget {
  const NewExem({super.key, required this.onAddExem});

  final void Function(Exem exem) onAddExem;

  @override
  State<NewExem> createState() => _NewExemState();
}

class _NewExemState extends State<NewExem> {
  final _formKey = GlobalKey<FormState>();
  var _titleController = '';
  DateTime _selectedDate = DateTime.now();
  var _commentController = '';

  // @override
  // void dispose() {
  //   _titleController.dispose();
  //   _selectedDate; // ------------check
  //   super.dispose();
  // }

  void _presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 5, now.month, now.day);
    final lastDate = DateTime(now.year + 5, now.month, now.day);
    final pickedDate = await showDatePicker(
        //showDatePicker(
        context: context,
        initialDate: now,
        firstDate: firstDate,
        lastDate: lastDate);
    setState(() {
      _selectedDate = pickedDate!;
    });
  }

  void _showDialog() {
    showDialog(
      // in case of ANDROID
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Invalid input'),
        content: const Text('make sure all parameter valids'),
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

  void _submitExemData() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      _showDialog();
      return;
    }
    if (isValid) {
      _formKey.currentState!.save();
      print('---details saved---');

      FocusScope.of(context).unfocus();
      //IF ends now ELSE
      widget.onAddExem(Exem(
          title: _titleController,
          date: _selectedDate,
          comment: _commentController));
      // final userData = await FirebaseFirestore.instance
      //     .collection('users')
      //     .doc(_userConnected.uid)
      //     .get(); // to get User Details
      //create collection   // doc with userID unique user // create db with userID name
      await FirebaseFirestore.instance
          .collection('exems')
          .doc(userConnected.uid)
          .collection(userConnected.uid)
          .add({
        // add EXPENSE
        'title': _titleController,
        'date': _selectedDate.toString().substring(0, 10),
        'comment': _commentController,
      });
      if (!mounted) {
        return;
      }
      Navigator.of(context).pop(); //סוגר את החלונית לאחר ביצוע כל הפעולות
    }
  }

  @override
  Widget build(BuildContext context) {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;
    return GestureDetector(
      // להתעלם מהמקלדת אם פתוחה בעת לחיצה
      onTap: () {},
      child: LayoutBuilder(builder: (ctx, constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;

        return SizedBox(
          //height: double.infinity, //מותח את המסך עד הקצה
          child: SingleChildScrollView(
            //נותן את האופציה לגלול במרווח שנותר בין המקלדת למסך
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16,
                  keyboardSpace + 16), //המרחק שרואים מהמסך עד למקלדת
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      maxLength: 50,
                      decoration: const InputDecoration(
                        label: Text('Title'),
                      ),
                      validator: (value) {
                        if (value == '' ||
                            value == null ||
                            value.trim().isEmpty ||
                            value.trim().length > 50) {
                          return 'Must be between 1 and 50 characters.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _titleController = value!;
                      },
                    ), // instead of TextField()
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: TextFormField(
                            decoration: const InputDecoration(
                              label: Text('comment'),
                            ),
                            onSaved: (value) {
                              _commentController = value!;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 26),
                    Row(
                      children: [
                        IconButton(
                          onPressed: _presentDatePicker,
                          icon: const Icon(
                            Icons.calendar_month,
                          ),
                        ),
                        Text(
                          formatDate.format(_selectedDate),
                          style: TextStyle(
                              fontSize: 20, color: kColorScheme.primary),
                        ), // !- cannot be null
                      ],
                    ),
                    //const SizedBox(height: 10),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () {
                            _formKey.currentState!.reset();
                          },
                          child: const Text('Reset'),
                        ),
                        ElevatedButton(
                          // ---------מפעיל submit
                          onPressed: _submitExemData,
                          child: const StyledText.white(
                            'Save Exem',
                            size: 20,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
