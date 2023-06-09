import 'package:dar_elanaqa/Constant.dart';
import 'package:dar_elanaqa/firebase_options.dart';
import 'package:dar_elanaqa/logic/models/booking.dart';
import 'package:dar_elanaqa/screens/AddBillScreen.dart';
import 'package:dar_elanaqa/screens/AddBookingScreen.dart';
import 'package:dar_elanaqa/screens/AddExpenseScreen.dart';
import 'package:dar_elanaqa/screens/bookingScreen.dart';
import 'package:dar_elanaqa/screens/homeScreen.dart';
import 'package:dar_elanaqa/screens/reportScreen.dart';
import 'package:dar_elanaqa/screens/signinScreen.dart';
import 'package:dar_elanaqa/widgets/loader.dart';
import 'package:dar_elanaqa/widgets/noConnection.dart';
import 'package:firebase_core/firebase_core.dart';

import 'screens/AddProductScreen.dart';
import 'screens/MainScreen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'ElMessiri',
        colorScheme: ColorScheme.fromSeed(seedColor: PrimaryColor),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      title: 'Dar ElanaQa',
      home: FutureBuilder(
          future: Firebase.initializeApp(
            options: DefaultFirebaseOptions.currentPlatform,
          ),
          builder: (context, db) {
            if (db.connectionState == ConnectionState.done) {
              return HomeScreen();
            } else {
              return NoInternet();
            }
          }),
      routes: {
        "/home": (context) => HomeScreen(),
        "/main": (context) => MainScreen(),
        "/signin": (context) => SignInScreen(),
        "/add-product": (context) => AddProductScreen(),
        "/add-booking": (context) => AddBookingScreen(),
        "/add-bill": (context) => AddBillScreen(),
        "/add-expense": (context) => AddExpenseScreen(),
        "/reports": (context) => ReportsScreen(),
      },
    );
  }
}
