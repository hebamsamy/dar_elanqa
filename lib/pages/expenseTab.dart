import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dar_elanaqa/logic/models/expense.dart';
import 'package:dar_elanaqa/widgets/loader.dart';
import 'package:dar_elanaqa/widgets/placeholder.dart';
import 'package:flutter/material.dart';

class ExpenseTab extends StatelessWidget {
  const ExpenseTab({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection("expenses").snapshots(),
      builder: (context, snapshot) {
        return (snapshot.connectionState == ConnectionState.active ||
                snapshot.connectionState == ConnectionState.done)
            ? snapshot.data?.docs.length == 0
                ? PlaceHolder(
                    msg: "لا يوجد نفقات بعد",
                  )
                : ListView(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 10),
                    children: snapshot.data?.docs.map((item) {
                          var data = Expense(
                              Id: item.id,
                              CostPrice: item.data()["CostPrice"] as double,
                              Notes: item.data()["Notes"]);
                          var temp = item.data()["CrearedAt"] as Timestamp;
                          data.CrearedAt = temp.toDate();
                          print(item.data()["CrearedAt"]);
                          return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Card(
                                  elevation: 10,
                                  child: ListTile(
                                    onTap: () {
                                      print(item.id);
                                    },
                                    title: Text(data.Notes),
                                    subtitle: Text(data.CrearedAt.toString()),
                                    trailing: Text(
                                        "التكلفه \n ${data.CostPrice.toString()}"),
                                  )));
                        }).toList() ??
                        [])
            : Loader(msg: "برجاء الانتظار");
      },
    );
  }
}
