import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dar_elanaqa/widgets/AlertMSG.dart';
import 'package:dar_elanaqa/widgets/loader.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../Constant.dart';
import '../logic/models/product.dart';
import '../widgets/CustomButtonWidget.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddProductScreen extends StatefulWidget {
  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  bool isLoading = false;
  // Create a reference to the Firebase Storage bucket
  final storage = FirebaseStorage.instance;
  final fdb = FirebaseFirestore.instance;

  List<String> list = ["عبايه", "دراعه", "اكسسوار"];
  var formKey = GlobalKey<FormState>();
  File? image;
  var product = Product(
    Id: "",
    ImgUrl: "",
    Name: "",
    Description: "",
    Code: "0000",
    Category: "",
    BuyingPrice: 500,
    SellingPrice: 500,
    IsAvailable: true,
    IsDeleted: false,
  );
  void SaveForm() async {
    setState(() {
      isLoading = true;
    });
    if (formKey.currentState!.validate()) {
      formKey.currentState?.save();
      String fileName = '${product.Code}${Random().nextInt(1000)}';
      String filepath =
          "https://firebasestorage.googleapis.com/v0/b/dar-elanaqa.appspot.com/o/$fileName?alt=media&token=fb80b254-ac98-4c62-aa2e-780834cfe59c";
      Map<String, dynamic> data = {
        "Name": product.Name,
        "Code": product.Code,
        "ImgUrl": filepath,
        "Description": product.Description,
        "BuyingPrice": product.BuyingPrice,
        "SellingPrice": product.SellingPrice,
        "Category": product.Category,
        "CreationDate": product.CreationDate,
        "IsAvailable": product.IsAvailable,
        "IsDeleted": product.IsDeleted,
      };

      storage.ref(fileName).putFile(image!).then((res) {
        fdb.collection("products").add(data).then((documentSnapshot) {
          setState(() {
            isLoading = false;
          });
          showAlertDialog(
              context: context,
              title: "عمليه ناجحه",
              content: "${product.Code} تمت اضافه المنتج بكود",
              defaultActionText: "رجوع الي الرئسيه",
              onOkPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacementNamed("/main");
              },
              show: false);
        }).onError((error, stackTrace) => showAlertDialog(
            context: context,
            title: "حدث خطا",
            content: "لا يمكن رفع الصوره يرجي اعاده المحاوله",
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
          content: "لا يمكن رفع الصوره يرجي اعاده المحاوله",
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

  void takephoto() async {
    var imagepicker = ImagePicker();
    var file = await imagepicker.pickImage(source: ImageSource.camera);
    if (file == null) {
      showAlertDialog(
          context: context,
          title: "خطا",
          content: "يجب التقاط صوره",
          defaultActionText: "اعاده",
          onOkPressed: () {
            Navigator.of(context).pop();
          },
          show: false);
    } else {
      setState(() {
        this.image = File(file.path);
        print(image?.path);
      });
    }
  }

  void choosefromgallary() async {
    var imagepicker = ImagePicker();
    var file = await imagepicker.pickImage(source: ImageSource.gallery);
    if (file == null) {
      showAlertDialog(
          context: context,
          title: "خطا",
          content: "يجب اختيار صوره",
          defaultActionText: "اعاده",
          onOkPressed: () {
            Navigator.of(context).pop();
          },
          show: false);
    } else {
      setState(() {
        this.image = File(file.path);
        print(image?.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return !isLoading
        ? Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              foregroundColor: PrimaryColor,
              title: Text(
                "منتج جديد",
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
                        child: TextFormField(
                          textDirection: TextDirection.rtl,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "يجب ادخال اسم المنتج";
                            }
                            return null;
                          },
                          onSaved: (value) {
                            setState(() {
                              product.Name = value!;
                            });
                          },
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            hintTextDirection: TextDirection.rtl,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide(color: Colors.black)),
                            label: Text(
                              "أسم المنتج",
                              textDirection: TextDirection.rtl,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: TextFormField(
                          initialValue: product.Code,
                          textDirection: TextDirection.rtl,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "يجب ادخال كود المنتج";
                            }
                            return null;
                          },
                          onSaved: (value) {
                            setState(() {
                              product.Code = value!;
                            });
                          },
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintTextDirection: TextDirection.rtl,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide(color: Colors.black)),
                            label: Text(
                              "كود المنتج",
                              textDirection: TextDirection.rtl,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 5, bottom: 5, right: 5),
                                child: TextFormField(
                                  initialValue: product.SellingPrice.toString(),
                                  textDirection: TextDirection.rtl,
                                  textAlign: TextAlign.center,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "يجب ادخال سعر البيع";
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    setState(() {
                                      var convert = double.parse(value!);

                                      product.SellingPrice = convert;
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
                                      "سعر البيع",
                                      textDirection: TextDirection.rtl,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 5, bottom: 5, left: 5),
                                child: TextFormField(
                                  initialValue: product.BuyingPrice.toString(),
                                  textDirection: TextDirection.rtl,
                                  textAlign: TextAlign.center,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "يجب ادخال سعر الشراء";
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    setState(() {
                                      var convert = double.parse(value!);

                                      product.BuyingPrice = convert;
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
                                      "سعر الشراء",
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
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: TextFormField(
                          textDirection: TextDirection.rtl,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "يجب ادخال وصف المنتج";
                            }
                            return null;
                          },
                          onSaved: (value) {
                            setState(() {
                              product.Description = value!;
                            });
                          },
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            hintTextDirection: TextDirection.rtl,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide(color: Colors.black)),
                            label: Text(
                              "وصف المنتج",
                              textDirection: TextDirection.rtl,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              label: Text("تصنيف المنتج"),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide(color: Colors.black)),
                            ),
                            items: list
                                .map((e) => DropdownMenuItem<String>(
                                    value: e, child: Text(e)))
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                product.Category = value!;
                              });
                            },
                          )),
                      Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Expanded(
                                child: CircleAvatar(
                                  radius: 80,
                                  backgroundColor: PrimaryColor,
                                  foregroundColor: Colors.white,
                                  backgroundImage: (image == null)
                                      ? null
                                      : FileImage(image!),
                                  child:
                                      (image == null) ? Icon(Icons.add) : null,
                                ),
                              ),
                              Column(
                                children: [
                                  OutlinedButton.icon(
                                      style: OutlinedButton.styleFrom(
                                          foregroundColor: PrimaryColor),
                                      onPressed: takephoto,
                                      icon: Icon(Icons.camera),
                                      label: Text("Take photo")),
                                  OutlinedButton.icon(
                                      style: OutlinedButton.styleFrom(
                                          foregroundColor: PrimaryColor),
                                      onPressed: choosefromgallary,
                                      icon: Icon(Icons.photo_outlined),
                                      label: Text("Choose from gallary"))
                                ],
                              ),
                            ]),
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
