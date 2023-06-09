import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dar_elanaqa/logic/models/bill.dart';
import 'package:dar_elanaqa/widgets/AlertMSG.dart';
import 'package:dar_elanaqa/widgets/loader.dart';
import 'package:dar_elanaqa/widgets/productItem.dart';
import '../Constant.dart';
import '../logic/models/product.dart';
import '../widgets/CustomButtonWidget.dart';
import 'package:flutter/material.dart';

class AddBillScreen extends StatefulWidget {
  @override
  State<AddBillScreen> createState() => _AddBillScreenState();
}

class _AddBillScreenState extends State<AddBillScreen> {
  bool isLoading = false;
  final fdb = FirebaseFirestore.instance;
  var formKey = GlobalKey<FormState>();
  var bill = Bill(
      Id: "",
      Notes: '',
      ClientPhone: '',
      CostPrice: 0.0,
      ProductId: "",
      ProductCode: "",
      ProductPrice: 0.0,
      Discount: 0.0);
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
    if (formKey.currentState!.validate() && !bill.ProductId.isEmpty) {
      formKey.currentState?.save();
      Map<String, dynamic> data = {
        "ProductId": bill.ProductId,
        "ProductCode": bill.ProductCode,
        "ProductPrice": bill.ProductPrice,
        "CostPrice": bill.CostPrice,
        "Discount": bill.Discount,
        "Notes": bill.Notes,
        "ClientPhone": bill.ClientPhone,
        "CrearedAt": bill.CrearedAt,
      };
      fdb.collection("bills").add(data).then((documentSnapshot) {
        print(documentSnapshot.id);
        setState(() {
          isLoading = false;
        });
        //
        Map<String, dynamic> data = {
          "Name": product.Name,
          "Code": product.Code,
          "ImgUrl": product.ImgUrl,
          "Description": product.Description,
          "BuyingPrice": product.BuyingPrice,
          "SellingPrice": product.SellingPrice,
          "Category": product.Category,
          "CreationDate": product.CreationDate,
          "IsDeleted": true,
          "IsAvailable": false,
        };
        fdb.collection("products").doc(product.Id).update(data).then((value) {
          showAlertDialog(
              context: context,
              title: "عمليه ناجحه",
              content: "تمت اضافه الفاتوره ",
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
        .where("Code", isEqualTo: bill.ProductCode)
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
          bill.ProductId = product.Id!;
          bill.ProductCode = product.Code;
          bill.ProductPrice = product.SellingPrice;
          bill.CostPrice = product.SellingPrice - bill.Discount;
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
                "تسجيل فاتوره جديد",
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
                              Text(bill.CrearedAt.toString()),
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
                              bill.ProductCode = value;
                            });
                          },
                          decoration: InputDecoration(
                            helperText: "يجب ادخال الكود اولا",
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
                      bill.ProductId.isEmpty
                          ? Image.asset(
                              "images/placeholder.png",
                              height: 200,
                            )
                          : ProductItem(product: product),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Row(
                          children: [
                            Expanded(
                                child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 5, bottom: 5, right: 5),
                              child: Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(width: 1, color: Colors.black),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Text(
                                  "سعر المنتج\n ${bill.ProductPrice}",
                                ),
                              ),
                            )),
                            Container(
                              width: 10,
                              child: Divider(
                                thickness: 5,
                                color: Colors.black,
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 5, bottom: 5, left: 5),
                                child: TextFormField(
                                  initialValue: bill.Discount.toString(),
                                  textDirection: TextDirection.rtl,
                                  textAlign: TextAlign.center,
                                  onChanged: (value) {
                                    setState(() {
                                      var convert = double.parse(value);
                                      bill.Discount = convert;
                                      bill.CostPrice =
                                          bill.ProductPrice - bill.Discount;
                                    });
                                  },
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    hintTextDirection: TextDirection.rtl,
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                        borderSide:
                                            BorderSide(color: Colors.black)),
                                    label: Text(
                                      " الخصم",
                                      textDirection: TextDirection.rtl,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text("سعر المنتج بعد الخصم"),
                            Text(bill.CostPrice.toString()),
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
                              bill.ClientPhone = value!;
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
                              return "يجب ادخال وصف كامل";
                            }
                            return null;
                          },
                          onSaved: (value) {
                            setState(() {
                              bill.Notes = value!;
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
