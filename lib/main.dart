//import 'package:chick_chack_beta/screens/connecting_active_screen.dart';
import 'package:chick_chack_beta/screens/application_main.dart';
import 'package:chick_chack_beta/screens/first_time.dart';
// import 'package:chick_chack_beta/screens/missions/missions.dart';
// import 'package:chick_chack_beta/screens/waiting_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

var kColorScheme = ColorScheme.fromSeed(
  seedColor: Colors.cyan,
);

final theme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    // brightness: Brightness.light,
    seedColor: const Color.fromARGB(255, 2, 168, 163),
  ),
  textTheme: GoogleFonts.aladinTextTheme(),
  appBarTheme: const AppBarTheme(color: Color.fromARGB(255, 15, 121, 213)),
);

final FlutterLocalNotificationsPlugin FLNP = FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SystemChannels.textInput
      .invokeMethod('TextInput.hide'); // מבטל מקלדת בריסטארט חשוב!!!
  runApp(
    MaterialApp(
      // darkTheme: ThemeData.dark().copyWith(
      //   useMaterial3: true,
      //   colorScheme: kColorScheme,
      //   cardTheme: const CardTheme().copyWith(
      //     color: kColorScheme.primaryContainer,
      //     margin: const EdgeInsets.symmetric(
      //       horizontal: 10, //מהצדדים
      //       vertical: 6, //מלמעלה ומלמטה
      //     ),
      //   ),
      //   elevatedButtonTheme: ElevatedButtonThemeData(
      //     style: ElevatedButton.styleFrom(
      //       //copyWith במקום
      //       backgroundColor: kColorScheme.primaryContainer,
      //       foregroundColor: kColorScheme.onPrimaryContainer,
      //     ),
      //   ),
      // ), // DARK MODE CONFIGUARTION ENDS!
      theme: ThemeData().copyWith(
        //עיצוב האפליקציה הכולל בדיפולט
        useMaterial3: true,
        scaffoldBackgroundColor: const Color.fromARGB(255, 205, 232, 235),
        backgroundColor: const Color.fromARGB(243, 217, 237, 237),
        colorScheme: kColorScheme,
        appBarTheme: const AppBarTheme().copyWith(
          //נותן דיפולטים לפרמטרים שאנו לא נשנה
          backgroundColor: kColorScheme.onPrimaryContainer,
          foregroundColor: kColorScheme.primaryContainer,
        ),
        cardTheme: const CardTheme().copyWith(
          color: kColorScheme.secondaryContainer,
          margin: const EdgeInsets.symmetric(
            horizontal: 10, //מהצדדים
            vertical: 6, //מלמעלה ומלמטה
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            //copyWith במקום
            backgroundColor: kColorScheme.primary,
            foregroundColor: kColorScheme.onPrimary,
          ),
        ),
        textTheme: ThemeData().textTheme.copyWith(
              titleLarge: TextStyle(
                //שינוי הגדרות הדיפולט של העיצובים
                fontWeight: FontWeight.bold,
                color: kColorScheme.onSecondaryContainer,
                fontSize: 18,
              ),
            ),
      ),
      //themeMode: ThemeMode.system, //defualt
      home:
      StreamBuilder( 
// חשוב! הבנאי הזה מפעיל את האפליקציה בסך הראשי שיש טוקן וכשאין אז מסך התחברות
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: ((context, snapshot) {
          if (snapshot.hasData) {
            return const MainApp();
          }
          return const IsFirstTime();
        }),
      ),
    ),
  );
}
