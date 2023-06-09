import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dar_elanaqa/widgets/placeholder.dart';
import 'package:flutter/material.dart';

import '../logic/models/bill.dart';
import '../widgets/loader.dart';

class BillsTab extends StatelessWidget {
  const BillsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection("bills").snapshots(),
      builder: (context, snapshot) {
        return (snapshot.connectionState == ConnectionState.active ||
                snapshot.connectionState == ConnectionState.done)
            ? snapshot.data?.docs.length == 0
                ? PlaceHolder(
                    msg: "لا يوجد فواتير بعد",
                  )
                : ListView(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 10),
                    children: snapshot.data?.docs.map((item) {
                          var bill = Bill(
                            Id: item.id,
                            CostPrice: item.data()["CostPrice"],
                            ProductCode: item.data()["ProductCode"] ?? 0,
                            ProductPrice: item.data()["ProductPrice"] ?? 0,
                            Discount: item.data()["Discount"] ?? 0,
                            ProductId: item.data()["ProductId"],
                            Notes: item.data()["Notes"],
                            ClientPhone: item.data()["ClientPhone"],
                          );
                          var temp = item.data()["CrearedAt"] as Timestamp;
                          bill.CrearedAt = temp.toDate();
                          return BillItem(bill: bill);
                        }).toList() ??
                        [])
            : Loader(msg: "برجاء الانتظار");
      },
    );
  }
}

class BillItem extends StatelessWidget {
  BillItem({required this.bill});
  Bill bill;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Card(
        elevation: 10,
        child: ListTile(
          onTap: () {
            print(bill.Id);
          },
          title: Column(
            children: [
              Text("${bill.ProductCode} : كود المنتج"),
              Text("${bill.ClientPhone} : رقم العميل"),
            ],
          ),
          subtitle: Column(children: [
            Text("${bill.CostPrice} : سعر البيع"),
            Text("${bill.CrearedAt} : التاريخ"),
          ]),
        ),
      ),
    );
  }
}
