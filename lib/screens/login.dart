import 'package:chick_chack_beta/main.dart';
import 'package:chick_chack_beta/screens/application_main.dart';
import 'package:chick_chack_beta/screens/is_student.dart';
import 'package:chick_chack_beta/styles/styled_text.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

final _firebase = FirebaseAuth.instance;

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final _formKey = GlobalKey<FormState>();
  var _enterdEmail = '';
  var _enterdPassword = '';

  bool _isObscure = true;

  void _submit() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return; // תרשום מתחת לקלט מדוע הקלט לא עבר את האימות (ולא התחברות!!!)
    }
    if (isValid) {
      _formKey.currentState!.save();
    }
    try {
      // try to sign in
      // ignore: unused_local_variable
      final userCredentails = await _firebase.signInWithEmailAndPassword(
          email: _enterdEmail, password: _enterdPassword);
      //-----------------------whensuccesfullsignin
      setState(() {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: const Duration(seconds: 3),
            content: StyledText(
              outText: 'Login succesfull $_enterdEmail',
              size: 22,
              color: kColorScheme.primaryContainer,
            ),
          ),
        );
      });
      if (!mounted) {
        return;
      }
      FocusScope.of(context).unfocus(); //close keyboard
      Navigator.of(context).push(       // to appliction main screen. loged user.
        MaterialPageRoute(
          builder: (ctx) => const MainApp(),
        ),
      );
    } on FirebaseAuthException catch (error) {
      if (error.code == 'wrong-password') {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'WORNG PASSWORD',
              style: TextStyle(color: Colors.red, fontSize: 15),
            ),
          ),
        );
        return;
      }
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.message ?? 'Authentication failed'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    //final isKeyboard = MediaQuery.of(context).viewInsets.bottom != 0;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: StyledText(
          outText: 'LOGIN PAGE',
          size: 40,
          color: Theme.of(context).colorScheme.primaryContainer,
        ),
      ),
      body: SingleChildScrollView(
        clipBehavior: Clip.hardEdge,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Center(
                    child: StyledText(
                        outText:
                            'welcome back to Chick-Chack \n ready to organize your day ?',
                        size: 32,
                        color: kColorScheme.primary)),
                //Image.asset('assets/openScreen.png', height: screenHeight/5, width: screenWidth/3, fit: BoxFit.fill),
                const SizedBox(height: 10),
                TextFormField(
                  maxLength: 50,
                  decoration: const InputDecoration(
                    label: Text('E-mail'),
                  ),
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        value.trim().length <= 7 ||
                        value.trim().length > 50 ||
                        value.contains('@') == false) {
                      return 'Must be a valid FORMAT => ex. xxx@gmail.com';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _enterdEmail = value!;
                  },
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: TextFormField(
                        obscureText: _isObscure,
                        decoration: InputDecoration(
                          label: const Text('Password'),
                          suffixIcon: IconButton(
                            icon: Icon(_isObscure
                                ? Icons.visibility
                                : Icons.visibility_off),
                            onPressed: () {
                              setState(() {
                                _isObscure = !_isObscure;
                              });
                            },
                          ),
                        ),
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              value.trim().length <= 5 ||
                              value.trim().length > 50) {
                            return 'invalid password!';
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
                const SizedBox(height: 50),
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
                      onPressed: _submit,
                      child: const StyledText.white(
                        'Login',
                        size: 30,
                      ),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const IsStudent()));
                      },
                      child: const Text(
                        'Register here!',
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
