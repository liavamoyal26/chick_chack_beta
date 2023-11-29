import 'package:chick_chack_beta/screens/application_main.dart';
import 'package:chick_chack_beta/screens/expenses/new_expense.dart';
import 'package:chick_chack_beta/styles/styled_text.dart';
import 'package:chick_chack_beta/widgets/expenses_list.dart';
import 'package:chick_chack_beta/models/expense.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:chick_chack_beta/widgets/chart/chart.dart';

class Expenses extends StatefulWidget {
  // עמוד הוצאות הכולל רשימת הוצאות והוספת הוצאה
  const Expenses({super.key});

  @override
  State<Expenses> createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
  List<Expense> registedExpenses = [];
  // Expense(
  //   title: 'Flutter Course',
  //   amount: 499.00,
  //   date: DateTime.now(),
  //   category: Category.work,
  // ),
  // Expense(
  //   title: 'Cinema',
  //   amount: 43.00,
  //   date: DateTime.now(),
  //   category: Category.leisure,
  // ),
  // Expense(
  //   title: 'Hamburger',
  //   amount: 87.90,
  //   date: DateTime.now(),
  //   category: Category.food,
  // ),
  @override
  void initState() {
    _loadListOfExpenses();
    super.initState();
  }

  void _loadListOfExpenses() async {
    List<Expense> tempList = [];
    final userDataOfExpenses = await FirebaseFirestore.instance
        .collection('expenses')
        .doc(userConnected.uid)
        .collection(userConnected.uid)
        .get();
    var ExpenseGotFromFB = userDataOfExpenses.docs.asMap();
    for (final item in ExpenseGotFromFB.entries) {
      // if (ExpenseGotFromFB.isEmpty) {
      //   //----------check this?
      //   return;
      // }
      try {
        tempList.add(
          Expense(
              amount: double.parse(item.value['amount']),
              category: Category.values.byName(item.value['category']),
              date: DateTime(
                int.parse(item.value['date'].substring(0, 4)), //year
                int.parse(item.value['date'].substring(5, 7)), //month
                int.parse(item.value['date'].substring(8, 10)), //day
              ),
              title: item.value['title']),
        );
        print('add sucssesful!' + registedExpenses.length.toString());
      } catch (error) {
        print('--ERROR-- ' + error.toString());
      }
    }
    setState(() {
      registedExpenses = tempList;
    });
  }

  void _openAddExpenseOverlay() {
    showModalBottomSheet(
        //פותח את חלונית הוספת המשימה
        //useSafeArea: true,F
        isScrollControlled: true, //גורם לחלונית להיות על מסך מלא
        context: context,
        builder: (ctx) => NewExpense(onAddExpense: addExpenseLocaly));
  }

  // void _addExpense(Expense expense) {
  //   setState(() {
  //     //מקבלת "הוצאה" ומוסיפה אותו לרשימת ההוצאות
  //     registedExpenses.add(expense);
  //   });
  // }

  void _removeExpense(Expense expense) async {
    //localy delete from list + delete spcefic expense doc from firebase firstore
    final expenseIndex =
        registedExpenses.indexOf(expense); //localy potion in list
    setState(() {
      //מקבלת "הוצאה" ומוסיפה אותו לרשימת ההוצאות
      registedExpenses.remove(expense);
    });
    //--FB FS delete------
    // final _firebaseExpenses = FirebaseFirestore.instance
    //     .collection('expenses')
    //     .doc(userConnected.uid)
    //     .collection(userConnected.uid)
    //     .doc(expense.id);
    final userDataOfExpenses = await FirebaseFirestore.instance
        .collection('expenses')
        .doc(userConnected.uid)
        .collection(userConnected.uid)
        .get();
    var _ExpenseGotFromFB = userDataOfExpenses.docs.asMap();

    for (final ex in _ExpenseGotFromFB.entries) {
      //going throght the list
      if (ex.value['title'].toString() == expense.title.toString() &&
          double.parse(ex.value['amount']) == expense.amount &&
          expense.date.toString().substring(0, 10) ==
              ex.value['date'].toString()) {
        print(ex.value
            .id); //unique id of expense created by firbase!!!! important!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        await FirebaseFirestore.instance
            .collection('expenses')
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
            outText: 'Expense deleted!',
            size: 25,
            color: Color.fromARGB(255, 237, 32, 17)),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              registedExpenses.insert(expenseIndex, expense);
            });
            FirebaseFirestore.instance
                .collection('expenses')
                .doc(userConnected.uid)
                .collection(userConnected.uid)
                .add({
              // add EXPENSE
              'title': expense.title,
              'amount': expense.amount,
              'date': expense.date.toString().substring(0, 10),
              'category': expense.category.toString().substring(9),
            });
          },
        ),
      ),
    );
  }

  void addExpenseLocaly(Expense expense) {
    //הוספה מקומית לרשימת ההוצאות
    setState(() {
      registedExpenses.add(expense);
    });
  }

  @override
  Widget build(BuildContext context) {
    // בדיקה של רוחב וגובה המכשיר (בשכיבה/עמידה)
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final ref = FirebaseFirestore.instance
        .collection('expenses')
        .doc(userConnected.uid)
        .collection(userConnected.uid);

    return StreamBuilder(
        stream: ref.snapshots(),
        builder: (context, expensesSnapshot) {
          if (expensesSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (!expensesSnapshot.hasData ||
              expensesSnapshot.data!.docs.isEmpty) {
            return Scaffold(
              appBar: AppBar(
                title: const StyledText(
                    outText: 'ExpenseTracker Chick-Chack',
                    size: 25,
                    color: Colors.grey),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: _openAddExpenseOverlay,
                    iconSize: 35,
                    color: Colors.grey,
                  ),
                ],
              ),
              body: const Center(child: Text('no Expnses exist yet.')),
            );
          } // call to the Registed data from the fireStore
          else {
            //streambuilder
            //else if there's data..
            return Scaffold(
              appBar: AppBar(
                title: const StyledText(
                    outText: 'ExpenseTracker Chick-Chack',
                    size: 25,
                    color: Colors.grey),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: _openAddExpenseOverlay,
                    iconSize: 35,
                    color: Colors.grey,
                  ),
                ],
              ),
              body: width < height
                  ? Column(
                      children: [
                        const StyledText.title(
                          'the chart',
                        ),
                        Chart(expenses: registedExpenses),
                        Expanded(
                          //סידור מסויים
                          child: ExpensesList(
                            expenses: registedExpenses,
                            onRemoveExpense: _removeExpense, // when disembale
                          ),
                        ),
                      ],
                    )
                  : Row(
                      //landscape---------------------------
                      children: [
                        Expanded(
                          child: Chart(expenses: registedExpenses),
                        ),
                        Expanded(
                          //סידור מסויים
                          child: ExpensesList(
                            expenses: registedExpenses,
                            onRemoveExpense: _removeExpense,
                          ),
                        ),
                      ],
                    ),
            );
          }
        });
  }
}
