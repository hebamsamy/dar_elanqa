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
  double yestrdaydateBills = 0, yesterdaydateExpenses = 0;
  double monthBills = 0, monthExpenses = 0;
  double lastmonthBills = 0, lastmonthExpenses = 0;
  int getlastDay(int m) {
    if (m == 1 || m == 3 || m == 5 || m == 7 || m == 8 || m == 10 || m == 12) {
      return 31;
    } else if (m == 2) {
      return 28;
    } else if (m == 4 || m == 6 || m == 9 || m == 11) {
      return 30;
    } else {
      return 0;
    }
  }

  String getmonth(int m) {
    if (m == 1) {
      return "يناير";
    }
    if (m == 2) {
      return "فبراير";
    }
    if (m == 3) {
      return "مارس";
    }
    if (m == 4) {
      return "ايريل";
    }
    if (m == 5) {
      return "مايو";
    }
    if (m == 6) {
      return "يونيه";
    }
    if (m == 7) {
      return "يوليو";
    }
    if (m == 8) {
      return "اغسطس";
    }
    if (m == 9) {
      return "سبتمبر";
    }
    if (m == 10) {
      return "اكتوبر";
    }
    if (m == 11) {
      return "نوفمبر";
    }
    if (m == 12) {
      return "ديسمبر";
    } else {
      return "";
    }
  }

  var start = DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day, 0, 0, 0);
  var end = DateTime(DateTime.now().year, DateTime.now().month,
      DateTime.now().day, 23, 59, 59);
  var ystart = DateTime(DateTime.now().year, DateTime.now().month,
      (DateTime.now().day - 1), 0, 0, 0);
  var yend = DateTime(DateTime.now().year, DateTime.now().month,
      (DateTime.now().day - 1), 23, 59, 59);

  late DateTime mstart;
  late DateTime mend;
  late DateTime lastmstart;
  late DateTime lastmend;
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
        .collection("expenses")
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
        .collection("expenses")
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

    mstart = DateTime(DateTime.now().year, DateTime.now().month, 1, 0, 0, 0);
    mend = DateTime(DateTime.now().year, DateTime.now().month,
        getlastDay(DateTime.now().month), 23, 59, 59);

    lastmstart =
        DateTime(DateTime.now().year, DateTime.now().month - 1, 1, 0, 0, 0);
    lastmend = DateTime(DateTime.now().year, DateTime.now().month - 1,
        getlastDay(DateTime.now().month - 1), 23, 59, 59);
    fdb
        .collection("expenses")
        .where("CrearedAt", isLessThanOrEqualTo: mend)
        .where("CrearedAt", isGreaterThanOrEqualTo: mstart)
        .get()
        .then(
      (querySnapshot) {
        for (var docSnapshot in querySnapshot.docs) {
          var temp = docSnapshot.data()["CostPrice"] as double;
          setState(() {
            monthExpenses += temp;
          });
        }
      },
      onError: (e) => print("Error completing: $e"),
    );
    fdb
        .collection("bills")
        .where("CrearedAt", isLessThanOrEqualTo: mend)
        .where("CrearedAt", isGreaterThanOrEqualTo: mstart)
        .get()
        .then(
      (querySnapshot) {
        for (var docSnapshot in querySnapshot.docs) {
          var temp = docSnapshot.data()["CostPrice"] as double;
          setState(() {
            monthBills += temp;
          });
        }
      },
      onError: (e) => print("Error completing: $e"),
    );
    fdb
        .collection("expenses")
        .where("CrearedAt", isLessThanOrEqualTo: lastmend)
        .where("CrearedAt", isGreaterThanOrEqualTo: lastmstart)
        .get()
        .then(
      (querySnapshot) {
        for (var docSnapshot in querySnapshot.docs) {
          var temp = docSnapshot.data()["CostPrice"] as double;
          setState(() {
            lastmonthExpenses += temp;
          });
        }
      },
      onError: (e) => print("Error completing: $e"),
    );
    fdb
        .collection("bills")
        .where("CrearedAt", isLessThanOrEqualTo: lastmend)
        .where("CrearedAt", isGreaterThanOrEqualTo: lastmstart)
        .get()
        .then(
      (querySnapshot) {
        for (var docSnapshot in querySnapshot.docs) {
          var temp = docSnapshot.data()["CostPrice"] as double;
          setState(() {
            lastmonthBills += temp;
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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
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
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
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
        ),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.black),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  Text(
                    "تقرير هذا الشهر \n ${getmonth(mstart.month)}",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20),
                  ),
                  Text("${monthBills.toString()} : قيمه المبيعات "),
                  Text("${monthExpenses.toString()} : قيمه المصروفات "),
                ],
              ),
            )),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.black),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  Text(
                    "تقرير الشهر الماضي \n ${getmonth(lastmstart.month)}",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20),
                  ),
                  Text("${lastmonthBills.toString()} : قيمه المبيعات "),
                  Text("${lastmonthExpenses.toString()} : قيمه المصروفات "),
                ],
              ),
            )),
      ]),
    );
  }
}
