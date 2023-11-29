import 'dart:io'; // Platform class
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart'; // design of IOS APPLE

import 'package:chick_chack_beta/models/expense.dart';

final _userConnected = FirebaseAuth.instance.currentUser!;

class NewExpense extends StatefulWidget {
  // "חלונית "הוספת הוצאה
  const NewExpense(
      {super.key, required this.onAddExpense}); //required this.onAddExpense});
  final void Function(Expense expense) onAddExpense; //מתקבלת מnew_expense

  @override
  State<NewExpense> createState() => _NewExpenseState();
}

class _NewExpenseState extends State<NewExpense> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;
  Category _selectedCategory = Category.leisure;

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 5, now.month, now.day);
    final lastDate = DateTime(now.year + 5, now.month, now.day);
    final pickedDate = await showDatePicker(
        context: context,
        initialDate: now,
        firstDate: firstDate,
        lastDate: lastDate);
    setState(() {
      _selectedDate = pickedDate;
    });
  }

  void _showDialog() {
    //מציג הודעת שגיאה מותאמת לפי םלטםורמה (איפון.גלאקסי)
    if (Platform.isIOS) {
      showCupertinoDialog(
        // in case of IOS
        context: context,
        builder: (ctx) => CupertinoAlertDialog(
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
    } else {
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
  }

  void _submitExpensData() async {
    final enteredAmount =
        double.tryParse(_amountController.text); //tryParse('hello') => null
    final amountIsInvalid = enteredAmount == null || enteredAmount <= 0;
    if (_titleController.text.trim().isEmpty ||
        amountIsInvalid ||
        _selectedDate == null) {
      _showDialog();
      return;
    } //IF ends now ELSE
    else {
      widget.onAddExpense(
        Expense(
            title: _titleController.text,
            amount: enteredAmount,
            date: _selectedDate!,
            category: _selectedCategory),
      ); // פונקציה המוסיפה "הוצאה" לרשימת ההוצאות הנמצאת בexspense
      //create collection   // doc with userID unique user // create db with userID name
      await FirebaseFirestore.instance
          .collection('expenses')
          .doc(_userConnected.uid)
          .collection(_userConnected.uid)
          .add({
        // add EXPENSE
        'title': _titleController.text,
        'amount': _amountController.text,
        'date': _selectedDate.toString().substring(0, 10),
        'category': _selectedCategory.toString().substring(9),
      });
      // widget.onAddExpense(Expense( // ----------ההוספה כבר מתבצעת בEXPENSES PAGE
      //     title: _titleController.text,
      //     amount: enteredAmount,
      //     date: _selectedDate!,
      //     category:
      //         _selectedCategory)); // פונקציה המוסיפה "הוצאה" לרשימת ההוצאות הנמצאת בexspense
      //Navigator.pop(context);
      if (!mounted) {
        return;
      }
      Navigator.of(context).pop(); //סוגר את החלונית לאחר ביצוע כל הפעולות
    }
  }

  @override
  Widget build(BuildContext context) {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;

    return LayoutBuilder(
      builder: (ctx, constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;
        return SizedBox(
          height: double.infinity, //מותח את המסך עד הקצה
          child: SingleChildScrollView(
            //נותן את האופציה לגלול במרווח שנותר בין המקלדת למסך
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16,
                  keyboardSpace + 16), //המרחק שרואים מהמסך עד למקלדת
              child: Column(
                children: [
                  if (width > height) // if landscape
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _titleController,
                            maxLength: 50,
                            decoration: const InputDecoration(
                              label: Text('Title'),
                            ),
                          ),
                        ),
                        const SizedBox(width: 25),
                        Expanded(
                          child: TextField(
                            controller: _amountController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              prefixText: '\$',
                              label: Text('Amount'),
                            ),
                          ),
                        )
                      ],
                    )
                  else
                    TextField(
                      controller: _titleController,
                      maxLength: 50,
                      decoration: const InputDecoration(
                        label: Text('Title'),
                      ),
                    ),
                  if (width > height) // if landscape
                    Row(
                      children: [
                        DropdownButton(
                          value: _selectedCategory,
                          items: Category.values
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
                        const SizedBox(width: 24),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(_selectedDate == null
                                  ? 'no data selected'
                                  : formatter.format(
                                      _selectedDate!)), // !- cannot be null
                              IconButton(
                                onPressed: _presentDatePicker,
                                icon: const Icon(
                                  Icons.calendar_month,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  else
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _amountController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              prefixText: '\$',
                              label: Text('Amount'),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(_selectedDate == null
                                  ? 'no data selected'
                                  : formatter.format(
                                      _selectedDate!)), // !- cannot be null
                              IconButton(
                                onPressed: _presentDatePicker,
                                icon: const Icon(
                                  Icons.calendar_month,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(width: 16),
                  if (width > height) // if landscape
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
                          onPressed: _submitExpensData,
                          child: const Text('Save Expense'),
                        ),
                      ],
                    )
                  else
                    Row(
                      children: [
                        DropdownButton(
                          value: _selectedCategory,
                          items: Category.values
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
                                onPressed: _submitExpensData,
                                child: const Text('Save Expense'),
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
    );
  }
}
