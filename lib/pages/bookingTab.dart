import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dar_elanaqa/logic/models/booking.dart';
import 'package:dar_elanaqa/screens/bookingScreen.dart';
import 'package:dar_elanaqa/widgets/loader.dart';
import 'package:dar_elanaqa/widgets/placeholder.dart';
import 'package:flutter/material.dart';

class BookingTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection("bookings").snapshots(),
      builder: (context, snapshot) {
        return (snapshot.connectionState == ConnectionState.active ||
                snapshot.connectionState == ConnectionState.done)
            ? snapshot.data?.docs.length == 0
                ? PlaceHolder(
                    msg: "لا يوجد حجوزات بعد",
                  )
                : ListView(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 10),
                    children: snapshot.data?.docs.map((item) {
                          var data = Booking(
                              Id: item.id,
                              ProductId: item.data()["ProductId"],
                              ProductCode: item.data()["ProductCode"],
                              ClientPhone: item.data()["ClientPhone"],
                              Price: item.data()["Price"] as double,
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
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  BookingScreen(id: data.Id)));
                                    },
                                    title: Column(
                                      children: [
                                        Text(
                                            "${data.ProductCode} : كود المنتج"),
                                        Text(
                                            "${data.ClientPhone} : رقم العميل"),
                                      ],
                                    ),
                                    subtitle: Text(data.CrearedAt.toString()),
                                    trailing: Text(
                                        "المقدم \n ${data.Price.toString()}"),
                                  )));
                        }).toList() ??
                        [])
            : Loader(msg: "برجاء الانتظار");
      },
    );
  }
}
