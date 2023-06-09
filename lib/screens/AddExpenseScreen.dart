import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dar_elanaqa/logic/models/expense.dart';
import 'package:dar_elanaqa/widgets/AlertMSG.dart';
import 'package:dar_elanaqa/widgets/loader.dart';
import '../Constant.dart';
import '../widgets/CustomButtonWidget.dart';
import 'package:flutter/material.dart';

class AddExpenseScreen extends StatefulWidget {
  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  bool isLoading = false;
  final fdb = FirebaseFirestore.instance;
  var formKey = GlobalKey<FormState>();
  var expense = Expense(Id: "", CostPrice: 1.0, Notes: '');
  void SaveForm() async {
    setState(() {
      isLoading = true;
    });
    if (formKey.currentState!.validate()) {
      formKey.currentState?.save();
      Map<String, dynamic> data = {
        "CostPrice": expense.CostPrice,
        "Notes": expense.Notes,
        "CrearedAt": expense.CrearedAt,
      };
      fdb.collection("expenses").add(data).then((documentSnapshot) {
        print(documentSnapshot.id);
        setState(() {
          isLoading = false;
        });
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
                "فاتوره نفقيه جديد",
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
                              Text(expense.CrearedAt.toString()),
                            ],
                          )),
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
                          onSaved: (value) {
                            setState(() {
                              expense.CostPrice = double.parse(value!);
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
                              expense.Notes = value!;
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
