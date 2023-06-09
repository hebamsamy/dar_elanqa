import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  final fdb = FirebaseFirestore.instance;
  double todaydateBills = 0, todaydateExpenses = 0;
  double beforeyestrdaydateBills = 0, beforeyestrdaydateExpenses = 0;
  double yestrdaydateBills = 0, yesterdaydateExpenses = 0;
  var start = DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day, 0, 0, 0);
  var end = DateTime(DateTime.now().year, DateTime.now().month,
      DateTime.now().day, 23, 59, 59);
  var ystart = DateTime(DateTime.now().year, DateTime.now().month,
      (DateTime.now().day - 1), 0, 0, 0);
  var yend = DateTime(DateTime.now().year, DateTime.now().month,
      (DateTime.now().day - 1), 23, 59, 59);
  var yystart = DateTime(DateTime.now().year, DateTime.now().month,
      (DateTime.now().day - 2), 0, 0, 0);
  var yyend = DateTime(DateTime.now().year, DateTime.now().month,
      (DateTime.now().day - 2), 23, 59, 59);
  @override
  void initState() {
    fdb
        .collection("bills")
        .where("CrearedAt", isLessThanOrEqualTo: end)
        .where("CrearedAt", isGreaterThanOrEqualTo: start)
        .get()
        .then(
      (querySnapshot) {
        for (var docSnapshot in querySnapshot.docs) {
          var temp = docSnapshot.data()["CostPrice"] as double;
          setState(() {
            todaydateBills += temp;
          });
        }
      },
      onError: (e) => print("Error completing: $e"),
    );
    fdb
        .collection("bills")
        .where("CrearedAt", isLessThanOrEqualTo: yyend)
        .where("CrearedAt", isGreaterThanOrEqualTo: yystart)
        .get()
        .then(
      (querySnapshot) {
        for (var docSnapshot in querySnapshot.docs) {
          var temp = docSnapshot.data()["CostPrice"] as double;
          setState(() {
            beforeyestrdaydateBills += temp;
          });
        }
      },
      onError: (e) => print("Error completing: $e"),
    );
    fdb
        .collection("bills")
        .where("CrearedAt", isLessThanOrEqualTo: yend)
        .where("CrearedAt", isGreaterThanOrEqualTo: ystart)
        .get()
        .then(
      (querySnapshot) {
        for (var docSnapshot in querySnapshot.docs) {
          var temp = docSnapshot.data()["CostPrice"] as double;
          setState(() {
            yestrdaydateBills += temp;
          });
        }
      },
      onError: (e) => print("Error completing: $e"),
    );
    fdb
        .collection("expenees")
        .where("CrearedAt", isLessThanOrEqualTo: end)
        .where("CrearedAt", isGreaterThanOrEqualTo: start)
        .get()
        .then(
      (querySnapshot) {
        for (var docSnapshot in querySnapshot.docs) {
          var temp = docSnapshot.data()["CostPrice"] as double;
          setState(() {
            todaydateExpenses += temp;
          });
        }
      },
      onError: (e) => print("Error completing: $e"),
    );
    fdb
        .collection("expenees")
        .where("CrearedAt", isLessThanOrEqualTo: yend)
        .where("CrearedAt", isGreaterThanOrEqualTo: ystart)
        .get()
        .then(
      (querySnapshot) {
        for (var docSnapshot in querySnapshot.docs) {
          var temp = docSnapshot.data()["CostPrice"] as double;
          setState(() {
            yesterdaydateExpenses += temp;
          });
        }
      },
      onError: (e) => print("Error completing: $e"),
    );
    fdb
        .collection("expenees")
        .where("CrearedAt", isLessThanOrEqualTo: yyend)
        .where("CrearedAt", isGreaterThanOrEqualTo: yystart)
        .get()
        .then(
      (querySnapshot) {
        for (var docSnapshot in querySnapshot.docs) {
          var temp = docSnapshot.data()["CostPrice"] as double;
          setState(() {
            beforeyestrdaydateExpenses += temp;
          });
        }
      },
      onError: (e) => print("Error completing: $e"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("التقارير"),
      ),
      body: ListView(children: [
        Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "تاريج اليوم",
                  textAlign: TextAlign.right,
                  style: TextStyle(fontSize: 20),
                ),
                Text(DateTime.now().toString()),
              ],
            )),
        Expanded(
            child: Padding(
          padding: const EdgeInsets.all(15),
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(width: 1, color: Colors.black),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              children: [
                const Text(
                  "تقرير اليوم",
                  textAlign: TextAlign.right,
                  style: TextStyle(fontSize: 20),
                ),
                Text("${todaydateBills.toString()} : قيمه المبيعات "),
                Text("${todaydateExpenses.toString()} : قيمه المصروفات "),
              ],
            ),
          ),
        )),
        Expanded(
            child: Padding(
          padding: const EdgeInsets.all(15),
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(width: 1, color: Colors.black),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              children: [
                const Text(
                  "تقرير امس",
                  textAlign: TextAlign.right,
                  style: TextStyle(fontSize: 20),
                ),
                Text("${yestrdaydateBills.toString()} : قيمه المبيعات "),
                Text("${yesterdaydateExpenses.toString()} : قيمه المصروفات "),
              ],
            ),
          ),
        )),
        Expanded(
            child: Padding(
          padding: const EdgeInsets.all(15),
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(width: 1, color: Colors.black),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              children: [
                const Text(
                  "تقرير اول امس",
                  textAlign: TextAlign.right,
                  style: TextStyle(fontSize: 20),
                ),
                Text("${beforeyestrdaydateBills.toString()} : قيمه المبيعات "),
                Text(
                    "${beforeyestrdaydateExpenses.toString()} : قيمه المصروفات "),
              ],
            ),
          ),
        )),
      ]),
    );
  }
}
