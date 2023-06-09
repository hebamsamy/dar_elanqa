import 'package:dar_elanaqa/pages/bookingTab.dart';
import 'package:dar_elanaqa/pages/rentaltab.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../Constant.dart';
import '../pages/expenseTab.dart';
import 'package:flutter/material.dart';

class ManagementScreen extends StatefulWidget {
  @override
  State<ManagementScreen> createState() => _ManagementScreenState();
}

class _ManagementScreenState extends State<ManagementScreen> {
  int current = 0;
  List<Widget> list = [
    Text("تسجيل فاتوره جديدة"),
    Text("تسجيل حجز جديدة"),
    Text("تسجيل نفقه جديدة")
  ];
  var currentAccount = FirebaseAuth.instance.currentUser;

  List<Color> cols = [GreenColor, PrimaryColor, RedColor];
  Widget isAuth() {
    if (currentAccount!.email != "seller@darelanqa.com") {
      return OutlinedButton.icon(
        label: Text("عرض"),
        icon: Icon(Icons.show_chart),
        onPressed: () {
          Navigator.of(context).pushNamed("/reports");
        },
        style: OutlinedButton.styleFrom(
          foregroundColor: WhiteColor,
          backgroundColor: PrimaryColor,
          elevation: 5,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(50))),
        ),
      );
    } else {
      return Text(
          "اليوم ${DateTime.now().day} - ${DateTime.now().month} - ${DateTime.now().year}");
    }
  }

  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: WhiteColor,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                "التقارير",
                style: TextStyle(color: BlackColor, fontSize: 25),
              ),
              isAuth(),
            ],
          ),
          bottom: TabBar(
            onTap: (value) {
              setState(() {
                current = value;
              });
            },
            labelStyle: TextStyle(fontSize: 20),
            labelColor: PrimaryColor,
            indicatorColor: PrimaryColor,
            tabs: const [
              Tab(
                text: 'الفواتير',
              ),
              Tab(
                text: 'حجوزات',
              ),
              Tab(
                text: 'النفقات',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [BillsTab(), BookingTab(), ExpenseTab()],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            //todo navigation
            if (current == 0) {
              //add bill
              Navigator.of(context).pushNamed("/add-bill");
            } else if (current == 1) {
              //add booking
              Navigator.of(context).pushNamed("/add-booking");
            } else {
              //add expense
              Navigator.of(context).pushNamed("/add-expense");
            }
          },
          icon: Icon(Icons.attach_money_sharp),
          label: list[current],
          foregroundColor: Colors.white,
          backgroundColor: cols[current],
          elevation: 5,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(50))),
        ),
      ),
    );
  }
}
