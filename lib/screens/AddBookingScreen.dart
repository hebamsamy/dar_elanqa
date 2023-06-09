import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dar_elanaqa/logic/models/booking.dart';
import 'package:dar_elanaqa/logic/models/product.dart';
import 'package:dar_elanaqa/widgets/AlertMSG.dart';
import 'package:dar_elanaqa/widgets/loader.dart';
import 'package:dar_elanaqa/widgets/productItem.dart';
import '../Constant.dart';
import '../widgets/CustomButtonWidget.dart';
import 'package:flutter/material.dart';

class AddBookingScreen extends StatefulWidget {
  @override
  State<AddBookingScreen> createState() => _AddBookingScreenState();
}

class _AddBookingScreenState extends State<AddBookingScreen> {
  bool isLoading = false;
  final fdb = FirebaseFirestore.instance;
  var formKey = GlobalKey<FormState>();
  var booking = Booking(
      Id: "",
      Price: 0,
      Notes: '',
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
  void SaveForm() async {
    setState(() {
      isLoading = true;
    });
    if (formKey.currentState!.validate()) {
      formKey.currentState?.save();
      Map<String, dynamic> data = {
        "Price": booking.Price,
        "ClientPhone": booking.ClientPhone,
        "ProductCode": booking.ProductCode,
        "ProductId": booking.ProductId,
        "Notes": booking.Notes,
        "CrearedAt": booking.CrearedAt,
      };
      fdb.collection("bookings").add(data).then((documentSnapshot) {
        print(documentSnapshot.id);
        setState(() {
          isLoading = false;
        });
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
          "IsAvailable": false,
        };
        fdb.collection("products").doc(product.Id).update(data).then((value) {
          showAlertDialog(
              context: context,
              title: "عمليه ناجحه",
              content: "تمت اضافه الحجز ",
              defaultActionText: "رجوع الي الرئسيه",
              onOkPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacementNamed("/main");
              },
              show: false);
        }).onError((error, stackTrace) => showAlertDialog(
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
            show: false));
      }).onError((error, stackTrace) => showAlertDialog(
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
          show: false));
    }
  }

  void getProduct() {
    fdb
        .collection("products")
        .where("Code", isEqualTo: booking.ProductCode)
        .get()
        .then((res) {
      if (res.docs.length == 0) {
        showAlertDialog(
            context: context,
            title: "الكود خاطي",
            content: "لا يوجد منتج بهذا الكود حاول مره الخري",
            defaultActionText: "اعاده",
            onOkPressed: () {
              Navigator.of(context).pop();
            },
            show: false);
      } else {
        setState(() {
          product.Id = res.docs[0].id;
          product.Code = res.docs[0].data()["Code"];
          product.Name = res.docs[0].data()["Name"];
          product.SellingPrice = res.docs[0].data()["SellingPrice"];
          product.BuyingPrice = res.docs[0].data()["BuyingPrice"];
          product.Category = res.docs[0].data()["Category"];
          product.ImgUrl = res.docs[0].data()["ImgUrl"];
          product.Description = res.docs[0].data()["Description"];
          var temp = res.docs[0].data()["CreationDate"] as Timestamp;
          product.CreationDate = temp.toDate();
          product.IsAvailable = res.docs[0].data()["IsAvailable"];
          product.IsDeleted = res.docs[0].data()["IsDeleted"];
          // update bill
          booking.ProductId = product.Id!;
          booking.ProductCode = product.Code;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return !isLoading
        ? Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              foregroundColor: PrimaryColor,
              title: Text(
                "اضافه حجر جديد",
                style: TextStyle(fontSize: 25),
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    formKey.currentState?.reset();
                  },
                  icon: Icon(
                    Icons.refresh,
                  ),
                )
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                  key: formKey,
                  child: ListView(
                    children: [
                      Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "تاريج اليوم",
                                textAlign: TextAlign.right,
                                style: TextStyle(fontSize: 20),
                              ),
                              Text(booking.CrearedAt.toString()),
                            ],
                          )),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: TextFormField(
                          textDirection: TextDirection.rtl,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "يجب ادخال الكود اولا";
                            }
                            return null;
                          },
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            setState(() {
                              booking.ProductCode = value;
                            });
                          },
                          decoration: InputDecoration(
                            helperText: " يجب ادخال الكود ثم اضغط علي البحث",
                            icon: IconButton(
                                onPressed: getProduct,
                                icon: Icon(Icons.search)),
                            hintTextDirection: TextDirection.rtl,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide(color: Colors.black)),
                            label: Text(
                              "بحث عن كود منتج",
                              textDirection: TextDirection.rtl,
                            ),
                          ),
                        ),
                      ),
                      booking.ProductCode.isEmpty
                          ? Image.asset(
                              "images/placeholder.png",
                              height: 200,
                            )
                          : ProductItem(product: product),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: TextFormField(
                          textDirection: TextDirection.rtl,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "يجب ادخال القيمه المدفوعه";
                            }
                            return null;
                          },
                          onChanged: (value) {
                            setState(() {
                              booking.Price = double.parse(value!);
                            });
                          },
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintTextDirection: TextDirection.rtl,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide(color: Colors.black)),
                            label: Text(
                              "القيمه المدفوعه",
                              textDirection: TextDirection.rtl,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text("القيمه المتبقيه "),
                            Text((product.SellingPrice - booking.Price)
                                .toString()),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: TextFormField(
                          textDirection: TextDirection.rtl,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "يجب ادخال رقم العميل";
                            }
                            return null;
                          },
                          onSaved: (value) {
                            setState(() {
                              booking.ClientPhone = value!;
                            });
                          },
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintTextDirection: TextDirection.rtl,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide(color: Colors.black)),
                            label: Text(
                              "رقم العميل",
                              textDirection: TextDirection.rtl,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: TextFormField(
                          textDirection: TextDirection.rtl,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "يجب ادخال وصف كامل بالسبب";
                            }
                            return null;
                          },
                          onSaved: (value) {
                            setState(() {
                              booking.Notes = value!;
                            });
                          },
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            hintTextDirection: TextDirection.rtl,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide(color: Colors.black)),
                            label: Text(
                              "ملاحظات",
                              textDirection: TextDirection.rtl,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 30),
                        child: CustomButtonWidget(
                            msg: "حفظ",
                            handelpress: SaveForm,
                            color: PrimaryColor),
                      ),
                    ],
                  )),
            ),
          )
        : Scaffold(
            body: Loader(
            msg: 'جاري حفظ البيانات',
          ));
  }
}
