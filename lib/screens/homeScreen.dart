import 'package:dar_elanaqa/Constant.dart';
import 'package:dar_elanaqa/widgets/loader.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var currentUser = FirebaseAuth.instance.currentUser;

  void check() {
    Future.delayed(Duration(seconds: 5), () {
      if (currentUser != null) {
        print(currentUser);
        Navigator.of(context).pushReplacementNamed("/main");
      } else {
        print("must log in");
        Navigator.of(context).pushReplacementNamed("/signin");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    check();
    return Scaffold(
        // body: Center(child: Image.asset("images/DarElanaqa.jpeg")),
        body: Loader(msg: "جاري قراءه البيانات"));
  }
}
