import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dar_elanaqa/Constant.dart';
import 'package:dar_elanaqa/logic/models/booking.dart';
import 'package:dar_elanaqa/logic/models/product.dart';
import 'package:dar_elanaqa/widgets/loader.dart';
import 'package:dar_elanaqa/widgets/productItem.dart';
import 'package:flutter/material.dart';

import '../widgets/AlertMSG.dart';

class BookingScreen extends StatefulWidget {
  BookingScreen({required this.id});
  String id;
  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final fdb = FirebaseFirestore.instance;
  Booking booking = Booking(
      Id: "",
      Price: 0,
      Notes: "",
      ClientPhone: "",
      ProductCode: "",
      ProductId: "");
  var product = Product(
      Id: "",
      ImgUrl: "",
      Name: "",
      Description: "",
      Code: "",
      Category: "",
      BuyingPrice: 0,
      SellingPrice: 0,
      IsAvailable: true,
      IsDeleted: false);
  bool isLoading = false;
  @override
  void initState() {
    setState(() {
      booking.Id = widget.id;
    });
    getBooking();
  }

  void getProduct() {
    fdb.collection("products").doc(booking.ProductId).get().then((res) {
      setState(() {
        product.Id = res.id;
        product.Code = res.data()!["Code"];
        product.Name = res.data()!["Name"];
        product.SellingPrice = res.data()!["SellingPrice"];
        product.BuyingPrice = res.data()!["BuyingPrice"];
        product.Category = res.data()!["Category"];
        product.ImgUrl = res.data()!["ImgUrl"];
        product.Description = res.data()!["Description"];
        var temp = res.data()!["CreationDate"] as Timestamp;
        product.CreationDate = temp.toDate();
        product.IsAvailable = res.data()!["IsAvailable"];
        product.IsDeleted = res.data()!["IsDeleted"];
      });
    });
  }

  void getBooking() {
    fdb.collection("bookings").doc(booking.Id).get().then((value) {
      print("booking");
      print(value.get("ProductCode"));
      setState(() {
        booking.Id = value.id;
        booking.Notes = value.data()!["Notes"];
        booking.Price = value.data()!["Price"];
        booking.ClientPhone = value.data()!["ClientPhone"];
        booking.ProductCode = value.data()!["ProductCode"];
        booking.ProductId = value.data()!["ProductId"];
        var temp = value.data()!["CrearedAt"] as Timestamp;
        booking.CrearedAt = temp.toDate();
        getProduct();
      });
    }).onError((error, stackTrace) => showAlertDialog(
        context: context,
        title: "حدث خطا",
        content: "لا يمكن الان يرجي اعاده المحاوله",
        defaultActionText: "اعاده",
        onOkPressed: () {
          Navigator.of(context).pop();
          setState(() {
            isLoading = false;
          });
        },
        show: false));
  }

  void accept() {
    //remove booking
    //add bill
    showAlertDialog(
        context: context,
        title: "تاكيد عمليه شراء هدا المنتج",
        content: " يجب تاكيد الحجز بعمل فاتوره \n ${product.Code} كود المنتج ",
        defaultActionText: "اذهب لعمل فاتوره",
        onOkPressed: () {
          fdb.collection("bookings").doc(booking.Id).delete().then((res) {
            Navigator.of(context).pop();
            Navigator.of(context)
                .pushReplacementNamed("/add-bill", arguments: booking);
          });
        },
        optinalActionText: "الغاء",
        optinalPressed: () {
          Navigator.of(context).pop();
        },
        show: true);
  }

  void cancel() {
    //dalete booking
    //availble product
    fdb.collection("bookings").doc(booking.Id).delete().then((res) {
      Map<String, dynamic> data = {
        "Name": product.Name,
        "Code": product.Code,
        "ImgUrl": product.ImgUrl,
        "Description": product.Description,
        "BuyingPrice": product.BuyingPrice,
        "SellingPrice": product.SellingPrice,
        "Category": product.Category,
        "CreationDate": product.CreationDate,
        "IsDeleted": false,
        "IsAvailable": true,
      };
      fdb.collection("products").doc(product.Id).update(data).then((value) {
        showAlertDialog(
            context: context,
            title: "عمليه ناجحه",
            content: "تمت الغاء الحجز \n ${product.Code} كود المنتج ",
            defaultActionText: "رجوع الي الرئسيه",
            onOkPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed("/main");
            },
            show: false);
      });
    }).onError((error, stackTrace) {
      showAlertDialog(
          context: context,
          title: "حدث خطا",
          content: "لا يمكن الاضافه الان يرجي اعاده المحاوله",
          defaultActionText: "اعاده",
          onOkPressed: () {
            Navigator.of(context).pop();
            setState(() {
              isLoading = false;
            });
          },
          show: false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("تاكيد او الغاء حجز")),
        body: (!booking.Id.isEmpty)
            ? ListView(children: [
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          "تاريج الحجز",
                          textAlign: TextAlign.right,
                          style: TextStyle(fontSize: 20),
                        ),
                        Text(booking.CrearedAt.toString()),
                        Text("المنتج المحجوز ")
                      ],
                    )),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: product.Id!.isEmpty
                      ? Image.asset(
                          "images/placeholder.png",
                          height: 200,
                        )
                      : ProductItem(product: product),
                ),
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
                        Text("${booking.Price} : تم دفع "),
                        Text(
                          "المتبقي للدفع ${(product.SellingPrice - booking.Price)}",
                        ),
                        Text("${booking.ClientPhone} : رقم العميل"),
                        Text("${booking.Notes} : الملاحظات"),
                      ],
                    ),
                  ),
                )),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: WhiteColor,
                            backgroundColor: GreenColor,
                            elevation: 5,
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50))),
                          ),
                          onPressed: accept,
                          child: Text("تاكيد"),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: WhiteColor,
                            backgroundColor: RedColor,
                            elevation: 5,
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50))),
                          ),
                          onPressed: cancel,
                          child: Text("الغاء"),
                        ),
                      ),
                    ),
                  ],
                )
              ])
            : Loader(msg: "جاري تحميل الحجز المطلوب"));
  }
}
