import 'package:chick_chack_beta/screens/application_main.dart';
import 'package:chick_chack_beta/screens/login.dart';
import 'package:chick_chack_beta/styles/styled_text.dart';
import 'package:flutter/material.dart';
//-----firebase------
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _firebase = FirebaseAuth.instance; // מחזיק פרטי משתמש

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key, required this.isStudent});

  final bool isStudent;
  
  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  var _enteredName = '';
  var _enterdEmail = '';
  var _enterdPassword = '';

  void _submit() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    if (isValid) {
      _formKey.currentState!.save();
      print('---details saved---');
    }
    FocusScope.of(context).unfocus(); //close keyboard
    try {
      final userCredentails = await _firebase.createUserWithEmailAndPassword(
          email: _enterdEmail, password: _enterdPassword);

      print(userCredentails);

      await FirebaseFirestore
          .instance // שמירת נתוני המשתמש בענן כדי ששנוכל להשתמש בנתוניו
          .collection('users')
          .doc(userCredentails.user!.uid)
          .set({
        'user_name': _enteredName,
        'email': _enterdEmail,
        'password': _enterdPassword,
        'is_student': true,
      });

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (ctx) => const MainApp(),
        ),
      );
    } on FirebaseAuthException catch (error) {
      if (error.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'registed email! Try To switch Log In mode',
              style: TextStyle(color: Colors.red, fontSize: 15),
            ),
          ),
        );
        return;
      }
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.message ?? 'Signup failed'),
        ),
      );
      //-------------מיותר נכון לעכשיו----------------
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const StyledText(
            outText: 'SIGN-IN PAGE',
            size: 40,
            color: Color.fromARGB(255, 19, 237, 132)),
      ),
      body: SingleChildScrollView(
        clipBehavior: Clip.hardEdge,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  maxLength: 50,
                  decoration: const InputDecoration(
                    label: Text('NAME'),
                  ),
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        value.trim().length <= 1 ||
                        value.trim().length > 50) {
                      return 'Must be between 1 and 50 characters.';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _enteredName = value!;
                  },
                ), // instead of TextField()
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: TextFormField(
                        decoration: const InputDecoration(
                          label: Text('E-MAIL'),
                        ),
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              value.trim().length <= 7 ||
                              value.trim().length > 50 ||
                              value.contains('@') == false) {
                            return 'Must be a valid FORM => ex. xxx@gmail.com';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _enterdEmail = value!;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 26),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: TextFormField(
                        maxLength: 50,
                        decoration: const InputDecoration(
                          label: Text('PASSWORD'),
                        ),
                        validator: (value) {
                          _enterdPassword = value!;
                          if (_enterdPassword.isEmpty ||
                              _enterdPassword.trim().length <= 5 ||
                              _enterdPassword.trim().length > 50 ||
                              !_enterdPassword.contains(RegExp('[A-Z]'))) {
                            return 'Must be at last 6 character UPPER+LOWER case + numbers ';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _enterdPassword = value!;
                        },
                      ),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: TextFormField(
                        maxLength: 50,
                        decoration: const InputDecoration(
                          label: Text('REAPET PASSWORD'),
                        ),
                        validator: (value) {
                          if (value != _enterdPassword) {
                            return 'the reapeted password not matched to the password you seted';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
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
                      onPressed: _submit,
                      child: const StyledText.white(
                        'SIGN NOW!',
                        size: 24,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const LogInScreen()));
                      },
                      child: const Text(
                        'Switch to Log in',
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
